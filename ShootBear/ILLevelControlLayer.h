//
//  ILLevelControlLayer.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-30.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILShrinkPanel.h"
#import "ILBulletNumberShow.h"


@interface ILLevelControlLayer : CCLayer
{
}

@property (assign, nonatomic) ILBulletNumberShow *bulletNumberShow;
@property (assign, nonatomic) ILShrinkPanel *shrinkPanel;
@property (assign, nonatomic)CCNode *coinNode;

- (void)hide;

- (void)show;

@end
