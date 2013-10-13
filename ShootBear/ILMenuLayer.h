//
//  ILMenuLayer.h
//  ShootBear
//
//  Created by mac on 13-9-1.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCLayer.h"
#import "ILMenuTheme.h"

@interface ILMenuLayer : CCLayer


@property (assign, nonatomic)ILMenuTheme *menuTheme;
@property (assign, nonatomic)CCNode *menuGroup;

@property (assign, nonatomic)int groupIndex;

@end
