//
//  ILShrinkButton.m
//  ShootBear
//
//  Created by mac on 13-8-29.
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

- (void)pressedShrink:(id)sender
{
    CCBAnimationManager *manager = self.userObject;
    if (_isFold) {
        [self.delegate unfold];
        [manager runAnimationsForSequenceNamed:@"turnRight"];
    } else {
        [self.delegate fold];
        [manager runAnimationsForSequenceNamed:@"turnLeft"];
    }
    _isFold = !_isFold;
}

@end
