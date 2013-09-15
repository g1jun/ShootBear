//
//  ILShooterArm.m
//  ShootBear
//
//  Created by mac on 13-8-10.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILShooterArm.h"
#import "CCControlExtension.h"
#import "CCBReader.h"
#import "CCBAnimationManager+RmoveDeadNode.h"
#import "CCNode+CCBRelativePositioning.h"

#define ANGLE_STEP 0.0001

@interface ILShooterArm ()


@end

@implementation ILShooterArm

- (void)dealloc
{
    _gun = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _isCannon = NO;
         [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:10 swallowsTouches:NO];
    }
    return self;
}

- (void)didLoadFromCCB
{
    
}

- (CGPoint)rotationCenterPosition
{
    if (_isCannon) {
        return [self.gun.parent convertToWorldSpace:self.gun.position];
    }
    
    return [self.parent convertToWorldSpace:self.position];
}


- (float)lineDegree
{
    return self.gun.lineReference.rotation;
}

- (void)setAllRotation:(float)rotation
{
    if (_isCannon) {
        self.gun.rotation = rotation - self.gun.rotation - self.gun.lineReference.rotation;
        [self fixRotaionDegree:self.gun];
        return;
    }
    [super setRotation:(rotation -  self.gun.rotation - self.gun.lineReference.rotation)];
    [self fixRotaionDegree:self];

}

- (BOOL) hasVisibleParents
{
    for( CCNode *c = self.parent; c != nil; c = c.parent )
    {
		if( !c.visible ) return NO;
    }
    return YES;
}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self rotationToTouchPoint:touch];
    
    return YES;
}

- (float)currentDegree
{
    return [self.gun lineTotalDegree];
}


- (void)rotationToTouchPoint:(UITouch *)touch
{
    CGPoint glPoint = [[CCDirector sharedDirector] convertTouchToGL:touch];
    CGPoint centerPoint = _isCannon ? [self.gun.parent convertToWorldSpace:self.gun.position]
     : [self.parent convertToWorldSpace:self.position];
    CGPoint targetVector = ccpSub(glPoint, centerPoint);
    float radians = ccpToAngle(targetVector);
    float angle = -CC_RADIANS_TO_DEGREES(radians); 
    float step = angle  - [self currentDegree];
    if (fabs(step) < ANGLE_STEP) {
        return;
    }
    if (_isCannon) {
        self.gun.rotation += step;
        [self fixRotaionDegree:self.gun];
    } else {
        self.rotation += step;
        [self fixRotaionDegree:self];
    }
}

- (void)fixRotaionDegree:(CCNode *)node
{
    if (node.rotation > 360) {
        node.rotation -= 360;
    }
    if (node.rotation < -360) {
        node.rotation += 360;
    }
}

- (void)onEnter
{
    [super onEnter];
   
}

- (void)stopAccpetTouch
{
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self rotationToTouchPoint:touch];
}

- (BOOL)touchNOResponseArea:(UITouch *)touch
{
    CGPoint noResponseCenter = _isCannon ? self.gun.position : CGPointZero;
    const float offset = 10 * [self resolutionScale];
    CGRect area = CGRectMake(noResponseCenter.x - offset, noResponseCenter.y - offset, 2 * offset, 2 * offset);
    if (CGRectContainsPoint(area, [self convertTouchToNodeSpace:touch])) {
        return YES;
    }
    return NO;
}


- (void)replaceGunType:(NSString * )type
{
    ILGun *newGun = (ILGun *)[CCBReader nodeGraphFromFile:type];
    CCBAnimationManager *manager = self.gun.userObject;
    [manager removeDeadNode:self.gun];
    newGun.position = self.gun.position;
    [self removeChild:self.gun];
    self.gun = newGun;
    [self.gun setTexture:self.textureAtlas.texture];
    [self addChild:self.gun z:-1];
}

@end
