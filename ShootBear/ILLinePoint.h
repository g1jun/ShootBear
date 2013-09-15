//
//  ILLinePoint.h
//  ShootBear
//
//  Created by mac on 13-8-10.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILSprite.h"
#import "CCSprite.h"

@interface ILLinePoint : ILSprite

@property (assign, nonatomic)float speed;
@property (assign, nonatomic)float acceleration;

- (id)initWithAcc:(float) acc age:(float)time;

- (void)reset;
@end
