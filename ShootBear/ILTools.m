//
//  ILTools.m
//  ShootBear
//
//  Created by mac on 13-8-12.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILTools.h"

@implementation ILTools

+ (float)rotationTotal:(CCNode *)node
{
    CCNode * temp  = node;
    float rad = node.rotation;
    while ((temp = temp.parent)) {
        rad += temp.rotation;
    }
    return rad;
}

@end
