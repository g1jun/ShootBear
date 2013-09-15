//
//  ILCollisionDelegate.h
//  ShootBear
//
//  Created by mac on 13-8-15.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILCollisionParameter.h"

static NSString* const kCollisionNothing = @"kCollisionBearNothing";
static NSString* const kCollisionBearHead = @"kCollisionBearBearHead";
static NSString* const kCollisionBearBody = @"kCollisionBearBearBody";
static NSString* const kCollisionBearLeg = @"kCollisionBearBearLeg";
static NSString* const kCollisionBullet = @"kCollisionBullet";
static NSString* const kCollisionWood = @"kCollisionWood";
static NSString* const kCollisionMetal = @"kCollisionMetal";
static NSString* const kCollisionDefendNet = @"kCollisionDefendNet";


@class ILCollisionParameter;
@class ILCollisionDelegate;
@protocol ILCollisionDelegate <NSObject>
@required

- (NSString *)collisionType;

- (id)collisionCCNode;


@optional


- (ILCollisionParameter *)collisionResponse:(id<ILCollisionDelegate>) another;

- (void)collisionDealWith:(id<ILCollisionDelegate>) another;

- (SEL)selectorWithType:(NSString *)type;

@end
