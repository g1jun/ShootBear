//
//  ILShooter.h
//  ShootBear
//
//  Created by mac on 13-8-8.
//  Copyright 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ILShooterHalf.h"


static NSString* const kHandGun = @"Gun0";
static NSString* const kFireGun = @"Gun2";
static NSString* const kElectriGun = @"Gun1";
static NSString* const kCannon = @"ShooterCannon";

@interface ILShooter : CCNode {
    
    ILShooterHalf *_leftShooter;
    ILShooterHalf *_rightShooter;
    
}

- (void)replaceGunType:(NSString * )type;

- (void)fire;

@end
