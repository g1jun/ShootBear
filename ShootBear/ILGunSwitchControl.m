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

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabel) name:kShoppingUpdate object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)didLoadFromCCB
{
    [_button addTarget:self action:@selector(used:) forControlEvents:CCControlEventTouchUpInside];
    _isSelected = NO;
    [self updateLabel];
}

- (void)updateLabel
{
    _label.string = [NSString stringWithFormat:@"%i", [self quantityBullet]];

}

- (int)quantityBullet
{
    int ret = [[ILDataSimpleSave sharedDataSave] intWithKey:_gunType];
    _label.visible = !ret <= 0;
    return ret;
}

- (void)bulletHasUsed
{
    int temp = [[ILDataSimpleSave sharedDataSave] intWithKey:_gunType];
    if (temp > 0) {
        temp--;
    }
    [[ILDataSimpleSave sharedDataSave] saveInt:temp forKey:_gunType];
    [self updateLabel];
    
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
