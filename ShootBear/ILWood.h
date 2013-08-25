//
//  ILWood.h
//  ShootBear
//
//  Created by mac on 13-8-24.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBox2dEntity.h"

@interface ILWood : ILBox2dEntity

@property(assign, nonatomic) BOOL isBurning;

- (void)burning;

@end
