//
//  ILBullet.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-14.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBullet.h"
#import "CCNode+CCBRelativePositioning.h"
#import "ILBulletEntityBase.h"

@implementation ILBullet

- (void)didLoadFromCCB
{
    _particle.positionType = kCCPositionTypeFree;
    _particle.position = CGPointZero;
}

- (void)onEnter
{
    [super onEnter];
    [self lifeStart];
}



- (void)setSpeedVector:(CGPoint)speed
{
    [super setSpeedVector:speed];
    _speed = ccpLength(speed) * [self resolutionScale];
}





- (void)update:(ccTime)delta
{
    [super update:delta];
    if (_particle) {
        _particle.sourcePosition = ccpMult(self.entity.position, 1 / [self resolutionScale]);
    }
    b2Vec2 vec = self.entity.b2Body->GetLinearVelocity();
    vec.Normalize();
    vec.operator*=(_speed);
    self.entity.b2Body->SetLinearVelocity(vec);
}



- (void)lifeEnd
{
    [self unscheduleUpdate];
    [self removeFromParent];
}




@end
