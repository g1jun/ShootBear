//
//  ILSpriteBase.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-17.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCSprite.h"
#import "Box2D.h"
#import "ILCollisionDelegate.h"
#import "ILSprite.h"

enum PhysicsMode {
    Box2dMode,
    AnimationMode,
};

@interface ILSpriteBase : ILSprite <ILCollisionDelegate>
{
    b2Body *_b2Body;
}



@property(nonatomic, assign) b2Body *b2Body;

@property(nonatomic, assign) float PTMRatio;

@property(nonatomic, assign) BOOL ignoreBodyRotation;

@property(assign, nonatomic)BOOL isStatic;

@property (assign, nonatomic)PhysicsMode mode;

- (void)didLoadFromCCB;

- (void)box2dMode;

- (void)animationMode;

- (void)configBody;

@end
