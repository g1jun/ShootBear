//
//  ILShooterArm.m
//  ShootBear
//
//  Created by mac on 13-8-10.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILShooterArm.h"
#import "CCControlExtension.h"
#define ANGLE_STEP 0.00001

@interface ILShooterArm ()


@end

@implementation ILShooterArm

- (void)didLoadFromCCB
{
   
     [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:NO];
}


- (float)lineDegree
{
    return self.gun.lineReference.rotation;
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
    return self.rotation + [self lineDegree];
}

- (void)rotationToTouchPoint:(UITouch *)touch
{
    CGPoint glPoint = [[CCDirector sharedDirector] convertTouchToGL:touch];
    CGPoint targetVector = ccpSub(glPoint, [self.parent convertToWorldSpace:self.position]);
    float radians = ccpToAngle(targetVector);
    float angle = -CC_RADIANS_TO_DEGREES(radians);
    float step = angle  - [self currentDegree];
    if (fabs(step) > ANGLE_STEP) {
        self.rotation += step;
        [self fixRotaionDegree];
    }


}

- (void)fixRotaionDegree
{
    if (self.rotation > 360) {
        self.rotation -= 360;
    }
    if (self.rotation < -360) {
        self.rotation += 360;
    }
}

- (void)onEnter
{
    [super onEnter];
   
}

- (void)onExit
{
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
    [super onExit];
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self rotationToTouchPoint:touch];
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self.gun fire];
}

@end
