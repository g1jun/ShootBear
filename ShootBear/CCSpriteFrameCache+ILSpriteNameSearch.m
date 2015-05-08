//
//  CCSpriteFrameCache+ILSpriteNameSearch.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-17.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCSpriteFrameCache+ILSpriteNameSearch.h"

@implementation CCSpriteFrameCache (ILSpriteNameSearch)

- (NSString *)nameBySpriteFrame:(CCSpriteFrame *)spriteFrame
{
    for (NSString *name in _spriteFrames) {
        if (spriteFrame == _spriteFrames[name]) {
            return name;
        }
    }
    return nil;
}

@end
