//
//  ILMenuLayer.m
//  ShootBear
//
//  Created by mac on 13-9-1.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILMenuLayer.h"

@implementation ILMenuLayer


- (void)setMenuGroup:(CCNode *)menuGroup
{
    menuGroup.position = _menuGroup.position;
    menuGroup.anchorPoint = _menuGroup.anchorPoint;
    [_menuGroup removeFromParent];
    _menuGroup = menuGroup;
    [self addChild:_menuGroup];
}

- (void)setMenuTheme:(CCNode *)menuTheme
{
    menuTheme.position = _menuTheme.position;
    menuTheme.anchorPoint = _menuTheme.anchorPoint;
    [_menuTheme removeFromParent];
    _menuTheme = menuTheme;
    [self addChild:_menuTheme]; 
    
}


@end
