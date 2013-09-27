//
//  ILMenuItem.m
//  ShootBear
//
//  Created by mac on 13-9-3.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILMenuItem.h"
#import "ILDataSimpleSave.h"

@implementation ILMenuItem

- (void)didLoadFromCCB
{
    if (_hasOpen) {
        [self open];
    }
}

- (void)setGroupIndex:(int)groupIndex
{
    _groupIndex = groupIndex;
    Level level;
    level.levelNo = _levelNO;
    level.page = groupIndex;
    BOOL pass = [[ILDataSimpleSave sharedDataSave] levelState:level];
    if (pass) {
        [self open];
    }
}

- (void)open
{
    _lockSprite.visible = NO;
    _label.string = [NSString stringWithFormat:@"%i", _levelNO + 1];
    _label.visible = YES;
    _hasOpen = YES;
    _button.enabled = YES;
}

@end
