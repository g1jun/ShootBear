//
//  ILMenuTheme.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-10-12.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"

@interface ILMenuTheme : CCNode
{
    CCSprite *_groupSprite;
    CCLabelTTF *_groupLabel;
}

- (void)setGroupImage:(NSString *)fileName;
- (void)setGroupString:(NSString *)string;

@end
