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
    
    if (_electricBatchNode == nil) {
        _electricBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"element.png"];
        
//        CGSize size = [CCDirector sharedDirector].winSize;
//        CGRect rect = CGRectMake(0, 0, size.width, size.height);
//        CCSprite *sprite = [CCSprite spriteWithFile:@"people.png"];
//        CCTexture2D *texutre = [[CCTextureCache sharedTextureCache] textureForKey:@"lightning1.png"];
//        CCSprite *sprite = [CCSprite spriteWithTexture:texutre rect:rect];
//        [sprite setTextureRect:rect];
//        _sencil = [CCDrawNode node];
//        _sencil.position = ccp(0, 0);
//        _sencil.anchorPoint = ccp(0, 0);
        _clippingNode = [ILClippingNode clippingNode];
//        clip.inverted = YES;
        _clippingNode.contentSize = self.contentSize;
        _clippingNode.anchorPoint = ccp(0.5, 0.5);
        _clippingNode.position = ccpMult(ccpFromSize(self.contentSize), 0.5);
//        sprite.position = ccp(100, 100);
//        ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
//        [sprite.texture setTexParameters:&tp];
//        [self addChild:sprite];
        [_clippingNode addChild:_electricBatchNode];
        [self addChild:_clippingNode z:10000];
    }
//    [self addSencilArea:clipSrptie];
    [_clippingNode addStencil:clipSrptie];
    [_electricBatchNode addChild:sprite];
}

//- (CCNode *)addSencilArea:(CCSprite *)sprite
//{
//    CGPoint rectangle[4];
//    float x = sprite.position.x - sprite.contentSize.width * sprite.anchorPoint.x;
//    float y = sprite.position.y - sprite.contentSize.height * sprite.anchorPoint.y;
//    rectangle[0] = ccp(x, y);
//    rectangle[1] = ccp(x + sprite.contentSize.width, y);
//    rectangle[2] = ccp(x + sprite.contentSize.width, y + sprite.contentSize.height);
//    rectangle[3] = ccp(x, y +  sprite.contentSize.height);
////    rectangle[0] = ccp(0, 0);
////    rectangle[1] = ccp(self.contentSize.width, 0);
////    rectangle[2] = ccp(self.contentSize.width, self.contentSize.height);
////    rectangle[3] = ccp(0, self.contentSize.height);
//    ccColor4F white = {1, 1, 1, 1};
//    [_sencil drawPolyWithVerts:rectangle count:4 fillColor:white
//                  borderWidth:0 borderColor:white];
//
//    return _sencil;
//}


- (void)onExit
{
    [super onExit];
    [[ILBox2dFactory sharedFactory] removeAllDelegate];

}


@end
