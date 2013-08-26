//
//  ILBullet.h
//  ShootBear
//
//  Created by mac on 13-8-14.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILBox2dEntity.h"

static NSString* const kHandGunBullet = @"kHandGunBullet";
static NSString* const kFireGunBullet = @"kFireGunBullet";
static NSString* const kCannonBullet = @"kCannonBullet";
static NSString* const kElectriGunBullet = @"kElectriGunBullet";

@interface ILBullet : CCNode

@property (retain, nonatomic) ILBox2dEntity *entity;

@property (copy, nonatomic) NSString *bulletType;

@end
