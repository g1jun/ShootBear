//
//  ILMenuTheme.h
//  ShootBear
//
//  Created by mac on 13-10-12.
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
