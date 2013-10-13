//
//  ILMenuLayer.m
//  ShootBear
//
//  Created by mac on 13-9-1.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILMenuLayer.h"
#import "ILMenuItem.h"

@implementation ILMenuLayer


- (void)setMenuGroup:(CCNode *)menuGroup
{
    menuGroup.position = _menuGroup.position;
    menuGroup.anchorPoint = _menuGroup.anchorPoint;
    [_menuGroup removeFromParent];
    _menuGroup = menuGroup;
    [self addChild:_menuGroup];
}

- (void)setGroupIndex:(int)groupIndex
{
    _groupIndex = groupIndex;
    for (id ch in self.menuGroup.children) {
        if ([ch isKindOfClass:[ILMenuItem class]]) {
            [ch setGroupIndex:groupIndex];
        }
    }
    NSString *fileName = [NSString stringWithFormat:@"group_%i.png", groupIndex];
    [self.menuTheme setGroupImage:fileName];
    NSString *stringName = [NSString stringWithFormat:@"group%i", groupIndex];
    [self.menuTheme setGroupString:NSLocalizedString(stringName, nil)];
}

- (void)setMenuTheme:(ILMenuTheme *)menuTheme
{
    menuTheme.position = _menuTheme.position;
    menuTheme.anchorPoint = _menuTheme.anchorPoint;
    [_menuTheme removeFromParent];
    _menuTheme = menuTheme;
    [self addChild:_menuTheme]; 
    
}


@end
