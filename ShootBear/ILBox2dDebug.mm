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
#import "ILBox2dFactory.h"
#import "CCNode+CCBRelativePositioning.h"

@interface ILBox2dDebug ()

@end


@implementation ILBox2dDebug



- (id)init
{
    self = [super init];
    if (self) {
        GLESDebugDraw *debugDraw = new GLESDebugDraw(PIXELS_PER_METER);
        [ILBox2dFactory sharedFactory].world->SetDebugDraw(debugDraw);
        uint32 flags = 0;
        flags += b2Draw::e_shapeBit;
        debugDraw->SetFlags(flags);
    }
    return self;
}

-(void) draw
{
	[super draw];
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	kmGLPushMatrix();
	[ILBox2dFactory sharedFactory].world->DrawDebugData();
	kmGLPopMatrix();
}


@end
