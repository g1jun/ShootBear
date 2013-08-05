//
//  ILBox2dFactory.m
//  ShootBear
//
//  Created by mac on 13-8-4.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBox2dFactory.h"
#import "ILBox2dConfig.h"

@implementation ILBox2dFactory

- (id)initWithB2World:(b2World *)world
{
    self = [super init];
    if (self) {
        self.world = world;
    }
    return self;
}

- (b2Body *)createLineSegement:(NSArray *)lines
{
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    b2Body *body = self.world->CreateBody(&bodyDef);
    for (ILLineSegment *line in lines) {
        b2EdgeShape groundBox;
        groundBox.Set(b2Vec2(line.start.x / PIXELS_PER_METER, line.start.y / PIXELS_PER_METER),
                      b2Vec2(line.end.x / PIXELS_PER_METER, line.end.y / PIXELS_PER_METER));
        body->CreateFixture(&groundBox,0);
    }
    return body;
}

@end
