//
//  ILShooterHalf.h
//  ShootBear
//
//  Created by mac on 13-8-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILShooterArm.h"

@interface ILShooterHalf : CCNode

- (float)totalRotation;

- (void)resetRotation;

@property (retain, nonatomic) ILShooterArm *arm;

@end
