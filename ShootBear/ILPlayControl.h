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

@end

@interface ILPlayControl : CCNode
{
    CCLayer *_settingLayer;
    ILLevelControlLayer *_levelControlLayer;
}


@property (assign, nonatomic) id<ILPlayControlDelegate> delegate;

@end
