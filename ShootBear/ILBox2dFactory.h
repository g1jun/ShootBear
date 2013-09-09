//
//  ILBox2dFactory.h
//  ShootBear
//
//  Created by mac on 13-8-4.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILShootBear.h"
#import "ILBearCollisionDelegate.h"
#import "ILCollisionParameter.h"
#import "Box2D.h"

@interface ILBox2dFactory : CCNode

@property (assign, nonatomic, readonly) b2World *world;


- (b2Body *)createLineSegement:(NSArray *)line;

- (void)prepareB2World;

- (void)releaseB2World;

- (void)addPhysicsFeature:(CCNode *) node;

- (void)setBearCollisionDelegate:(id<ILBearCollisionDelegate>)delegate;

- (void)removeAllDelegate;

- (void)runTarget:(ILCollisionParameter *)param;

+ (ILBox2dFactory *)sharedFactory;

@end
