//
//  ILLevelControlLayer.h
//  ShootBear
//
//  Created by mac on 13-8-30.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILShrinkPanel.h"
#import "ILBulletNumberShow.h"

@interface ILLevelControlLayer : CCLayer
{
    ILShrinkPanel *_shrinkPanel;
    ILBulletNumberShow *_bulletNumberShow;
}

- (void)hide;

- (void)show;

@end
