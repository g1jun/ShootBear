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

@property (assign, nonatomic) CGPoint prePoint;

@end

@implementation ILShooterArm

- (void)didLoadFromCCB
{
    float degree = - self.gun.lineReference.rotation;
    float radius = CC_DEGREES_TO_RADIANS(degree);
    self.prePoint = ccpRotateByAngle(ccp(100, 0), ccp(0, 0), radius);
     [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:NO];
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
    if (!self.visible || ![ self hasVisibleParents])
    {
		return NO;
	}
//    CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
//    if (touchPoint.x == 0 && touchPoint.y == 0) {
//        return NO;
//    }
//    float degree = - self.rotation;
//    float x = touchPoint.x * cos(degree) - touchPoint.y * sin(degree);
//    float y = touchPoint.x * cos(degree) + touchPoint.y * sin(degree);
//    return CGRectContainsPoint([_touchRotation boundingBox], ccp(x, y));
    
    
    
    return YES;
}

- (void)rotation:(UITouch *)touch
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
    float radians = ccpAngle(self.prePoint, touchPoint);
    float angle = -1 * CC_RADIANS_TO_DEGREES(radians);
    if (ABS(angle) > ANGLE_STEP) {
        self.rotation += angle;
        self.prePoint = touchPoint;
    }
    NSLog(@"touhc--->%@", NSStringFromCGPoint(touchPoint));
    NSLog(@"====>%f", angle);
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
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)fire:(CGPoint) startPoint angle:(float)angle
{
    
}

@end
