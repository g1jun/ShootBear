//
//  ILBullet.h
//  ShootBear
//
//  Created by mac on 13-8-14.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILPhysicsSprite.h"
#import "Box2D.h"

@interface ILBox2dEntity : CCSprite <ILPhysicsFlag>
{
}


- (void)setSpeed:(b2Vec2) speed;

@property (copy, nonatomic) NSString *imageName;

@property(nonatomic, assign) b2Body *b2Body;

@property(nonatomic, assign) float PTMRatio;

@property(nonatomic, assign) BOOL ignoreBodyRotation;

@end
