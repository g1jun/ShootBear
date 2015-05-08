//
//  ILDefendNet.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILSpriteBase.h"
#import "ILMetal.h"
#import "CCClippingNode.h"

@interface ILDefendNet : ILMetal


- (void)leftAnchor;
- (void)rightAnchor;

@property (assign, nonatomic) BOOL isLeft;

@end
