//
//  ILLevelLayer.m
//  ShootBear
//
//  Created by mac on 13-8-27.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILLevelLayer.h"
#import "ILBox2dFactory.h"
#import "CCBAnimationManager+RmoveDeadNode.h"
#import "CCBAnimationManager.h"
#import "CCBReader.h"
#import "ILOptimalPerformance.h"
#import "ILClippingNode.h"
#import "ILLightning.h"

@implementation ILLevelLayer

- (void)didLoadFromCCB
{
   
    [self searchSprite:self];

    
}

- (void)onEnter
{
    [super onEnter];
    ILOptimalPerformance *performace = [[ILOptimalPerformance alloc] initWithCCNode:self];
    [performace executeOptimized];
    _electricBatchNode = performace.electricBatchNode;
    _clippingNode = [ILClippingNode clippingNode];
    [_clippingNode addStencil:_electricBatchNode];
    ILLightning *lightning = [ILLightning node];
    [_clippingNode addChild:lightning];
    [self addChild:_clippingNode];
    [performace release];
}


- (id)init
{
    self = [super init];
    if (self) {
        _bears = [[NSMutableArray array] retain];
        [[ILBox2dFactory sharedFactory] setBearCollisionDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [_bears release], _bears = nil;
    [super dealloc];
}

- (void)switchMetalParent:(ILMetal *)metal
{
    [metal retain];
    [metal removeFromParent];
    [_electricBatchNode addChild:metal];
    [metal release];
}

- (void)addStencil:(CCNode *)node
{
    [_clippingNode addStencil:node];
}

- (void)removeStencil:(CCNode *)node
{
    [_clippingNode removeStencil:node];
}

- (void)searchSprite:(CCNode *)node
{
    CCArray *children = node.children;
    for (id child in children) {
        if ([child isKindOfClass:[ILShooter class]]) {
            _shooter = child;
        }
        if ([child isKindOfClass:[ILBear class]]) {
            [_bears addObject:child];
        }
        [self searchSprite:child];
    }
}

- (void)removeBear:(ILBear *)bear
{
    [bear dead];
    [_bears removeObject:bear];
    CGPoint explisionPosition = [bear explisionPosition];
    CCNode *explisionNode = [CCBReader nodeGraphFromFile:@"BearDeadParticle.ccbi"];
    explisionNode.position = explisionPosition;
    [self addChild:explisionNode];
    [explisionNode.userObject setCompletedAnimationCallbackBlock:^(id sender) {
        [explisionNode removeFromParent];
    }];
    [self.userObject removeDeadNode:bear];
    [bear removeFromParentAndCleanup:YES];
    if (_bears.count == 0 && bear != nil) {
        [(id)self.delegate performSelector:@selector(levelCompleted) withObject:nil afterDelay:1];
    }
}

- (void)headCollision:(ILBear *)bear bullet:(ILBullet *)bullet
{
    [self removeBear:bear];
}

- (void)bodyCollision:(ILBear *)bear bullet:(ILBullet *)bullet
{
    [self removeBear:bear];
}

- (void)legCollision:(ILBear *)bear bullet:(ILBullet *)bullet
{
    [self removeBear:bear];
}

- (void)switchGunType:(NSString *)gunType
{
    [_shooter replaceGunType:gunType];
}

- (void)notificationShooterFire
{
    [_shooter fire];
}

- (void)addToFireParticleBatchNode:(CCParticleSystem *)particle
{
    if (_particleBatchNode == nil) {
        _particleBatchNode = [CCParticleBatchNode batchNodeWithFile:@"ccbParticleFire.png"];
        [self addChild:_particleBatchNode z:10000];
    }
    [_particleBatchNode addChild:particle z:particle.zOrder tag:particle.tag];
    
}

- (void)addToElectricBatchNode:(CCSprite *)sprite clipSprite:(CCSprite *)clipSrptie
{
    
}



- (void)onExit
{
    [super onExit];
    [[ILBox2dFactory sharedFactory] removeAllDelegate];

}


@end
