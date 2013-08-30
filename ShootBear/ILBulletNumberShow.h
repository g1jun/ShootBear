//
//  ILBulletNumberShow.h
//  ShootBear
//
//  Created by mac on 13-8-30.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILBulletShowUnit.h"

@interface ILBulletNumberShow : CCNode
{
    ILBulletShowUnit *_first;
    ILBulletShowUnit *_second;
    NSMutableArray *_bulletArray;
}


@property(assign, nonatomic) int bulletNumber;

- (void)reduceBullet;

@end
