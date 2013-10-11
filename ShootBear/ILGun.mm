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
#import "SimpleAudioEngine.h"
#import "ILBulletCanon.h"

#define BULLET 30

#define BULLET_SPPED 5

@implementation ILGun

- (void)dealloc
{
    _lineReference = nil;
    [super dealloc];
}
- (void)didLoadFromCCB
{
}

- (ILBullet *)bulletInstance
{
    NSString *bulletFileName = [_bulletCCBName stringByAppendingString:@".ccbi"];
    ILBullet *bullet = (ILBullet *)[CCBReader nodeGraphFromFile:bulletFileName];
    return bullet;
}


- (NSDictionary *)musicEffect
{
    return @{kHandGunBullet:@"hand_gun_fire.mp3",
      kFireGunBullet:@"fire_gun_fire.mp3",
      kElectriGunBullet:@"elctric_gun.mp3",
      kCannonBullet: @"cannon_fire.mp3"};
}

- (void)playMusicEffect:(NSString *)bulletType
{
    NSString *fileName = [self musicEffect][bulletType];
    [[SimpleAudioEngine sharedEngine] playEffect:fileName];
}

- (void)fire
{
    ILBullet *bullet = [self bulletInstance];
    if ([bullet.bulletType isEqualToString:kFireGunBullet]) {
        [self configBullet:[self bulletInstance] degreeOffset:-5];
        [self configBullet:[self bulletInstance] degreeOffset:5];
    }
    if ([bullet.bulletType isEqualToString:kCannonBullet]) {
        [(ILBulletCanon*)bullet lifeStart];
    }
    [self configBullet:bullet degreeOffset:0];
    [self fireAnimation];
    [self playMusicEffect:bullet.bulletType];
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
            return temp.parent.parent;
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
