//
//  ILGun.m
//  ShootBear
//
//  Created by mac on 13-8-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILGun.h"
#import "ILTools.h"

#define BULLET 30

@implementation ILGun

- (void)dealloc
{
    self.lineReference = nil;
    [super dealloc];
}

- (void)fire
{
    CGPoint fireLocalPoint = self.lineReference.position;
    CGPoint fireGLPoint = [self.parent convertToWorldSpace:fireLocalPoint];
    
}

- (CGPoint)lineReferenceVector
{
    float degree = [self lineTotalDegree];
    float radius = -CC_DEGREES_TO_RADIANS(degree);
    return ccpRotateByAngle(ccp(100, 0), ccp(0, 0), radius);
}

- (float)lineTotalDegree
{
    return [ILTools rotationTotal:self];
}

@end
