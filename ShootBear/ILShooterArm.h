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

@interface ILShooterArm : CCNode <CCTouchOneByOneDelegate>
{
    CCNode *_touchRotation;
}

- (void)pressedButton:(id)sender event:(CCControlEvent)event;

@end
