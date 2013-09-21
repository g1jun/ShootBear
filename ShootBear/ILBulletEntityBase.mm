//
//  ILCannonBulletEntity.m
//  ShootBear
//
//  Created by mac on 13-9-16.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBulletEntityBase.h"
#import "ILBulletBase.h"

@implementation ILBulletEntityBase

- (NSString *)collisionType
{
    return kCollisionBullet;
}

- (id)collisionCCNode
{
    CCNode *temp = self;
    do {
        if ([temp isKindOfClass:[ILBulletBase class]]) {
            return temp;
        }
    } while ((temp = temp.parent));
    return nil;
}

@end

