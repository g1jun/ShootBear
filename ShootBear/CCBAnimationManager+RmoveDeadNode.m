//
//  CCBAnimationManager+RmoveDeadNode.m
//  ShootBear
//
//  Created by mac on 13-8-20.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCBAnimationManager+RmoveDeadNode.h"

@implementation CCBAnimationManager (RmoveDeadNode)

- (void)removeDeadNode:(id)node
{
    NSValue *temp = nil;
    for (NSValue *ptr in nodeSequences) {
        id tempNode = (id)[ptr pointerValue];
        if (tempNode == node) {
            temp = ptr;
        }
    }
    if (temp) {
        [nodeSequences removeObjectForKey:temp];
    }
}

@end
