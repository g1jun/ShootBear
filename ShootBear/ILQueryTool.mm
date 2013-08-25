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
    CGRect rect = sprite.boundingBox;
    float offset = MIN(sprite.contentSize.width, sprite.contentSize.height) * 0.1f;
    b2AABB querAABB;
    float lowerX = (rect.origin.x - offset) / PIXELS_PER_METER;
    float lowerY = (rect.origin.y - offset) / PIXELS_PER_METER;
    float upperX = (rect.origin.x + rect.size.width + offset) / PIXELS_PER_METER;
    float upperY = (rect.origin.y + rect.size.height + offset) / PIXELS_PER_METER;
    querAABB.lowerBound = b2Vec2(lowerX, lowerY);
    querAABB.upperBound = b2Vec2(upperX, upperY);
    world->QueryAABB(callback, querAABB);
}

@end
