//
//  ILBulletBase.m
//  ShootBear
//
//  Created by mac on 13-9-17.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBulletBase.h"

@implementation ILBulletBase
- (id)init
{
    self = [super init];
    if (self) {
        _isLifeEnd = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:@"pause" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continuePlay) name:@"continue" object:nil];
        _age = 0;
        
    }
    return self;
}

- (void)lifeStart
{
    [self scheduleUpdate];

}

- (void)setBulletPosition:(CGPoint)point
{
    [self.entity setPosition:point];
}

- (void)setSpeedVector:(CGPoint)speed
{
    [self.entity setSpeed:b2Vec2(speed.x, speed.y)];
}

- (float)life
{
    return 4;
}

- (void)pause
{
    [[CCDirector sharedDirector].scheduler pauseTarget:self];
}

- (void)continuePlay
{
    [self scheduleUpdate];
}

- (void)lifeEnd
{
    [[CCDirector sharedDirector].scheduler resumeTarget:self];
}

- (void)update:(ccTime)delta
{
    self.age += delta;
    if (self.age > [self life] && !_isLifeEnd) {
        [self lifeEnd];
        _isLifeEnd = YES;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.entity = nil;
    self.bulletType = nil;
    [super dealloc];
}



@end
