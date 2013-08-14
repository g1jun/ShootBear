//
//  ILBullet.m
//  ShootBear
//
//  Created by mac on 13-8-14.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBullet.h"
#import "Box2D.h"

@implementation ILBullet

- (void)setB2Body:(b2Body *)b2Body
{
    [super setB2Body:b2Body];
    b2Body->SetGravityScale(0);
}

@end
