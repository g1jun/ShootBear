//
//  ILUsedOnceButton.m
//  ShootBear
//
//  Created by mac on 13-8-29.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILUsedOnceButton.h"

@implementation ILUsedOnceButton

- (void)didLoadFromCCB
{
    [_button addTarget:self action:@selector(hasUsed:) forControlEvents:CCControlEventTouchUpInside];
}

- (void)hasUsed:(id)sender
{
    _button.touchEnabled = NO;
    for (id node in self.children) {
        if ([node isKindOfClass:[CCSprite class]]) {
            CCSprite *sprite = (CCSprite *)node;
            [sprite setColor:ccc3(0, 0, 0)];
            [sprite setOpacity:100];
        }
    }
}

@end
