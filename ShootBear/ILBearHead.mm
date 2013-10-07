//
//  ILBearHead.m
//  ShootBear
//
//  Created by mac on 13-8-15.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBearHead.h"
#import "ILBearCollisionDelegate.h"

@implementation ILBearHead

- (NSString *)collisionType
{
    return kCollisionBearHead;
}

- (SEL)selectorWithType:(NSString *)type
{
    NSDictionary *dic = @{
                          kCollisionBullet :
                              [NSValue valueWithPointer:@selector(headCollision:bullet:)],
                          kCollisionWood :
                              [NSValue valueWithPointer:@selector(headCollision:bullet:)],
                          kCollisionMetal:
                              [NSValue valueWithPointer:@selector(headCollision:bullet:)],
                          kCollisionStone:
                              [NSValue valueWithPointer:@selector(headCollision:bullet:)],
                          kCollisionDefendNet:
                              [NSValue valueWithPointer:@selector(headCollision:bullet:)],
                          
                          };
    return (SEL)[dic[type] pointerValue];
}




@end
