//
//  ILPhysicsSprite.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-9.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILPhysicsSprite.h"
#import "Box2D.h"
#import "ILTools.h"

@implementation ILPhysicsSprite

- (id)init
{
    self = [super init];
    if (self) {
        [self animationMode];
    }
    return self;
}

@end
