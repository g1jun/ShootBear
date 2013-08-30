//
//  ILControl.m
//  ShootBear
//
//  Created by mac on 13-8-29.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILPlayControl.h"
#import "CCBReader.h"
#import "ILShooter.h"
#import "CCBAnimationManager.h"

@implementation ILPlayControl

- (id)init
{
    self = [super init];
    if (self) {
        _levelControlLayer = (ILLevelControlLayer *)[CCBReader nodeGraphFromFile:@"LevelControlLayer.ccbi" owner:self];
        [self addChild:_levelControlLayer];
        _settingLayer = (CCLayer *)[CCBReader nodeGraphFromFile:@"SettingControlLayer.ccbi" owner:self];
        _settingLayer.visible = NO;
        [self addChild:_settingLayer];
        [self configSwitch];
        
    }
    return self;
}

- (void)configSwitch
{
    [_settingLayer.userObject setCompletedAnimationCallbackBlock:^(id sender) {
        if ([[sender lastCompletedSequenceName] isEqualToString:@"exit"]) {
            _settingLayer.visible = NO;
            [_levelControlLayer show];
        }
    }];
}

- (void)pressedFireButton:(id)sender
{
    [self.delegate switchGunType:kFireGun];
}

- (void)pressedBombButton:(id)sender
{
    [self.delegate switchGunType:kCannon];
}


- (void)pressedFlashButton:(id)sender
{
    [self.delegate switchGunType:kElectriGun];
}

- (void)pressedListButton:(id)sender
{
    [_levelControlLayer hide];
    [_settingLayer.userObject runAnimationsForSequenceNamed:@"enter"];
    _settingLayer.visible = YES;
}

- (void)pressedRetryButton:(id)sender
{
    
}

- (void)pressedMoreButton:(id)sender
{
    
}

- (void)pressedBackButton:(id)sender
{
    [_settingLayer.userObject runAnimationsForSequenceNamed:@"exit"];
}

- (void)pressedSoundButton:(id)sender
{
    
}

- (void)pressedShoppingButton:(id)sender
{
    
}

- (void)pressedHelpButton:(id)sender
{
    
}

@end
