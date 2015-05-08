//
//  ILMenuTheme.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-10-12.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILMenuTheme.h"

@implementation ILMenuTheme

- (void)didLoadFromCCB
{
    _groupSprite.anchorPoint = ccp(0.5, 0.5);
}

- (void)setGroupImage:(NSString *)fileName
{
    _groupSprite.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileName];
}

- (void)setGroupString:(NSString *)string
{
    _groupLabel.string = string;
}

@end
