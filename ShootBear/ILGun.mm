//
//  ILGun.m
//  ShootBear
//
//  Created by mac on 13-8-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILGun.h"
#import "ILTools.h"
#import "ILBox2dEntity.h"
#import "CCBReader.h"
#import "ILBox2dFactory.h"
#import "ILBullet.h"
#import "CCBReader.h"
#import "ILShooter.h"
#import "CCBAnimationManager.h"

#define BULLET 30

#define BULLET_SPPED 5

@implementation ILGun

- (void)dealloc
{
    _lineReference = nil;
    [super dealloc];
}

- (ILBullet *)bulletInstance
{
    NSString *bulletFileName = [_bulletCCBName stringByAppendingString:@".ccbi"];
    ILBullet *bullet = (ILBullet *)[CCBReader nodeGraphFromFile:bulletFileName];
    return bullet;
}


- (void)fire
{
    ILBullet *bullet = [self bulletInstance];
    if ([bullet.bulletType isEqual:kFireGunBullet]) {
        [self configBullet:[self bulletInstance] degreeOffset:-5];
        [self configBullet:[self bulletInstance] degreeOffset:5];
    }
    [self configBullet:bullet degreeOffset:0];
    [self fireAnimation];
}

- (void)configBullet:(ILBullet *)bullet degreeOffset:(float)offset
{
    CGPoint glPoint = [self.lineReference.parent convertToWorldSpace:self.lineReference.position];
    [bullet setBulletPosition:glPoint];
    [[self bulletParent] addChild:bullet];
    CGPoint v = [self lineReferenceVector:offset];
    [bullet setSpeedVector:v];
}

- (CGPoint)lineReferenceVector:(float)offset
{
    float degree = [self lineTotalDegree] + offset;
    float radius = -CC_DEGREES_TO_RADIANS(degree);
    if (_cannonIndicator) {
        float spped = [_cannonIndicator cannonSpeed];
        return ccpRotateByAngle(ccp(spped, 0), ccp(0, 0), radius);
    }
    return ccpRotateByAngle(ccp(5, 0), ccp(0, 0), radius);
}

- (void)fireAnimation
{
    __block CCSprite *gunFire = (CCSprite *)[CCBReader nodeGraphFromFile:@"GunFire.ccbi"];
    [self addChild:gunFire z:10];
    gunFire.position = self.lineReference.position;
    gunFire.rotation = self.lineReference.rotation;
    gunFire.anchorPoint = ccp(0, 0.5);
    CCBAnimationManager *manager = gunFire.userObject;
    [manager setCompletedAnimationCallbackBlock:^(id sender) {
        [gunFire removeFromParent];
    }];
}

- (CCNode *)bulletParent
{
    CCNode *temp = self;
    while (temp) {
        if ([temp isKindOfClass:[ILShooter class]]) {
            return temp.parent;
        }
        temp = temp.parent;
    }
    return nil;
}



- (float)lineTotalDegree
{
    return [ILTools rotationTotal:self.lineReference];
}


- (CCSprite *)findGunSprite
{
    CCArray *children = self.children;
    for (id ch in children) {
        if ([ch isKindOfClass:[CCSprite class]]) {
            return ch;
        }
    }
    return nil;
}

@end
