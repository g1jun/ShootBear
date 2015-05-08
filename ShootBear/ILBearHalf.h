//
//  ILBearHalf.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILBearArmOutter.h"
//todo ccnode
@interface ILBearHalf : CCSprite
{
    CCSpriteBatchNode *_batch;

}

@property (assign, nonatomic) ILBearArmOutter *armOutter;

@end
