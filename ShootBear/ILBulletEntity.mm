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


- (void)setB2Body:(b2Body *)b2Body
{
    [super setB2Body:b2Body];
    super.b2Body->SetGravityScale(0);
    super.b2Body->SetBullet(YES);
}



@end
