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

- (void)didLoadFromCCB
{
    [super didLoadFromCCB];
    if (_hasElctric) {
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

- (void)addCCBSprite
{
    
    
    
}
- (void)runCCBAnimation:(CCBAnimationManager *)manager
{
    [manager runAnimationsForSequenceNamed:@"lightning"];
}

- (CCNode *)showWithClippingNode
{
    
    CCClippingNode *clip = [CCClippingNode clippingNodeWithStencil:[self sencilNode]];
    clip.contentSize = self.contentSize;
    clip.anchorPoint = ccp(0.5, 0.5);
    clip.position = ccpMult(ccpFromSize(self.contentSize), 0.5);
    [self addChild:clip];
    CCSprite *tempSprite = [self CCBMetalLightningSprite];
    int widthReapt = self.contentSize.width / tempSprite.contentSize.width + 1;
    for (int i = 0; i < widthReapt; i++) {
        tempSprite.position = ccpMult(ccpFromSize(self.contentSize), 0.5f);
        float randomTime = CCRANDOM_0_1() * 0.2;
        CCBAnimationManager *manager = tempSprite.userObject;
        [self performSelector:@selector(runCCBAnimation:) withObject:manager afterDelay:randomTime];
        tempSprite.anchorPoint = ccp(0.5, 0.5);
        tempSprite.position = ccp(tempSprite.contentSize.width * (i + 0.5), clip.contentSize.height / 2);
        [clip addChild:tempSprite];
        if (i < widthReapt - 1) {
            tempSprite = [self CCBMetalLightningSprite];
        }
    }
     return clip;
}

- (CCSprite *)CCBMetalLightningSprite
{
    return (CCSprite *)[CCBReader nodeGraphFromFile:@"MetalLightning.ccbi"];
}


- (CCNode *)sencilNode
{
    CCDrawNode *sencil = [CCDrawNode node];
    CGPoint rectangle[4];
    rectangle[0] = ccp(0, 0);
    rectangle[1] = ccp(self.contentSize.width, 0);
    rectangle[2] = ccpFromSize(self.contentSize);
    rectangle[3] = ccp(0, self.contentSize.height);
    ccColor4F white = {1, 1, 1, 1};
    [sencil drawPolyWithVerts:rectangle count:4 fillColor:white
                  borderWidth:0 borderColor:white];
    sencil.position = ccp(0, 0);
    sencil.anchorPoint = ccp(0.5, 0.5);
    return sencil;
}

- (void)conductAround
{
    MetalQueryCallback callback;
    [ILQueryTool queryAround:self callback:&callback];
}

@end
