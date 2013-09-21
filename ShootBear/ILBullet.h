//
//  ILBullet.h
//  ShootBear
//
//  Created by mac on 13-8-14.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILBox2dEntity.h"
#import "ILBulletBase.h"



@interface ILBullet : ILBulletBase 
{
    float _speed;
    CCParticleSystemQuad* _particle;

}







@end
