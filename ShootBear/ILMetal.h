//
//  ILMetal.h
//  ShootBear
//
//  Created by mac on 13-8-25.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBox2dEntity.h"

@interface ILMetal : ILBox2dEntity
{
    ILSprite *_animationSprite;
}

@property (assign,nonatomic) BOOL hasElctric;

- (void)conductElectricity;
@end
