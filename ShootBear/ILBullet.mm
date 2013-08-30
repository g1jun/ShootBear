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
        [self scheduleUpdate];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:@"pause" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continuePlay) name:@"continue" object:nil];
        _age = 0;
        
    }
    return self;
}

- (void)update:(ccTime)delta
{
    _age += delta;
    if (_age > [self life]) {
        [self destroyMe];
    }
}

- (void)pause
{
    [self unscheduleUpdate];
}

- (void)continuePlay
{
    [self scheduleUpdate];
}

- (void)destroyMe
{
    [self unscheduleUpdate];
    [self removeFromParent];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.entity = nil;
    self.bulletType = nil;
    [super dealloc];
}

- (float)life
{
    return 4;
}

@end
