//
//  ILOptimalPerformance.h
//  ShootBear
//
//  Created by mac on 13-9-13.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILOptimalPerformance : NSObject
{
    @private
    NSMutableDictionary *_dic;
    CCNode *_node;
}

- (id)initWithCCNode:(CCNode *)node;

- (void)executeOptimized;

@end
