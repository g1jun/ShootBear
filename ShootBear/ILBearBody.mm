//
//  ILBearBody.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-15.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBearBody.h"
#import "ILBearCollisionDelegate.h"

@implementation ILBearBody

- (NSString *)collisionType
{
    return kCollisionBearBody;
}

- (SEL)selectorWithType:(NSString *)type
{
    NSDictionary *dic = @{
                          kCollisionBullet :
                              [NSValue valueWithPointer:@selector(bodyCollision:bullet:)],
                          kCollisionWood :
                              [NSValue valueWithPointer:@selector(bodyCollision:bullet:)],
                          kCollisionMetal :
                              [NSValue valueWithPointer:@selector(bodyCollision:bullet:)],
                          kCollisionStone:
                              [NSValue valueWithPointer:@selector(bodyCollision:bullet:)],
                          kCollisionDefendNet:
                              [NSValue valueWithPointer:@selector(bodyCollision:bullet:)],
                          
                          };
    return (SEL)[dic[type] pointerValue];
}


@end
