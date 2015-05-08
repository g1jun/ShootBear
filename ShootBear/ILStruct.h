//
//  ILStruct.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-6.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    int page;
    int levelNo;
} Level;

enum LevelGrade {
    kPass = 1,
    kGeneral = 2,
    kGood = 3,
};

typedef enum LevelGrade LevelGrade;


static NSString* const kCoinAmount = @"coin_amount";
static NSString* const kBulletQuantity = @"bullet_quantity";
static NSString* const kBulletTime = @"bullet_time";

static NSString* const kHandGun = @"Gun0";
static NSString* const kFireGun = @"Gun2";
static NSString* const kElectriGun = @"Gun1";
static NSString* const kCannon = @"ShooterCannon";
static NSString* const kShoppingUpdate = @"kShoppingUpdate";
