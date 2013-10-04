//
//  ILShrinkPanel.h
//  ShootBear
//
//  Created by mac on 13-8-29.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILShrinkButton.h"
#import "ILGunSwitchControl.h"

@interface ILShrinkPanel : CCNode <ILShrinkButtonDelegate>
{
    ILShrinkButton *_firstButton;
    ILGunSwitchControl *_secondButton;
    ILGunSwitchControl *_thirdButton;
    ILGunSwitchControl *_forthButton;
    NSMutableArray *_buttonArray;
    ILGunSwitchControl *_currentSelectedButton;
    BOOL _foldState;
    BOOL _hasHide;
    int _usedTimes;
}

@property (assign, nonatomic)BOOL tryMode;

- (void)pushState;

- (void)popState;

- (void)hasUsed;

- (void)forbiddenAllButtons;

- (void)hideMyself;

- (void)tryFireGun;

- (void)tryElectricGun;

- (void)tryCannon;

@end
