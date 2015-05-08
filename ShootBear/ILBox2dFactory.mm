//
//  ILBox2dFactory.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-4.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBox2dFactory.h"
#import "ILBox2dConfig.h"
#import "ILContactListener.h"
#import "ILShapeCache.h"

@interface ILBox2dFactory ()

@property (assign, nonatomic) ILContactListener *contactListener;
@property (retain, nonatomic) NSMutableDictionary *collisionDelegates;

@end

@implementation ILBox2dFactory

+ (ILBox2dFactory *)sharedFactory
{
    static ILBox2dFactory *factory = nil;
    if (factory == nil) {
        factory = [[self alloc] init];
    }
    return factory;
}

- (void)dealloc
{
    self.collisionDelegates = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.collisionDelegates = [NSMutableDictionary dictionary];
        [[ILShapeCache sharedShapeCache] setPTMRatio:PIXELS_PER_METER];
        [[ILShapeCache sharedShapeCache] addShapesWithFile:@"BearPhysics.plist"];
        [[ILShapeCache sharedShapeCache] addShapesWithFile:@"ElementPhysics.plist"];
    }
    return self;
}

- (void)prepareB2World
{
    _world = [self createPhyscisWorld];
    [self configWorldBound];
    _contactListener = new ILContactListener();
    _world->SetContactListener(_contactListener);
    [self.collisionDelegates removeAllObjects];
    

}

- (void)configWorldBound
{
    CGSize s = [[CCDirector sharedDirector] winSize];

    b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	b2Body* groundBody = _world->CreateBody(&groundBodyDef);
	b2EdgeShape groundBox;
	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PIXELS_PER_METER,0));
	groundBody->CreateFixture(&groundBox,0);
	// top
	groundBox.Set(b2Vec2(0,s.height/PIXELS_PER_METER),
                  b2Vec2(s.width/PIXELS_PER_METER,s.height/PIXELS_PER_METER));
	groundBody->CreateFixture(&groundBox,0);
	// left
	groundBox.Set(b2Vec2(0,s.height/PIXELS_PER_METER), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	// right
	groundBox.Set(b2Vec2(s.width/PIXELS_PER_METER,s.height/PIXELS_PER_METER), b2Vec2(s.width/PIXELS_PER_METER,0));
	groundBody->CreateFixture(&groundBox,0);
}

- (b2World *) createPhyscisWorld
{
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	b2World *world = new b2World(gravity);
	world->SetAllowSleeping(true);
    world->SetContinuousPhysics(true);
    return world;
}


- (void)releaseB2World
{
    delete _contactListener;
    delete _world;
    _contactListener = NULL;
    _world = NULL;
}

- (b2Body *)createLineSegement:(NSArray *)lines
{
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    b2Body *body = self.world->CreateBody(&bodyDef);
    for (ILLineSegment *line in lines) {
        b2EdgeShape groundBox;
        groundBox.Set(b2Vec2(line.start.x / PIXELS_PER_METER,
                             line.start.y / PIXELS_PER_METER),
                      b2Vec2(line.end.x / PIXELS_PER_METER,
                             line.end.y / PIXELS_PER_METER));
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &groundBox;
        fixtureDef.density = 0;
        fixtureDef.filter.maskBits = 0xffff;
        fixtureDef.filter.categoryBits = 1;
        body->CreateFixture(&fixtureDef);
    }
    return body;
}

- (void)addPhysicsFeature:(CCNode *) node
{
    CCArray *childrens = [node children];
    for (CCNode *children in childrens) {
        if ([children conformsToProtocol:@protocol(ILCollisionDelegate)]) {
            [self addBox2dFeatureToSprite:(ILPhysicsSprite*)children];
            continue;
        }
        [self addPhysicsFeature:children];
    }
}

- (void)addBox2dFeatureToSprite:(ILPhysicsSprite *)sprite
{
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    b2Body *body = [ILBox2dFactory sharedFactory].world->CreateBody(&bodyDef);
    [sprite setPTMRatio:PIXELS_PER_METER];
    [[ILShapeCache sharedShapeCache] addFixturesToBody:body forPhysicsSprite:sprite];
    [sprite setB2Body:body];
    
}

#pragma mark collision delegate
- (void)setBearCollisionDelegate:(id<ILBearCollisionDelegate>)delegate
{
    NSValue *value = [NSValue valueWithPointer:delegate];
    self.collisionDelegates[kILBearCollisionDelegate] = value;
}

- (void)removeAllDelegate
{
    [self.collisionDelegates removeAllObjects];
}

- (void)bearDead:(ILBear *)bear
{
    NSValue *value = self.collisionDelegates[kILBearCollisionDelegate];
    id target = (id)[value pointerValue];
    if ([target respondsToSelector:@selector(headCollision:bullet:)]) {
        [target performSelector:@selector(headCollision:bullet:) withObject:bear withObject:nil];
    }
}

- (void)runTarget:(ILCollisionParameter *)param
{
    if (param == nil) {
        return;
    }
    [param retain];
    NSValue *value = self.collisionDelegates[param.delegateKey];
    id target = (id)[value pointerValue];
    if ([target respondsToSelector:param.selector]) {
        [target performSelector:param.selector withObject:param.meReference withObject:param.anotherReference];
    }
    [param release];
}

@end
