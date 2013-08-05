//
//  ILPlayScene.m
//  ShootBear
//
//  Created by mac on 13-8-4.
//  Copyright 2013年 mac. All rights reserved.
//

#import "ILPlayScene.h"

@interface ILPlayScene ()

@property (assign, nonatomic) b2World *world;

@end

@implementation ILPlayScene

- (id)init {
    self = [super init];
    if(self) {
        self.world = [self createPhyscisWorld];
        CCLayer *tmxLayer = [ILTMXLayer nodeWithB2World:self.world];
//        [self addChild:tmxLayer];
        [self scheduleUpdate];
    }
    return self;
}

-(void) update: (ccTime) dt
{
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	self.world->Step(dt, velocityIterations, positionIterations);
}

-(void) draw
{
	[super draw];
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	kmGLPushMatrix();
	self.world->DrawDebugData();
	kmGLPopMatrix();
}



- (b2World *) createPhyscisWorld
{	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	b2World *world = new b2World(gravity);
	world->SetAllowSleeping(true);
    world->SetContinuousPhysics(true);
    GLESDebugDraw *debugDraw = new GLESDebugDraw(PIXELS_PER_METER);
	world->SetDebugDraw(debugDraw);
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	debugDraw->SetFlags(flags);
    return world;
}

@end
