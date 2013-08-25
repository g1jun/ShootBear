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
    
    [self burning];
}

- (void)burning
{
    if (self.isBurning) {
        return;
    }
    self.isBurning = YES;
    CCParticleSystemQuad *particle = (CCParticleSystemQuad *)[CCBReader nodeGraphFromFile:@"WoodParticle"];
    particle.sourcePosition = ccpMult(ccpFromSize(self.contentSize), 0.5);
    particle.posVar = ccpMult(ccpFromSize(self.contentSize), 0.5f);
    particle.emissionRate *= 1 / [self resolutionScale];
    [self addChild:particle];
    [self burnAroundWood];
}

- (void)burnAroundWood
{
//    b2World *world = self.b2Body->GetWorld();
//    CGRect rect = self.boundingBox;
//    float offset = MIN(self.contentSize.width, self.contentSize.height) * 0.1f;
//    b2AABB querAABB;
//    float lowerX = (rect.origin.x - offset) / PIXELS_PER_METER;
//    float lowerY = (rect.origin.y - offset) / PIXELS_PER_METER;
//    float upperX = (rect.origin.x + rect.size.width + offset) / PIXELS_PER_METER;
//    float upperY = (rect.origin.y + rect.size.height + offset) / PIXELS_PER_METER;
//    querAABB.lowerBound = b2Vec2(lowerX, lowerY);
//    querAABB.upperBound = b2Vec2(upperX, upperY);
//    WoodQueryCallback callback;
//    world->QueryAABB(&callback, querAABB);
    WoodQueryCallback callback;
    [ILQueryTool queryAround:self callback:&callback];
}

@end
