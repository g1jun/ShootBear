//
//  ILQueryTool.m
//  ShootBear
//
//  Created by mac on 13-8-25.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILQueryTool.h"
#import "ILBox2dConfig.h"

@implementation ILQueryTool


+ (void)queryAround:(ILSpriteBase *)sprite callback:(b2QueryCallback *)callback;
{
    b2World *world = sprite.b2Body->GetWorld();
    CGSize size = sprite.contentSize;
    CGPoint origin = [sprite.parent convertToWorldSpace:sprite.position];
    origin.x -= sprite.anchorPoint.x * size.width;
    origin.y -= sprite.anchorPoint.y * size.height;
    float offset = MIN(size.width, size.height) * 0.2;
    b2AABB querAABB;
    float lowerX = (origin.x - offset) / PIXELS_PER_METER;
    float lowerY = (origin.y - offset) / PIXELS_PER_METER;
    float upperX = (origin.x + size.width + offset) / PIXELS_PER_METER;
    float upperY = (origin.y + size.height + offset) / PIXELS_PER_METER;
    querAABB.lowerBound = b2Vec2(lowerX, lowerY);
    querAABB.upperBound = b2Vec2(upperX, upperY);
    world->QueryAABB(callback, querAABB);
}

@end
