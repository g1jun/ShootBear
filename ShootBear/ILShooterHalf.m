//
//  ILShooterHalf.m
//  ShootBear
//
//  Created by mac on 13-8-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILShooterHalf.h"
#import "ILShooter.h"
#import "CCBReader.h"
#import "CCBAnimationManager+RmoveDeadNode.h"

@implementation ILShooterHalf

- (void)dealloc
{
    _arm = nil;
    [super dealloc];
}

- (void)resetRotation
{
    self.arm.rotation = 0;
}

- (float)totalRotation
{
    return [self.arm currentDegree];
}

- (void)replaceGunType:(NSString * )type
{
    if ([type hasPrefix:kCannon]) {
        ILShooterArm *cannonArm = (ILShooterArm *)[CCBReader nodeGraphFromFile:type];
        CCBAnimationManager *manager = self.userObject;
        [manager removeDeadNode:self.arm];
        cannonArm.position = self.arm.position;
        [self removeChild:self.arm cleanup:YES];
        [self.arm stopAccpetTouch];
        self.arm = cannonArm;
        [self addChild:self.arm];
        return;
    }
    [self.arm replaceGunType:type];
}


- (CGPoint)firePointGL
{
    CCNode *line = self.arm.gun.lineReference;
    return [line.parent convertToWorldSpace:line.position];
}



@end
