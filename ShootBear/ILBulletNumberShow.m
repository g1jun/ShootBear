//
//  ILBulletNumberShow.m
//  ShootBear
//
//  Created by mac on 13-8-30.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBulletNumberShow.h"
#import "CCBReader.h"

@implementation ILBulletNumberShow

- (void)didLoadFromCCB
{
    _bulletArray = [[NSMutableArray array] retain];
    [_bulletArray addObject:_first];
    [_bulletArray addObject:_second];
    _bulletNumber = 2;
}

- (void)reduceBullet
{
    _bulletNumber--;
    if (_bulletNumber >= 0) {
        [_bulletArray[_bulletNumber] used];
    }
}

- (void)setBulletNumber:(int)bulletNumber
{
    NSAssert(bulletNumber >= 2, @"bulletNumber must be > 2");
    _bulletNumber = bulletNumber;
    if (bulletNumber > 2) {
        for (int i = 0; i < bulletNumber - 2 ; i++) {
            ILBulletShowUnit *newUnit = (ILBulletShowUnit *)[CCBReader nodeGraphFromFile:@"BulletShowUnit.ccbi"];
            newUnit.position = ccp(_first.position.x + (_second.position.x - _first.position.x) * (i + 2),
                                   _first.position.y);
            [self addChild:newUnit];
            [_bulletArray addObject:newUnit];
        }
    }
}

- (void)dealloc
{
    [_bulletArray release], _bulletArray = nil;
    [super dealloc];
}

@end
