//
//  ILBulletBase.h
//  ShootBear
//
//  Created by mac on 13-9-17.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILBox2dEntity.h"

static NSString* const kHandGunBullet = @"kHandGunBullet";
static NSString* const kFireGunBullet = @"kFireGunBullet";
static NSString* const kCannonBullet = @"kCannonBullet";
static NSString* const kElectriGunBullet = @"kElectriGunBullet";

@interface ILBulletBase : CCNode
{
    BOOL _isLifeEnd;
}



@property (assign, nonatomic) ILBox2dEntity *entity;

@property (copy, nonatomic) NSString *bulletType;

@property (assign, nonatomic) float age;


- (void)setBulletPosition:(CGPoint)point;

- (float)life;

- (void)continuePlay;

- (void)pause;

- (void)setSpeedVector:(CGPoint)speed;

- (void)lifeEnd;

- (void)lifeStart;


@end
