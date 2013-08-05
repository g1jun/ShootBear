//
//  ILBox2dFactory.h
//  ShootBear
//
//  Created by mac on 13-8-4.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILShootBear.h"
#import "Box2D.h"

@interface ILBox2dFactory : NSObject

@property (assign, nonatomic) b2World *world;

- (b2Body *)createLineSegement:(NSArray *)line;

- (id)initWithB2World:(b2World *)world;

@end
