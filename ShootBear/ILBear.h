//
//  ILBear.h
//  ShootBear
//
//  Created by mac on 13-8-15.
//  Copyright (c) 2013年 mac. All rights reserved.
//

/*
 命令格式：
熊有两个状态 ：
 一、static:静止不动
 二、dynamic运动状态
 (1)normal:正常走路
 (2)scare：倒退走路
 
 三、开始状态：start:
 四、结束状态end:可以为上面两种状态的任意一种
 示例：
 
 1、静止static
 left
 right
 
 2、动态：dynamic
 normal
 scare
 
 3、
 开始状态：
 start:static.left
 start:dynamic.left(left=normal,right=scare)
 start:dynamic.left   //default all is normal
 
 3、结束：
 end:static.left
 end:dynamic.right
 
 示例：
 start:static.left;end:dynamic.right
 */

#import "CCNode.h"
#import "ILBearHalf.h"
#import "ILDefendNet.h"

@class ILDefendNet;
@interface ILBear : CCNode
{
    ILBearHalf *_leftBear;
    ILBearHalf *_rightBear;
    NSString *_leftTowardAnimationName;
    NSString *_rightTowardAnimationName;
    float _previousX;
    CCNode *_explisionNode;
    CCNode *_footNode;
     ILDefendNet* _thing;
    BOOL _thingUpdate;
}

@property (copy, nonatomic)NSString *animationRule;
@property (copy, nonatomic)NSString *levelState;

- (CGPoint)explisionPosition;
- (CGPoint)footPosition;

- (void)dead;

- (CCNode *)pickUp:(CCNode *)node;

@end
