//
//  ILControl.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-29.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILLevelControlLayer.h"
#import "ILStruct.h"

@protocol ILPlayControlDelegate <NSObject>

- (void)switchGunType:(NSString *)gunType;
- (void)notificationShooterFire;

@end

@protocol ILPlayFailedDelegate <NSObject>

- (void)levelFailed;

@optional

- (void)pressedRetryButton:(id)sender;

- (void)pressedMoreButton:(id)sender;

- (void)pressedShoppingButton:(id)sender;

- (void)pressedHelpButton:(id)sender;

- (void)pause;

- (void)resume;

@end

@interface ILPlayControl : CCNode <CCTouchOneByOneDelegate>
{
    CCLayer *_settingLayer;
    ILLevelControlLayer *_levelControlLayer;
    NSString *_usedGunType;
    BOOL _hasRunFailedDelegate;
    float _passTime;
    CCLabelTTF *_levelNO;
    CCLabelTTF *_coinLabel;
    BOOL _isShowBulletUseUpHint;
}

@property (assign, nonatomic) id<ILPlayControlDelegate> delegate;
@property (assign, nonatomic)BOOL forbiddenTouch;
@property (assign, nonatomic)id<ILPlayFailedDelegate> failedDelegate;

@property (assign, nonatomic)Level level;

- (void)pause;

- (void)coinIncrease:(float)amount;

- (CGPoint)moneyPosition;


@end
