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
#import "ILShooter.h"

#define BULLET 30

@implementation ILGun

- (void)dealloc
{
    _lineReference = nil;
    [super dealloc];
}


- (void)fire
{
    NSString *bulletFileName = [_bulletCCBName stringByAppendingString:@".ccbi"];
    ILBullet *bullet = (ILBullet *)[CCBReader nodeGraphFromFile:bulletFileName];
    [bullet.entity setPTMRatio:PIXELS_PER_METER];
    CGPoint glPoint = [self.lineReference.parent convertToWorldSpace:self.lineReference.position];
    [bullet.entity setPosition:glPoint];
    [[self bulletParent] addChild:bullet];
    CGPoint v = [self lineReferenceVector];
    [bullet.entity setSpeed:b2Vec2(v.x, v.y)];
}

- (CCNode *)bulletParent
{
    CCNode *temp = self;
    while (temp) {
        if ([temp isKindOfClass:[ILShooter class]]) {
            return temp.parent;
        }
        temp = temp.parent;
    }
    return nil;
}

- (CGPoint)lineReferenceVector
{
    float degree = [self lineTotalDegree];
    float radius = -CC_DEGREES_TO_RADIANS(degree);
    return ccpRotateByAngle(ccp(10, 0), ccp(0, 0), radius);
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
