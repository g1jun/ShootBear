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
#import "ILDataSimpleSave.h"
#import "ILGunSwitchControl.h"
#import "SimpleAudioEngine.h"



@implementation ILPlayControl
- (id)init
{
    self = [super init];
    if (self) {
        [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:10 swallowsTouches:NO];
        _levelControlLayer = (ILLevelControlLayer *)[CCBReader nodeGraphFromFile:@"LevelControlLayer.ccbi" owner:self];
        _passTime = -1;
        [self addChild:_levelControlLayer];
        _settingLayer = (CCLayer *)[CCBReader nodeGraphFromFile:@"SettingControlLayer.ccbi" owner:self];
        _settingLayer.visible = NO;
        [self addChild:_settingLayer];
        [self configSwitch];
        [self scheduleUpdate];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageReceive:) name:@"coin_increase" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShopping) name:kShoppingUpdate object:nil];

        
    }
    return self;
}

- (void)updateShopping
{
    [self updateCoinLabel];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)messageReceive:(NSNotification *)notification
{
    [_levelControlLayer.coinNode.userObject runAnimationsForSequenceNamed:@"coin"];
    NSDictionary *dic = notification.userInfo;
    NSString *message = dic[@"bear"];
    if ([message isEqualToString:@"head"]) {
        [self coinIncrease:10];
    } else if ([message isEqualToString:@"body"]) {
        [self coinIncrease:1];
    } else if ([message isEqualToString:@"leg"]) {
        [self coinIncrease:5];
    }
}

- (void)coinIncrease:(float)amount
{
    float coins = [[ILDataSimpleSave sharedDataSave] floatWithKey:kCoinAmount];
    coins += amount;
    [[ILDataSimpleSave sharedDataSave] saveFloat:coins forKey:kCoinAmount];
    [self updateCoinLabel];
}


- (void)onExit
{
    [super onExit];
    [_settingLayer.userObject setCompletedAnimationCallbackBlock:nil];
    [self unscheduleUpdate];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
}

- (void)updateCoinLabel
{
    int coins = [[ILDataSimpleSave sharedDataSave] intWithKey:kCoinAmount];
    _coinLabel.string = [NSString stringWithFormat:@"%i", coins];
}

- (void)onEnter
{
    [super onEnter];
    _levelNO.string = [NSString stringWithFormat:@"%i-%i", _level.page + 1, _level.levelNo + 1];
    [self updateCoinLabel];
    [self hideSomeNode];
    [self tryModeCheck];
}

- (void)tryModeCheck
{
    if (_level.page == 0 && _level.levelNo == 5) {
        [_levelControlLayer.shrinkPanel tryFireGun];
    }
    if (_level.page == 0 && _level.levelNo == 7) {
        [_levelControlLayer.shrinkPanel tryElectricGun];
    }
    if (_level.page == 0 && _level.levelNo == 8) {
        [_levelControlLayer.shrinkPanel tryCannon];
    }
}

- (void)hideSomeNode
{
    if ([self isHideShrinkPanel]){
        _levelControlLayer.shrinkPanel.visible = NO;
    }
    if ([self isHideCoinLabel]) {
        _coinLabel.visible = NO;
        _levelControlLayer.coinNode.visible = NO;
    }
}


- (BOOL)isHideShrinkPanel
{
    if (_level.page == 0) {
        return _level.levelNo < 9 && _level.levelNo != 5
        && _level.levelNo != 7 && _level.levelNo != 8;
    }
    return NO;
}

- (BOOL)isHideCoinLabel
{
    BOOL hasShowCoinTeach = [[ILDataSimpleSave sharedDataSave] boolWithKey:@"show_coin_teach"];
    return _level.page == 0 && _level.levelNo < 3 && !hasShowCoinTeach;
}

- (void)configSwitch
{
    [_settingLayer.userObject setCompletedAnimationCallbackBlock:^(id sender) {
        if ([[sender lastCompletedSequenceName] isEqualToString:@"exit"]) {
            _settingLayer.visible = NO;
            [_levelControlLayer show];
            [self hideSomeNode];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"continue" object:nil];
            [self scheduleUpdate];
            [self.failedDelegate resume];

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

- (BOOL)isOthersGunUsedUp:(id)sender
{
    ILGunSwitchControl *switchControl = (ILGunSwitchControl *)[sender parent];
    if(switchControl.quantityBullet <= 0 && !switchControl.tryMode) {
        [self.failedDelegate pressedShoppingButton:sender];
        return YES;
    }
    return NO;
}

- (void)pressedFireButton:(id)sender
{
    if ([self isOthersGunUsedUp:sender]) {
        return;
    }
    _usedGunType = kFireGun;
    [self.delegate switchGunType:kFireGun];
}

- (void)pressedBombButton:(id)sender
{
    if ([self isOthersGunUsedUp:sender]) {
        return;
    }
    _usedGunType = kCannon;
    [self.delegate switchGunType:kCannon];
}


- (void)pressedFlashButton:(id)sender
{
    if ([self isOthersGunUsedUp:sender]) {
        return;
    }
    _usedGunType = kElectriGun;
    [self.delegate switchGunType:kElectriGun];
}

- (void)pressedListButton:(id)sender
{
    if (self.forbiddenTouch) {
        return;
    }
    [self pause];
    [self.failedDelegate pause];
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
    [_settingLayer.userObject runAnimationsForSequenceNamed:@"exit"];
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

- (CGPoint)moneyPosition
{
    return [_levelControlLayer.coinNode.parent convertToWorldSpace:_levelControlLayer.coinNode.position];
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
    if (_levelControlLayer.bulletNumberShow.bulletNumber < 0) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"bullet_use_up.mp3"];
        if (!_isShowBulletUseUpHint) {
            _isShowBulletUseUpHint = YES;
            CCNode *hint = [CCBReader nodeGraphFromFile:@"BulletUseUpHint.ccbi"];
            [self addChild:hint];
        }
    }
    if (_levelControlLayer.bulletNumberShow.bulletNumber == 0 && !_hasRunFailedDelegate) {
        [_levelControlLayer.shrinkPanel hideMyself];
        _passTime = 6.5;
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
	int32 velocityIterations = 10;
	int32 positionIterations = 10;
	[ILBox2dFactory sharedFactory].world->Step(dt, velocityIterations, positionIterations);
}

@end
