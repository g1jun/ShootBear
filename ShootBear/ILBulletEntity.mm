//
//  ILBulletEntity.m
//  ShootBear
//
//  Created by mac on 13-8-15.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBulletEntity.h"
#import "ILBullet.h"

@implementation ILBulletEntity

- (NSString *)collisionType
{
    return kCollisionBullet;
}

- (id)collisionCCNode
{
    CCNode *temp = self;
    do {
        if ([temp isKindOfClass:[ILBullet class]]) {
            return temp;
        }
    } while ((temp = temp.parent));
    return nil;
}



@end