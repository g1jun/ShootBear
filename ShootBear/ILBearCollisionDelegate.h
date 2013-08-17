//
//  ILBearCollision.h
//  ShootBear
//
//  Created by mac on 13-8-15.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILBullet.h"
#import "cocos2d.h"
#import "ILBear.h"

static NSString* const kILBearCollisionDelegate = @"kILBearCollisionDelegate";

@protocol ILBearCollisionDelegate <NSObject>

- (void)headCollision:(ILBear *)bear bullet:(ILBullet *)bullet;

- (void)bodyCollision:(ILBear *)bear bullet:(ILBullet *)bullet;

- (void)legCollision:(ILBear *)bear bullet:(ILBullet *)bullet;


@end
