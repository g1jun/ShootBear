//
//  ILSpriteBase.m
//  ShootBear
//
//  Created by mac on 13-8-17.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILSpriteBase.h"
#import "CCSpriteFrameCache+ILSpriteNameSearch.h"

@implementation ILSpriteBase

- (void)dealloc
{
    self.imageName = nil;
    [super dealloc];
}

- (NSString *)collisionType
{
    return kCollisionNothing;
}

- (id)collisionCCNode
{
    return self;
}

- (void)setDisplayFrame:(CCSpriteFrame *)newFrame
{
    [super setDisplayFrame:newFrame];
    NSString *name = [[CCSpriteFrameCache sharedSpriteFrameCache] nameBySpriteFrame:newFrame];
    self.imageName = [name stringByDeletingPathExtension];
}

@end
