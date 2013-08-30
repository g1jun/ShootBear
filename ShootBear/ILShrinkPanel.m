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
    _foldState = NO;
}

- (void)fold
{
    _foldState = YES;
    [self foldPanel];
}

- (void)foldPanel
{
    [self.userObject runAnimationsForSequenceNamed:@"fold"];
    [self.userObject setCompletedAnimationCallbackBlock:^(id sender) {
        if ([[sender lastCompletedSequenceName] isEqualToString:@"fold"]) {
            [self foldCompleted];
        }
    }];
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
    if (!_foldState) {
        [self foldPanel];
    }
}

- (void)popState
{
    if (!_foldState) {
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



@end
