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
    self.hasElctric = YES;
    float randomTime = CCRANDOM_0_1() * 0.2;
    [self performSelector:@selector(addCCBSprite) withObject:nil afterDelay:randomTime];
    [self conductAround];
}

- (void)addCCBSprite
{
    CCSprite *spriteAnimation = (CCSprite *)[CCBReader nodeGraphFromFile:@"MetalLightning.ccbi"];
    spriteAnimation.position = ccpMult(ccpFromSize(self.contentSize), 0.5f);
    [self showWithClippingNode:spriteAnimation];
    CCBAnimationManager *manager = spriteAnimation.userObject;
    [manager runAnimationsForSequenceNamed:@"lightning"];
    
}

- (CCNode *)showWithClippingNode: (CCSprite *)sprite
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
    CCClippingNode *clip = [CCClippingNode clippingNodeWithStencil:sencil];
    clip.contentSize = self.contentSize;
    clip.anchorPoint = ccp(0.5, 0.5);
    clip.position = ccpMult(ccpFromSize(self.contentSize), 0.5);
    [self addChild:clip];
    sprite.anchorPoint = ccp(0.5, 0.5);
    sprite.position = ccpMult(ccpFromSize(clip.contentSize), 0.5);
    [clip addChild:sprite];
     return clip;
}

- (void)conductAround
{
    MetalQueryCallback callback;
    [ILQueryTool queryAround:self callback:&callback];
}

//- (void)visit
//{
//    glEnable(GL_SCISSOR_TEST);
//    float width = self.contentSize.width;
//    float height = self.contentSize.height;
//    glScissor(self.position.x - self.anchorPoint.x * width, self.position.y - self.anchorPoint.y * height, width, height);
//    [super visit];
//    glDisable(GL_SCISSOR_TEST);
//}




@end
