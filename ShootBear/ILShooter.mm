//
//  ILShooter.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-8.
//  Copyright 2013年 mac. All rights reserved.
//

#import "ILShooter.h"


@implementation ILShooter

- (id)init
{
    self = [super init];
    if (self) {
        _batchNode = [CCSpriteBatchNode batchNodeWithFile:@"people.png"];
        [super addChild:_batchNode];
    }
    return self;
}

- (void)addChild:(CCNode *)node
{
    CCSprite *sprite = (CCSprite *)node;
    [sprite setTexture:_batchNode.textureAtlas.texture];
    [_batchNode addChild:sprite];
}

- (void)didLoadFromCCB
{
    [_leftShooter.arm setAllRotation:_shooterRotation];
    [_rightShooter.arm setAllRotation:_shooterRotation];
    [self turnRight];
    [self scheduleUpdate];
    [self syncPosition];
    if (_updateGun) {
        _rightShooter.arm.updateGunDirection = YES;
        _leftShooter.arm.updateGunDirection = YES;
    }
}

- (void)onEnter
{
    [super onEnter];
    
}

- (void)turnRight
{
    _leftShooter.visible = NO;
    _rightShooter.visible = YES;
}

- (void)syncPosition
{
    CGPoint leftTargetPosition = [_leftShooter.arm rotationCenterPosition];
    CGPoint rightPosition = [_rightShooter.arm rotationCenterPosition];
    CGPoint offset = ccpSub(leftTargetPosition, rightPosition);
    CGPoint targetPosition = ccpAdd(offset, _rightShooter.position);
    _rightShooter.position = targetPosition;
}

- (void)turnLeft
{
//    if (_rightShooter.visible) {
//        CGPoint firePoint = [_rightShooter firePointGL];
//        CGPoint firePoint2 = [_leftShooter firePointGL];
//        CGPoint ret = ccpSub(firePoint, firePoint2);
//        CGPoint position = ccp(ret.x + _leftShooter.position.x, _leftShooter.position.y);
//        _leftShooter.position = position;
//    }
    _leftShooter.visible = YES;
    _rightShooter.visible = NO;
}


- (void)update:(ccTime)delta
{
    float leftDegree = [_leftShooter totalRotation];
//    NSLog(@"left-->%f", leftDegree);
//    NSLog(@"right-->%f", [_rightShooter totalRotation]);
//    CGPoint leftTargetPosition = [_leftShooter.arm rotationCenterPosition];
//    CGPoint rightPosition = [_rightShooter.arm rotationCenterPosition];
//    NSLog(@"leftPos-->%@", NSStringFromCGPoint(leftTargetPosition));
//    NSLog(@"rightPos-->%@", NSStringFromCGPoint(rightPosition));

    if (270 >fabs(leftDegree) && fabs(leftDegree) > 90) {
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
    [self syncPosition];
}

@end
