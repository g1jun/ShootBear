//
//  ILShooter.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-8.
//  Copyright 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ILShooterHalf.h"


@interface ILShooter : CCNode {
    
    ILShooterHalf *_leftShooter;
    ILShooterHalf *_rightShooter;
    CCSpriteBatchNode *_batchNode;
    int _shooterRotation;
    BOOL _updateGun;
    
}

- (void)replaceGunType:(NSString * )type;

- (void)fire;

@end
