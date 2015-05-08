//
//  ILShrinkPanel.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-29.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILShrinkPanel.h"
#import "CCBAnimationManager.h"

@implementation ILShrinkPanel


- (void)didLoadFromCCB
{
    _firstButton.delegate = self;
    _buttonArray = [[NSMutableArray array] retain];
    _foldState = NO;
    [_secondButton addTarget:self action:@selector(pressedSecondButton:)];
    [_thirdButton addTarget:self action:@selector(pressedThirdButton:)];
    [_forthButton addTarget:self action:@selector(pressedForthButton:)];
    [_buttonArray addObject:_secondButton];
    [_buttonArray addObject:_thirdButton];
    [_buttonArray addObject:_forthButton];
    __block id bself = self;
    [self.userObject setCompletedAnimationCallbackBlock:^(id sender) {
        if ([[sender lastCompletedSequenceName] isEqualToString:@"fold"]) {
            [bself foldCompleted];
        }
    }];
}

- (void)pressedSecondButton:(id)sender
{
    [self switchButton:_secondButton];
}

- (void)pressedThirdButton:(id)sender
{
    [self switchButton:_thirdButton];
}

- (void)pressedForthButton:(id)sender
{
    [self switchButton:_forthButton];
}

- (void)fold
{
    _foldState = YES;
    [self foldPanel];
}

- (void)switchButton:(ILGunSwitchControl *)button
{
    if (button.quantityBullet <= 0) {
        return;
    }
    _currentSelectedButton = button;
    for (id item in _buttonArray) {
        if (item != button ) {
            [item recover];
        }
    }
}

- (void)recoverAll
{
    for (id item in _buttonArray) {
        [item recover];
    }
}

- (void)hasUsed
{
    [self recoverAll];
    if (_tryMode) {
        return;
    }
    [_currentSelectedButton bulletHasUsed];
    _usedTimes ++;
    if (_usedTimes > 1) {
        [self hideMyself];
    }
}

- (void)hideMyself
{
    if (_hasHide || _tryMode) {
        return;
    }
    if (_foldState) {
        [self foldCompleted];
        [self.userObject runAnimationsForSequenceNamed:@"hideScaleOnly"];

    } else {
        [self.userObject runAnimationsForSequenceNamed:@"hide"];
    }
    _hasHide = YES;

}

- (void)foldPanel
{
    [self.userObject runAnimationsForSequenceNamed:@"fold"];
    
}

- (void)unfoldPanel
{
    [self unfoldPrevious];
    [self.userObject runAnimationsForSequenceNamed:@"unfold"];
}

- (void)foldCompleted
{
    for (CCNode *ch in self.children) {
        ch.visible = NO;
    }
    _firstButton.visible = YES;
}


- (void)pushState
{
    if (_tryMode) {
        return;
    }
    if (!_foldState && !_hasHide) {
        [self foldPanel];
    }
}

- (void)popState
{
    if (_tryMode) {
        return;
    }
    if (!_foldState && !_hasHide) {
        [self unfoldPanel];
    }
}

- (void)unfold
{
    _foldState = NO;
    [self unfoldPanel];
}

- (void)unfoldPrevious
{
    for (CCNode *ch in self.children) {
        ch.visible = YES;
    }
}

- (void)forbiddenAllButtons
{
    _secondButton.button.enabled = NO;
    _thirdButton.button.enabled = NO;
    _forthButton.button.enabled = NO;
}

- (void)dealloc
{
    [_buttonArray release], _buttonArray = nil;
    [super dealloc];
}

- (void)tryFireGun
{
    [self hideAll];
    [self configTryMode:_secondButton];
}

- (void)configTryMode:(ILGunSwitchControl *)button
{
    button.visible = YES;
    button.position = CGPointZero;
    [button switchTryMode];
}

- (void)tryElectricGun
{
    [self hideAll];
    [self configTryMode:_thirdButton];
}

- (void)tryCannon
{
    [self hideAll];
    [self configTryMode:_forthButton];
}

- (void)hideAll
{
    _tryMode = YES;
    for (id node in self.children) {
        [node setVisible:NO];
    }
}



@end
