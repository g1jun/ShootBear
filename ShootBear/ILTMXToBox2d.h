//
//  ILTMXToBox2d.h
//  ShootBear
//
//  Created by mac on 13-8-4.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "cocos2d.h"


@interface ILTMXToBox2d : NSObject

- (void) loadPhysics;

@property (assign, nonatomic) b2World *world;
@property (retain, nonatomic) CCTMXTiledMap *tmxMap;
@property (retain, nonatomic) NSString *collisionString;


@end
