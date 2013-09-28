//
//  ILStruct.h
//  ShootBear
//
//  Created by mac on 13-9-6.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    int page;
    int levelNo;
} Level;


static NSString* const kCoinAmount = @"coin_amount";
static NSString* const kBulletQuantity = @"bullet_quantity";
static NSString* const kBulletTime = @"bullet_time";

static NSString* const kHandGun = @"Gun0";
static NSString* const kFireGun = @"Gun2";
static NSString* const kElectriGun = @"Gun1";
static NSString* const kCannon = @"ShooterCannon";
