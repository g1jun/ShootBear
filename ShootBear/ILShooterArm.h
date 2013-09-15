//
//  ILShooterArm.h
//  ShootBear
//
//  Created by mac on 13-8-10.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "CCTouchDelegateProtocol.h"
#import "CCControlExtension.h"
#import "ILGun.h"

//ccnode
@interface ILShooterArm : ILSprite <CCTouchOneByOneDelegate>
{
    BOOL _isCannon;
}

@property (assign, nonatomic) ILGun *gun;

- (float)currentDegree;

- (void)replaceGunType:(NSString * )type;

- (void)stopAccpetTouch;

- (void)setAllRotation:(float)rotation;

- (CGPoint)rotationCenterPosition;


@end
