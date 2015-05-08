//
//  ILShooterHalf.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILShooterArm.h"
//ccnode
@interface ILShooterHalf : ILSprite

- (float)totalRotation;

- (void)resetRotation;

- (void)replaceGunType:(NSString * )type;

- (CGPoint)firePointGL;

@property (assign, nonatomic) ILShooterArm *arm;

@property (copy, nonatomic) NSString *gunType;

@end
