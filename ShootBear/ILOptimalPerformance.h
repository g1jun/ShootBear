//
//  ILOptimalPerformance.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-13.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILOptimalPerformance : NSObject
{
    @private
    NSMutableDictionary *_dic;
    CCNode *_node;
}

@property(retain, nonatomic)CCSpriteBatchNode *electricBatchNode;

- (id)initWithCCNode:(CCNode *)node;

- (void)executeOptimized;

@end
