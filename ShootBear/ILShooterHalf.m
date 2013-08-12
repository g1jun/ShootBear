//
//  ILShooterHalf.m
//  ShootBear
//
//  Created by mac on 13-8-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILShooterHalf.h"

@implementation ILShooterHalf

- (void)dealloc
{
    self.arm = nil;
    [super dealloc];
}

- (void)resetRotation
{
    self.arm.rotation = 0;
}

- (float)totalRotation
{
    return [self.arm currentDegree];
}


@end
