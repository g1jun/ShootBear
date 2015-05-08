//
//  ILBearLeg.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-15.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBearLeg.h"
#import "ILBearCollisionDelegate.h"
@implementation ILBearLeg

- (NSString *)collisionType
{
    return kCollisionBearLeg;
}

- (SEL)selectorWithType:(NSString *)type
{
    NSDictionary *dic = @{
                          kCollisionBullet :
                              [NSValue valueWithPointer:@selector(legCollision:bullet:)],
                          kCollisionWood :
                              [NSValue valueWithPointer:@selector(legCollision:bullet:)],
                          kCollisionMetal:
                              [NSValue valueWithPointer:@selector(legCollision:bullet:)],
                          kCollisionStone:
                              [NSValue valueWithPointer:@selector(legCollision:bullet:)],
                          kCollisionDefendNet:
                              [NSValue valueWithPointer:@selector(legCollision:bullet:)],
                          
                          };
    return (SEL)[dic[type] pointerValue];
}


@end
