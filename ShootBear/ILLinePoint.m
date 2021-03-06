//
//  ILLinePoint.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-10.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILLinePoint.h"

#define BEGIN_SPEED 15

@implementation ILLinePoint


- (id)initWithAcc:(float) acc age:(float)time;
{
    self = [super initWithSpriteFrameName:@"line_dot.png"];
    if (self) {
        self.speed = BEGIN_SPEED;
        self.acceleration = acc;
        self.position = ccp([self cacaluteOffset:time], 0);
        self.speed += acc * time;
        [self scheduleUpdate];
    }
    return self;
}



- (void)reset
{
    self.position = ccp(0, 0);
    self.speed = BEGIN_SPEED;
    self.scale = 1;
}

- (float)cacaluteOffset:(float)t
{
    return self.speed * t + 1.0 / 2 * self.acceleration * t * t;
}

- (void)update:(ccTime)delta
{
    float offset = [self cacaluteOffset:delta];
    self.position = ccp(self.position.x + offset, self.position.y);
    self.speed += delta * self.acceleration;
}

@end
