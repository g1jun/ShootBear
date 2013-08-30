//
//  ILBullet.m
//  ShootBear
//
//  Created by mac on 13-8-14.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBullet.h"
@implementation ILBullet

- (void)didLoadFromCCB
{
}

- (id)init
{
    self = [super init];
    if (self) {
        [self scheduleOnce:@selector(destroyMe) delay:[self life]];
    }
    return self;
}

- (void)destroyMe
{
    [self removeFromParent];
}

- (void)dealloc
{
    self.entity = nil;
    self.bulletType = nil;
    [super dealloc];
}

- (float)life
{
    return 4;
}

@end
