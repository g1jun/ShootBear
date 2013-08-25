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
    [self conductElectricity];
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
    [self addChild:spriteAnimation];
    CCBAnimationManager *manager = spriteAnimation.userObject;
    [manager runAnimationsForSequenceNamed:@"lightning"];
    
}

- (void)runCCBAnimation:(CCBAnimationManager *)manager
{
    
}

- (void)conductAround
{
    MetalQueryCallback callback;
    [ILQueryTool queryAround:self callback:&callback];
}

- (void)visit
{
    glEnable(GL_SCISSOR_TEST);
    float width = self.contentSize.width;
    float height = self.contentSize.height;
    glScissor(self.position.x - self.anchorPoint.x * width, self.position.y - self.anchorPoint.y * height, width, height);
    [super visit];
    glDisable(GL_SCISSOR_TEST);
}




@end
