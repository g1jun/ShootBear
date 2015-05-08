//
//  ILBulletShowUnit.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-30.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBulletShowUnit.h"

@implementation ILBulletShowUnit

- (void)used
{
    _unused.visible = NO;
    _used.visible = YES;
}

- (void)recovery
{
    _unused.visible = YES;
    _used.visible = NO;
    
}

@end
