//
//  ILBox2dFactory.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-4.
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

- (void)bearDead:(ILBear*)bear;

+ (ILBox2dFactory *)sharedFactory;

@end
