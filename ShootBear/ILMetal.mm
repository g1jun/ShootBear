//
//  ILMetal.m
//  ShootBear
//
//  Created by mac on 13-8-25.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILMetal.h"
#import "CCBReader.h"
#import "ILQueryTool.h"
#import "CCBAnimationManager.h"
#import "ILBullet.h"
#import "ILLevelLayer.h"

class MetalQueryCallback : public b2QueryCallback
{
    bool ReportFixture(b2Fixture* fixture) {
        id node = (id)fixture->GetBody()->GetUserData();
        if ([node isKindOfClass:[ILMetal class]]) {
            [node conductElectricity];
        }
        return YES;
    }
};

@implementation ILMetal

- (NSString *)collisionType
{
    return kCollisionMetal;
}

- (void)onEnter
{
    [super onEnter];
    if (_hasElctric && _animationSprite == nil) {
        [self electricity];
    }
}

- (void)collisionDealWith:(id<ILCollisionDelegate>)another
{
    if ([[another collisionType]isEqualToString:kCollisionBullet] &&
        [[[another collisionCCNode] bulletType] isEqualToString:kElectriGunBullet]) {
        [self conductElectricity];
    }
}

- (void)conductElectricity
{
    if (self.hasElctric) {
        return;
    }
    [self electricity];
}

- (void)electricity
{
    self.hasElctric = YES;
    [self showWithClippingNode];
    [self conductAround];
}

- (void)runCCBAnimation:(CCBAnimationManager *)manager
{
    [manager runAnimationsForSequenceNamed:@"lightning"];
}

- (CCAnimation *)animation
{
    CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"lightning"];
    if (animation == nil) {
        NSMutableArray *frames = [NSMutableArray array];
        for (int i = 1; i < 7; i ++) {
            NSString *frameNmae = [NSString stringWithFormat:@"lightning%i.png", i];
//            CCSpriteFrame *frame = [CCSpriteFrame frameWithTextureFilename:@"people.png" rect:CGRectMake(0, 0, 256, 256)];
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameNmae];
            [frames addObject:frame];
        }
        animation = [CCAnimation animationWithSpriteFrames:frames delay:0.1];
        [[CCAnimationCache sharedAnimationCache] addAnimation:animation name:@"lightning"];
    }
    return animation;
}

- (CCSprite *)lightningSprite
{
    CCSprite *ret = [CCSprite spriteWithSpriteFrameName:@"lightning1.png"];
    [ret runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[self animation]]]];
    return ret;
}

- (ILLevelLayer *)layer
{
    CCNode *temp = self;
    while (temp.parent) {
        temp = temp.parent;
        if ([temp isKindOfClass:[ILLevelLayer class]]) {
            return (ILLevelLayer *)temp;
        }
    }
    return nil;
}

- (void)showWithClippingNode
{

    CCSprite *tempSprite = [self lightningSprite];
    int widthReapt = self.contentSize.width / tempSprite.contentSize.width + 1;
    for (int i = 0; i < widthReapt; i++) {
        tempSprite.position = ccpMult(ccpFromSize(self.contentSize), 0.5f);
        tempSprite.anchorPoint = self.anchorPoint;
        tempSprite.position = [self.parent convertToWorldSpace:self.position];
        [[self layer] addToElectricBatchNode:tempSprite clipSprite:self];
        if (i < widthReapt - 1) {
            tempSprite = [self lightningSprite];
        }
    }
}

- (CCSprite *)CCBMetalLightningSprite
{
    return (CCSprite *)[CCBReader nodeGraphFromFile:@"MetalLightning.ccbi"];
}



- (void)conductAround
{
    MetalQueryCallback callback;
    [ILQueryTool queryAround:self callback:&callback];
}

@end
