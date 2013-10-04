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
    return 1;
}

- (void)runCoinAddAnimation:(CGPoint )position coin:(int)number
{
    NSString *coinNumber = [NSString stringWithFormat:@"+%i", number];
    position.y -= 30;
    CCLabelTTF *label = [CCLabelTTF labelWithString:coinNumber fontName:@"Helvetica" fontSize:24 * [self resolutionScale]];
    [label setColor:ccRED];
    label.position = position;
    [self addChild:label];
    id animationSub1 = [CCFadeOut actionWithDuration:2];
    id animationSub2 = [CCMoveBy actionWithDuration:2 position:ccp(0, 30)];
    id animation1 = [CCSpawn actions:animationSub1, animationSub2, nil];
    id animation2 = [CCCallFuncN actionWithTarget:self selector:@selector(removeLabelFromParent:)];
    id seq = [CCSequence actions:animation1, animation2, nil];
    [label runAction:seq];
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
    [headGood.userObject setCompletedAnimationCallbackBlock:^(id sender) {
        [headGood removeFromParent];
        [bself runCoinAddAnimation:position coin:10];
        [headGood.userObject setCompletedAnimationCallbackBlock:nil];
    }];
    headGood.position = position;
    [self addChild:headGood];
    [self removeBear:bear];
    [self postMessage:@"head"];
}

- (void)postMessage:(NSString *)message
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"coin_increase" object:nil userInfo:@{@"bear" : message}];

}

- (void)bodyCollision:(ILBear *)bear bullet:(ILBullet *)bullet
{
    CGPoint position = bear.explisionPosition;
    [self removeBear:bear];
    [self postMessage:@"body"];
    [self runCoinAddAnimation:position coin:1];


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
    legGood.position = position;
    [self addChild:legGood];
    [self removeBear:bear];
    [self postMessage:@"leg"];
    [self runCoinAddAnimation:position coin:5];
    
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
