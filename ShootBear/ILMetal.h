//
//  ILMetal.h
//  ShootBear
//
//  Created by mac on 13-8-25.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBox2dEntity.h"
@class ILLevelLayer;
@interface ILMetal : ILBox2dEntity


@property (assign,nonatomic) BOOL hasElctric;

- (void)conductElectricity;

- (void)elctricEffect;

- (ILLevelLayer *)layer;

@end
