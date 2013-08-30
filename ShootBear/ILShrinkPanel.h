//
//  ILShrinkPanel.h
//  ShootBear
//
//  Created by mac on 13-8-29.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILShrinkButton.h"
#import "ILUsedOnceButton.h"

@interface ILShrinkPanel : CCNode <ILShrinkButtonDelegate>
{
    ILShrinkButton *_firstButton;
    ILUsedOnceButton *_secondButton;
    ILUsedOnceButton *_thirdButton;
    ILUsedOnceButton *_forthButton;
    NSMutableArray *_buttonArray;
    ILUsedOnceButton *_currentSelectedButton;
    BOOL _foldState;
    BOOL _hasHide;
}

- (void)pushState;

- (void)popState;

- (void)hasUsed;

- (void)forbiddenAllButtons;

@end
