//
//  ILLevelLayer.h
//  ShootBear
//
//  Created by mac on 13-8-27.
//  Copyright (c) 2013年 mac. All rights reserved.
//
#import "ILBearCollisionDelegate.h"
#import "ILStruct.h"
#import "CCLayer.h"
#import "ILShooter.h"
#import "ILBear.h"
#import "ILPlayControl.h"
#import "ILClippingNode.h"

@protocol ILLevelCompletedDelegate <NSObject>

@required
- (void)levelCompleted:(float)percent;

@end

@class ILMetal;
@class ILBearCollisionDelegate;
@interface ILLevelLayer : CCLayer <ILBearCollisionDelegate, ILPlayControlDelegate>
{
    ILShooter *_shooter;
    NSMutableArray *_bears;
    CCParticleBatchNode *_particleBatchNode;
    CCSpriteBatchNode *_electricBatchNode;
    ILClippingNode *_clippingNode;
    int _bearsQuantity;
    int _bearDeadPerfect;
}

@property (assign, nonatomic) id<ILLevelCompletedDelegate> delegate;
@property (assign, nonatomic)CGPoint moneyBagPosition;

- (void)addToFireParticleBatchNode:(CCParticleSystem *)particle;

- (void)addToElectricBatchNode:(CCSprite *)sprite clipSprite:(CCSprite *)clipSrptie;

- (void)switchMetalParent:(ILMetal *)metal;

- (void)addStencil:(CCNode *)node;
- (void)removeStencil:(CCNode *)node;
- (void)removeBear:(ILBear *)bear;
- (float)levelCompletedDelay;
- (int)bearsQuantity;
@end
