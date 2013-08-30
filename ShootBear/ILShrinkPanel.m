//
//  ILShrinkPanel.m
//  ShootBear
//
//  Created by mac on 13-8-29.
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

- (void)switchButton:(ILUsedOnceButton *)button
{
    _currentSelectedButton = button;
    for (id item in _buttonArray) {
        if (item != button ) {
            [item recover];
        }
    }
}
- (void)hasUsed
{
    [_buttonArray removeObject:_currentSelectedButton];
    _currentSelectedButton = nil;
    if (_buttonArray.count <= 1) {
        [self hideMyself];
    }
}

- (void)hideMyself
{
    _hasHide = YES;
    [self.userObject runAnimationsForSequenceNamed:@"hide"];
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
    if (!_foldState && !_hasHide) {
        [self foldPanel];
    }
}

- (void)popState
{
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



@end
