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
#import "ILLevelLayer.h"
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

- (BOOL) isFireBullet:(id)another
{
    return [[another collisionType] isEqualToString:kCollisionBullet] && [[[another collisionCCNode] bulletType] isEqualToString:kFireGunBullet];
}

- (BOOL)isBurningWood:(id)another
{
    if ([[another collisionType] isEqualToString:kCollisionWood]) {
        ILWood *wood = [another collisionCCNode];
        if (wood.isBurning) {
            return YES;
        }
    }
    return NO;
}

- (void)collisionDealWith:(id<ILCollisionDelegate>)another
{
    if ([self isFireBullet:another] || [self isBurningWood:another]) {
        [self burning];
    }
    
}

- (void)onEnter
{
    [super onEnter];
    if (_isBurning && _particle == nil) {
        [self burnWood];
    }
    if (!self.isStatic) {
        [self schedule:@selector(updateParticlePosition:)];
    }
}

- (void)updateParticlePosition:(ccTime)delta
{
    CGPoint point = ccp(-self.contentSize.width * self.anchorPoint.x,- self.contentSize.height * self.anchorPoint.y);;
    _particle.position =  ccpAdd(point, [self.parent convertToWorldSpace:self.position]); 
}

- (void)burning
{
    if (self.isBurning) {
        return;
    }
    [self burnWood];
}

- (void)burnWood
{
    self.isBurning = YES;
    _particle = (CCParticleSystemQuad *)[CCBReader nodeGraphFromFile:@"WoodParticle"];
    _particle.positionType = kCCPositionTypeGrouped;
    _particle.sourcePosition = ccpMult(ccpFromSize(self.contentSize), 0.5);
    _particle.posVar = ccpMult(ccpFromSize(self.contentSize), 0.5f);
    float scale = [self resolutionScale];
    if (self.b2Body->GetType() == b2_staticBody) {
        _particle.emissionRate *= 1 / [self resolutionScale];
        float total = [ILTools rotationTotal:self];
        [_particle setAngle: total + 90];
        [_particle setEmissionRate:5 * scale];
        [_particle setTotalParticles:10 * scale];
    } else {
        [_particle setAngleVar:360];
        [_particle setEmissionRate:50 * scale];
        [_particle setTotalParticles:250 * scale];

        _particle.position = ccp(-self.contentSize.width * self.anchorPoint.x,- self.contentSize.height * self.anchorPoint.y);
    }
    _particle.position = ccpAdd(_particle.position, [self.parent convertToWorldSpace:self.position]) ;
    _particle.anchorPoint = self.anchorPoint;
    if (self.isStatic) {
        [[self layer] addToFireParticleBatchNode:_particle];
    } else {
        [[self layer] addChild:_particle z:10000];
    }
    [ILBox2dTools changeCategoryBit:self bit:1 << 3];
    [self burnAroundWood];
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

- (void)burnAroundWood
{
    WoodQueryCallback callback;
    [ILQueryTool queryAround:self callback:&callback];
}

- (BOOL)dirty
{
    return YES;
}

@end
