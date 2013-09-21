//
//  ILDefendNet.h
//  ShootBear
//
//  Created by mac on 13-9-11.
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
