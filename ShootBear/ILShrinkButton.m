//
//  ILShrinkButton.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-29.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILShrinkButton.h"
#import "CCBAnimationManager.h"

@implementation ILShrinkButton

- (id)init
{
    self = [super init];
    if (self) {
        _isFold = NO;
    }
    return self;
}

- (void)didLoadFromCCB
{
    [self.userObject runAnimationsForSequenceNamed:@"init"];
}

- (void)pressedShrink:(id)sender
{
    CCBAnimationManager *manager = self.userObject;
    if (_isFold) {
        [self.delegate unfold];
        [manager runAnimationsForSequenceNamed:@"turnLeft"];
    } else {
        [self.delegate fold];
        [manager runAnimationsForSequenceNamed:@"turnRight"];
    }
    _isFold = !_isFold;
}

@end
