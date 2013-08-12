//
//  ILShooter.m
//  ShootBear
//
//  Created by mac on 13-8-8.
//  Copyright 2013年 mac. All rights reserved.
//

#import "ILShooter.h"


@implementation ILShooter

- (void)didLoadFromCCB
{
    _leftShooter.visible = YES;
    _rightShooter.visible = NO;
    [self scheduleUpdate];
}

- (void)turnRight
{
    _leftShooter.visible = NO;
    _rightShooter.visible = YES;
}

- (void)turnLeft
{
    _leftShooter.visible = YES;
    _rightShooter.visible = NO;
}


- (void)update:(ccTime)delta
{
    float leftDegree = [_leftShooter totalRotation];
    if (180 >fabs(leftDegree) && fabs(leftDegree) > 90) {
        [self turnLeft];
    } else {
        [self turnRight];
    }
}

@end
