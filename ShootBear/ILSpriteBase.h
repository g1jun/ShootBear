//
//  ILSpriteBase.h
//  ShootBear
//
//  Created by mac on 13-8-17.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCSprite.h"
#import "ILPhysicsFlag.h"
#import "Box2D.h"

@interface ILSpriteBase : CCSprite <ILPhysicsFlag>

@property (copy, nonatomic) NSString *imageName;

@property(nonatomic, assign) b2Body *b2Body;

@property(nonatomic, assign) float PTMRatio;

@property(nonatomic, assign) BOOL ignoreBodyRotation;

@end
