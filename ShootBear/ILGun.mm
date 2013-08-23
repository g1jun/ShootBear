//
//  ILGun.m
//  ShootBear
//
//  Created by mac on 13-8-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILGun.h"
#import "ILTools.h"
#import "ILBox2dEntity.h"
#import "CCBReader.h"
#import "ILBox2dFactory.h"
#import "ILBullet.h"
#import "CCBReader.h"

#define BULLET 30

@implementation ILGun

- (void)dealloc
{
    _lineReference = nil;
    [super dealloc];
}


- (void)fire
{
    ILBullet *bullet = (ILBullet *)[CCBReader nodeGraphFromFile:@"Bullet.ccbi"];
    [self addChild:bullet];
    [bullet.entity setPTMRatio:PIXELS_PER_METER];
    [bullet setPosition:self.lineReference.position];
    CGPoint v = [self lineReferenceVector];
    [[ILBox2dFactory sharedFactory] addPhysicsFeature:bullet];
    
    [bullet.entity setSpeed:b2Vec2(v.x, v.y)];
}

- (CGPoint)lineReferenceVector
{
    float degree = [self lineTotalDegree];
    float radius = -CC_DEGREES_TO_RADIANS(degree);
    return ccpRotateByAngle(ccp(100, 0), ccp(0, 0), radius);
}

- (float)lineTotalDegree
{
    return [ILTools rotationTotal:self.lineReference];
}


- (CCSprite *)findGunSprite
{
    CCArray *children = self.children;
    for (id ch in children) {
        if ([ch isKindOfClass:[CCSprite class]]) {
            return ch;
        }
    }
    return nil;
}

@end
