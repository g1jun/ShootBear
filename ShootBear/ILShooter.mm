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
    [self turnRight];
    [self scheduleUpdate];
}

- (void)turnRight
{
    _leftShooter.visible = NO;
    _rightShooter.visible = YES;
}

- (void)turnLeft
{
    if (_rightShooter.visible) {
        CGPoint firePoint = [_rightShooter firePointGL];
        CGPoint firePoint2 = [_leftShooter firePointGL];
        CGPoint ret = ccpSub(firePoint, firePoint2);
        CGPoint position = ccp(ret.x + _leftShooter.position.x, _leftShooter.position.y);
        _leftShooter.position = position;
    }
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

- (void)fire
{
    if (_leftShooter.visible) {
        [_leftShooter.arm.gun fire];
    }
    if (_rightShooter.visible) {
        [_rightShooter.arm.gun fire];
    }
}

- (void)replaceGunType:(NSString *)type
{
    NSString *const ccbRightFileName = [type stringByAppendingString:@"Right.ccbi"];
    [_rightShooter replaceGunType:ccbRightFileName];
    NSString *const ccbLeftFileName = [type stringByAppendingString:@"Left.ccbi"];
    [_leftShooter replaceGunType:ccbLeftFileName];
}

@end
