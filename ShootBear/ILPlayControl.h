//
//  ILControl.h
//  ShootBear
//
//  Created by mac on 13-8-29.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILLevelControlLayer.h"

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

@end

@interface ILPlayControl : CCNode <CCTouchOneByOneDelegate>
{
    CCLayer *_settingLayer;
    ILLevelControlLayer *_levelControlLayer;
    NSString *_usedGunType;
    BOOL _hasRunFailedDelegate;
    float _passTime;
}

@property (assign, nonatomic) id<ILPlayControlDelegate> delegate;
@property (assign, nonatomic)BOOL forbiddenTouch;
@property (assign, nonatomic)id<ILPlayFailedDelegate> failedDelegate;

- (void)pause;

@end
