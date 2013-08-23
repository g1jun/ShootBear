//
//  ILBullet.h
//  ShootBear
//
//  Created by mac on 13-8-14.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILPhysicsSprite.h"
#import "ILSpriteBase.h"
#import "Box2D.h"

@interface ILBox2dEntity : ILSpriteBase


- (void)setSpeed:(b2Vec2) speed;



@end
