//
//  ILBox2dDebug.m
//  ShootBear
//
//  Created by mac on 13-8-5.
//  Copyright 2013年 mac. All rights reserved.
//

#import "ILBox2dDebug.h"
#import "GLES-Render.h"
#import "ILBox2dConfig.h"

@interface ILBox2dDebug ()

@property (assign, nonatomic) b2World *world;

@end


@implementation ILBox2dDebug



- (id)initWithB2World:(b2World *)world
{
    self = [super init];
    if (self) {
        GLESDebugDraw *debugDraw = new GLESDebugDraw(PIXELS_PER_METER);
        world->SetDebugDraw(debugDraw);
        uint32 flags = 0;
        flags += b2Draw::e_shapeBit;
        debugDraw->SetFlags(flags);
        self.world = world;
    }
    return self;
}

-(void) draw
{
	[super draw];
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	kmGLPushMatrix();
	self.world->DrawDebugData();
	kmGLPopMatrix();
}


@end
