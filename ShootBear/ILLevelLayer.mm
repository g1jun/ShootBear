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
#import "CCNode+CCBRelativePositioning.h"
#import "SimpleAudioEngine.h"
#import "ILCoin.h"
#import "ILDataSimpleSave.h"
@implementation ILLevelLayer

- (void)didLoadFromCCB
{
   
    [self searchSprite:self];
    _bearsQuantity = _bears.count;

    
}

- (int)bearsQuantity
{
    return _bearsQuantity;
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
        [self performSelector:@selector(completedLevel) withObject:nil afterDelay:[self levelCompletedDelay]];
    }
}

- (void)completedLevel
{
    float percent = (float)_bearDeadPerfect / _bearsQuantity;
    [self.delegate levelCompleted:percent];

}

- (float)levelCompletedDelay
{
    return 2;
}

- (void)runCoinAddAnimation:(CGPoint )position file:(NSString *)fileName
{
    BOOL isShowCoin = [[ILDataSimpleSave sharedDataSave] boolWithKey:@"show_coin_teach"];
    if (!isShowCoin) {
        return;
    }
    CCNode *coinItem = [CCBReader nodeGraphFromFile:fileName owner:self];
    coinItem.position = position;
    [self addChild:coinItem];
}

- (void)collectCoin:(id)sender
{
    [sender removeFromParent];
    if ([sender isKindOfClass:[ILCoin class]]) {
        ILCoin *coin = (ILCoin *)sender;
        [self postMessage:coin.coinType];

    }
    [[SimpleAudioEngine sharedEngine] playEffect:@"pick_up_coin.wav"];


}

- (void)pressedCoinButton:(id)sender
{
    CGPoint temp = self.moneyBagPosition;
    temp.y -= 33 / 2 * [self resolutionScale];
    CCMoveTo *move = [CCMoveTo actionWithDuration:0.7 position:temp];
    CCEaseExponentialOut *ease = [CCEaseExponentialOut actionWithAction:move];
    CCScaleTo *scale = [CCScaleTo actionWithDuration:0.7 scale:0.5];
    CCCallFuncN *call = [CCCallFuncN actionWithTarget:self selector:@selector(collectCoin:)];
    CCSpawn *spawn = [CCSpawn actions:ease, scale,nil];
    CCSequence *sequence = [CCSequence actions:spawn, call, nil];
    CCNode *node = [[sender parent] parent];
    [node runAction:sequence];
}

- (void)removeLabelFromParent:(id)sender
{
    [sender removeFromParent];
}

- (void)headCollision:(ILBear *)bear bullet:(ILBullet *)bullet
{
    _bearDeadPerfect++;
    CGPoint position = bear.explisionPosition;
    __block CCNode *headGood = [CCBReader nodeGraphFromFile:@"HeadGood.ccbi"];
    typeof(self) bself = self;
    CGPoint foot = [bear footPosition];
    [headGood.userObject setCompletedAnimationCallbackBlock:^(id sender) {
        [headGood removeFromParent];
        [bself runCoinAddAnimation:foot file:@"CoinItem3.ccbi"];
        [headGood.userObject setCompletedAnimationCallbackBlock:nil];
    }];
    headGood.position = position;
    [self addChild:headGood];
    [self removeBear:bear];
    [[SimpleAudioEngine sharedEngine] playEffect:@"bear_dead_good.wav"];

}

- (void)postMessage:(NSString *)message
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"coin_increase" object:nil userInfo:@{@"bear" : message}];

}

- (void)bodyCollision:(ILBear *)bear bullet:(ILBullet *)bullet
{
    CGPoint foot = [bear footPosition];
    [self removeBear:bear];
    [self runCoinAddAnimation:foot file:@"CoinItem1.ccbi"];
    [[SimpleAudioEngine sharedEngine] playEffect:@"bear_dead.mp3"];


}

- (void)legCollision:(ILBear *)bear bullet:(ILBullet *)bullet
{
    _bearDeadPerfect++;
    CGPoint position = bear.explisionPosition;
    __block CCNode *legGood = [CCBReader nodeGraphFromFile:@"LegGood.ccbi"];
    [legGood.userObject setCompletedAnimationCallbackBlock:^(id sender) {
        [legGood removeFromParent];
        [legGood.userObject setCompletedAnimationCallbackBlock:nil];
    }];
    CGPoint foot = [bear footPosition];
    legGood.position = position;
    [self addChild:legGood];
    [self removeBear:bear];
    [self runCoinAddAnimation:foot file:@"CoinItem2.ccbi"];
    [[SimpleAudioEngine sharedEngine] playEffect:@"bear_dead_good.wav"];
    
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
