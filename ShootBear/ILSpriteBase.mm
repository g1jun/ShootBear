//
//  ILSpriteBase.m
//  ShootBear
//
//  Created by mac on 13-8-17.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILSpriteBase.h"
#import "CCSpriteFrameCache+ILSpriteNameSearch.h"
#import "ILBox2dFactory.h"
#import "ILShapeCache.h"

@implementation ILSpriteBase

- (id)init
{
    self = [super init];
    if (self) {
        _isStatic = NO;
    }
    return self;
}

- (void)dealloc
{
    [ILBox2dFactory sharedFactory].world->DestroyBody(self.b2Body);
    self.imageName = nil;
    _b2Body = NULL;
    [super dealloc];
}

- (void)didLoadFromCCB
{
    b2BodyDef bodyDef;
    bodyDef.type = _isStatic ? b2_staticBody : b2_dynamicBody;
    b2Body *body = [ILBox2dFactory sharedFactory].world->CreateBody(&bodyDef);
    [self setPTMRatio:PIXELS_PER_METER];
    [[ILShapeCache sharedShapeCache] addFixturesToBody:body forPhysicsSprite:self];
    [self setB2Body:body];
}

- (NSString *)collisionType
{
    return kCollisionNothing;
}

- (id)collisionCCNode
{
    return self;
}

- (void)setDisplayFrame:(CCSpriteFrame *)newFrame
{
    [super setDisplayFrame:newFrame];
    NSString *name = [[CCSpriteFrameCache sharedSpriteFrameCache] nameBySpriteFrame:newFrame];
    self.imageName = [name stringByDeletingPathExtension];
}

@end
