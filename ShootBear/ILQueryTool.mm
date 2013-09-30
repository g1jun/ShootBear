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
    float scale = 1.1;
    if (sprite.b2Body->GetType() == b2_staticBody) {
        scale = 1.5;
    }
    [ILQueryTool queryAround:sprite callback:callback scale:scale];
}

+ (void)queryAround:(ILSpriteBase *)sprite callback:(b2QueryCallback *)callback scale:(float)scale
{
    b2World *world = sprite.b2Body->GetWorld();
    CGSize size = sprite.contentSize;
    CGPoint origin = [sprite.parent convertToWorldSpace:sprite.position];
    origin.x -= sprite.anchorPoint.x * size.width;
    origin.y -= sprite.anchorPoint.y * size.height;
    float offsetX = size.width * scale / 2;
    float offsetY = size.height * scale / 2;
    b2AABB querAABB;
    float lowerX = (origin.x - offsetX) / PIXELS_PER_METER;
    float lowerY = (origin.y - offsetY) / PIXELS_PER_METER;
    float upperX = (origin.x + offsetX) / PIXELS_PER_METER;
    float upperY = (origin.y + offsetY) / PIXELS_PER_METER;
    querAABB.lowerBound = b2Vec2(lowerX, lowerY);
    querAABB.upperBound = b2Vec2(upperX, upperY);
    world->QueryAABB(callback, querAABB);
}

@end
