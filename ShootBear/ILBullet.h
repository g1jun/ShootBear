//
//  ILBullet.h
//  ShootBear
//
//  Created by mac on 13-8-14.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILBox2dEntity.h"

@interface ILBullet : CCNode

@property (retain, nonatomic) ILBox2dEntity *entity;

@end
