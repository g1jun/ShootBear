//
//  ILPlayScene.m
//  ShootBear
//
//  Created by mac on 13-8-4.
//  Copyright 2013年 mac. All rights reserved.
//

#import "ILPlayScene.h"
#import "ILBox2dDebug.h"
#import "CCBReader.h"
#import "GB2ShapeCache.h"
#import "ILPhysicsSprite.h"

@interface ILPlayScene ()

@property (assign, nonatomic) b2World *world;

@end

@implementation ILPlayScene

- (id)init {
    self = [super init];
    if(self) {
        self.world = [self createPhyscisWorld];
        [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"BearPhysics.plist"];
        CCLayer *tmxLayer = [ILTMXLayer nodeWithB2World:self.world];
        [self addChild:tmxLayer];
        ILBox2dDebug *debug = [[ILBox2dDebug alloc] initWithB2World:self.world];
        [self addChild:debug];
        [debug release];
        CCNode *shooter = [CCBReader nodeGraphFromFile:@"Shooter.ccbi"];
        shooter.position = ccp(100, 100);
        CCNode *bear = [CCBReader nodeGraphFromFile:@"BearRight.ccbi"];
        bear.position = ccp(300, 300);
        [self addChild:bear];
        
        [self addPhysicsFeature:bear];
        [self addChild:shooter];
        [self scheduleUpdate];
        
    }
    return self;
}

- (void)addPhysicsFeature:(CCNode *) node
{
    CCArray *childrens = [node children];
    for (CCNode *children in childrens) {
        if ([children isKindOfClass:[ILPhysicsSprite class]]) {
            [self addBox2dFeatureToSprite:(ILPhysicsSprite*)children];
            continue;
        }
        [self addPhysicsFeature:children];
    }
}

- (void)addBox2dFeatureToSprite:(ILPhysicsSprite *)sprite
{
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    b2Body *body = _world->CreateBody(&bodyDef);
    [sprite setPTMRatio:8];
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:body forShapeName:sprite.imageName];
   [sprite setAnchorPoint: [[GB2ShapeCache sharedShapeCache] anchorPointForShape:sprite.imageName]];
    [sprite setB2Body:body];

}

-(void) update: (ccTime) dt
{
	int32 velocityIterations = 10;
	int32 positionIterations = 10;
	self.world->Step(dt, velocityIterations, positionIterations);
}




- (b2World *) createPhyscisWorld
{	
	b2Vec2 gravity;
	gravity.Set(0.0f, 0);
	b2World *world = new b2World(gravity);
	world->SetAllowSleeping(false);
    world->SetContinuousPhysics(true);
    return world;
}

@end
