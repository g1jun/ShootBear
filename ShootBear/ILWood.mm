//
//  ILWood.m
//  ShootBear
//
//  Created by mac on 13-8-24.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILWood.h"
#import "ILBullet.h"
#import "CCBReader.h"
#import "CCNode+CCBRelativePositioning.h"
#import "ILQueryTool.h"
#import "ILTools.h"
#import "ILBox2dTools.h"

class WoodQueryCallback : public b2QueryCallback
{
    bool ReportFixture(b2Fixture* fixture) {
        id node = (id)fixture->GetBody()->GetUserData();
        if ([node isKindOfClass:[ILWood class]]) {
            [node burning];
        }
        
        return true;
    }
};

@implementation ILWood

- (NSString *)collisionType
{
    return kCollisionWood;
}

- (void)collisionDealWith:(id<ILCollisionDelegate>)another
{
    if ([[another collisionType] isEqualToString:kCollisionBullet] && [[[another collisionCCNode] bulletType] isEqualToString:kFireGunBullet]) {
        [self burning];
    }
    
}


- (void)burning
{
    if (self.isBurning) {
        return;
    }
    self.isBurning = YES;
    _particle = (CCParticleSystemQuad *)[CCBReader nodeGraphFromFile:@"WoodParticle"];
    _particle.sourcePosition = ccpMult(ccpFromSize(self.contentSize), 0.5);
    _particle.posVar = ccpMult(ccpFromSize(self.contentSize), 0.5f);
    _particle.emissionRate *= 1 / [self resolutionScale];
    float total = [ILTools rotationTotal:self];
    [_particle setAngle: total + 90];
    [_particle setEmissionRate:10];
    [_particle setTotalParticles:20];
    [self addChild:_particle];
    [ILBox2dTools changeCategoryBit:self bit:1 << 3];
    [self burnAroundWood];
}

- (void)burnAroundWood
{
    WoodQueryCallback callback;
    [ILQueryTool queryAround:self callback:&callback];
}

@end
