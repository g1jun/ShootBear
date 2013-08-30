//
//  ILLevelControlLayer.m
//  ShootBear
//
//  Created by mac on 13-8-30.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILLevelControlLayer.h"

@implementation ILLevelControlLayer


- (void)didLoadFromCCB
{
    
}

- (void)hide
{
    [_shrinkPanel pushState];
    [self performSelector:@selector(hideSubViews) withObject:nil afterDelay:0.5];
}

- (void)hideSubViews
{
    for (id ch in self.children) {
        [ch setVisible:NO];
    }
}

- (void)showSubViews
{
    for (id ch in self.children) {
        [ch setVisible:YES];
    }
}

- (void)show
{
    [self showSubViews];
    [_shrinkPanel popState];
}



@end
