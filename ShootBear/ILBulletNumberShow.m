//
//  ILBulletNumberShow.m
//  ShootBear
//
//  Created by mac on 13-8-30.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBulletNumberShow.h"
#import "ILDataSimpleSave.h"
#import "CCBReader.h"

#define BULLET_MIN_QUANTITY 4

@implementation ILBulletNumberShow
@synthesize bulletNumber = _bulletNumber;

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBulletQuanity) name:kShoppingUpdate object:nil];
    }
    return self;
}

- (void)updateBulletQuanity
{
    int bulletQuantity = [[ILDataSimpleSave sharedDataSave] intWithKey:kBulletQuantity];
    if (bulletQuantity == _bulletArray.count + 1) {
        int temp = _bulletArray.count - _bulletNumber;
        [self setBulletNumber:bulletQuantity];
        [self setHasUsedBullet:temp];
    }
}

- (void)setHasUsedBullet:(int)used
{
    for (id item in _bulletArray) {
        [item recovery];
    }
    for (int i = 0; i < used; i++) {
        [self reduceBullet];
    }
}

- (void)didLoadFromCCB
{
    _bulletArray = [[NSMutableArray array] retain];
    [_bulletArray addObject:_first];
    [_bulletArray addObject:_second];
    _bulletNumber = 2;
    int number = [self bulletTotal];
    [self setBulletNumber:number];
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
    NSAssert(bulletNumber >= _bulletArray.count, @"bulletNumber must be > ?");
    _bulletNumber = bulletNumber;
    if (bulletNumber > _bulletArray.count) {
        for (int i = _bulletArray.count; i < bulletNumber; i++) {
            ILBulletShowUnit *newUnit = (ILBulletShowUnit *)[CCBReader nodeGraphFromFile:@"BulletShowUnit.ccbi"];
            newUnit.position = ccp(_first.position.x + (_second.position.x - _first.position.x) * i,
                                   _first.position.y);
            [self addChild:newUnit];
            [_bulletArray addObject:newUnit];
        }
    }
}

- (void)dealloc
{
    [_bulletArray release], _bulletArray = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (int)bulletTotal
{
    int bulletQuantity = [[ILDataSimpleSave sharedDataSave] intWithKey:kBulletQuantity];
    if (bulletQuantity <= BULLET_MIN_QUANTITY) {
        bulletQuantity = BULLET_MIN_QUANTITY;
        [[ILDataSimpleSave sharedDataSave] saveInt:bulletQuantity forKey:kBulletQuantity];
    }
    return bulletQuantity;
    
}

@end
