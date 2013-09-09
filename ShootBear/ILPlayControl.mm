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
#import "ILBox2dFactory.h"

@implementation ILPlayControl
- (id)init
{
    self = [super init];
    if (self) {
        [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:10 swallowsTouches:NO];
        _levelControlLayer = (ILLevelControlLayer *)[CCBReader nodeGraphFromFile:@"LevelControlLayer.ccbi" owner:self];
        _levelControlLayer.bulletNumberShow.bulletNumber = 5;
        _passTime = -1;
        [self addChild:_levelControlLayer];
        _settingLayer = (CCLayer *)[CCBReader nodeGraphFromFile:@"SettingControlLayer.ccbi" owner:self];
        _settingLayer.visible = NO;
        [self addChild:_settingLayer];
        [self configSwitch];
        [self scheduleUpdate];

        
    }
    return self;
}


- (void)onExit
{
    [super onExit];
    [_settingLayer.userObject setCompletedAnimationCallbackBlock:nil];
    [self unscheduleUpdate];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
}


- (void)configSwitch
{
    [_settingLayer.userObject setCompletedAnimationCallbackBlock:^(id sender) {
        if ([[sender lastCompletedSequenceName] isEqualToString:@"exit"]) {
            _settingLayer.visible = NO;
            [_levelControlLayer show];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"continue" object:nil];
            [self scheduleUpdate];
        }
    }];
}

- (void)setForbiddenTouch:(BOOL)forbiddenTouch
{
    _forbiddenTouch = forbiddenTouch;
    if (_forbiddenTouch) {
        [_levelControlLayer.shrinkPanel forbiddenAllButtons];
    }
}

- (void)pressedFireButton:(id)sender
{
    _usedGunType = kFireGun;
    [self.delegate switchGunType:kFireGun];
}

- (void)pressedBombButton:(id)sender
{
    _usedGunType = kCannon;
    [self.delegate switchGunType:kCannon];
}


- (void)pressedFlashButton:(id)sender
{
    _usedGunType = kElectriGun;
    [self.delegate switchGunType:kElectriGun];
}

- (void)pressedListButton:(id)sender
{
    if (self.forbiddenTouch) {
        return;
    }
    [self unscheduleUpdate];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pause" object:nil];
    [_levelControlLayer hide];
    [_settingLayer.userObject runAnimationsForSequenceNamed:@"enter"];
    _settingLayer.visible = YES;
}

- (void)pressedRetryButton:(id)sender
{
    [self.failedDelegate pressedRetryButton:sender];
}

- (void)pressedMoreButton:(id)sender
{
    [self.failedDelegate pressedMoreButton:sender];
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
    [self.failedDelegate pressedShoppingButton:sender];
}

- (void)pressedHelpButton:(id)sender
{
    [self.failedDelegate pressedHelpButton:sender];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)failed
{
    [self.failedDelegate levelFailed];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_usedGunType) {
        [_levelControlLayer.shrinkPanel hasUsed];
        [self.delegate notificationShooterFire];
        [self.delegate switchGunType:kHandGun];
    }
    if (!_usedGunType && _levelControlLayer.bulletNumberShow.bulletNumber > 0) {
        [self.delegate notificationShooterFire];
        [_levelControlLayer.bulletNumberShow reduceBullet];
    }
    if (_levelControlLayer.bulletNumberShow.bulletNumber == 0 && !_hasRunFailedDelegate) {
        [_levelControlLayer.shrinkPanel hideMyself];
        _passTime = 4;
        [_levelControlLayer.bulletNumberShow reduceBullet];

    }
    _usedGunType = nil;

}

- (void)pause
{
    [self unscheduleUpdate];
}


-(void) update: (ccTime) dt
{
    if (_passTime > 0) {
        _passTime -= dt;
        if (_passTime < 0.0001 && !_hasRunFailedDelegate) {
            [self failed];
            _hasRunFailedDelegate = YES;
        }
        
    }
	int32 velocityIterations = 1;
	int32 positionIterations = 10;
	[ILBox2dFactory sharedFactory].world->Step(dt, velocityIterations, positionIterations);
}

@end
