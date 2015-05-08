//
//  ILMenuScene.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-1.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCScene.h"
#import "CCScrollLayer.h"

@interface ILMenuScene : CCScene <CCScrollLayerDelegate>
{
    CCScrollLayer *_scrollLayer;
}

@property (assign, nonatomic) int currentPage;

@end
