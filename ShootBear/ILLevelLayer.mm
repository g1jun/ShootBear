//
//  ILLevelLayer.m
//  ShootBear
//
//  Created by mac on 13-8-27.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILLevelLayer.h"
#import "ILBox2dFactory.h"

@implementation ILLevelLayer

- (void)didLoadFromCCB
{
    [self searchSprite:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        _bears = [[NSMutableArray array] retain];
        [[ILBox2dFactory sharedFactory] setBearCollisionDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [_bears release], _bears = nil;
    [super dealloc];
}

- (void)searchSprite:(CCNode *)node
{
    CCArray *children = node.children;
    for (id child in children) {
        if ([child isKindOfClass:[ILShooter class]]) {
            _shooter = child;
        }
        if ([child isKindOfClass:[ILBear class]]) {
            [_bears addObject:child];
        }
        [self searchSprite:child];
    }
}

- (void)removeBear:(ILBear *)bear
{
    [_bears removeObject:bear];
    [bear removeFromParent];
    if (_bears.count == 0) {
        [self.delegate levelCompleted];
    }
}

- (void)headCollision:(ILBear *)bear bullet:(ILBullet *)bullet
{
    [self removeBear:bear];
}

- (void)bodyCollision:(ILBear *)bear bullet:(ILBullet *)bullet
{
    [self removeBear:bear];
}

- (void)legCollision:(ILBear *)bear bullet:(ILBullet *)bullet
{
    [self removeBear:bear];
}

- (void)switchGunType:(NSString *)gunType
{
    [_shooter replaceGunType:gunType];
}


@end
