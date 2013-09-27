//
//  ILUsedOnceButton.m
//  ShootBear
//
//  Created by mac on 13-8-29.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILGunSwitchControl.h"
#import "ILDataSimpleSave.h"

@implementation ILGunSwitchControl

- (void)didLoadFromCCB
{
    [_button addTarget:self action:@selector(used:) forControlEvents:CCControlEventTouchUpInside];
    _isSelected = NO;
    if ([self quantityBullet] == 0) {
        _label.visible = NO;
    }
}

- (int)quantityBullet
{
    return [[ILDataSimpleSave sharedDataSave] intWithKey:_gunType];
}

- (void)addTarget:(id)target action:(SEL)action
{
    [_button addTarget:target action:action forControlEvents:CCControlEventTouchUpInside];
}

- (void)used:(id)sender
{
    if ([self quantityBullet] == 0) {
        return;
    }
    _isSelected = YES;
    _button.enabled = NO;
    for (id node in self.children) {
        if ([node isKindOfClass:[CCSprite class]]) {
            CCSprite *sprite = (CCSprite *)node;
            [sprite setColor:ccc3(0, 0, 0)];
            [sprite setOpacity:50];
        }
    }
}

- (void)recover
{
    _isSelected = NO;
    _button.enabled = YES;
    for (id node in self.children) {
        if ([node isKindOfClass:[CCSprite class]]) {
            CCSprite *sprite = (CCSprite *)node;
            [sprite setColor:ccc3(255, 255, 255)];
            [sprite setOpacity:255];
        }
    }
    
}

@end
