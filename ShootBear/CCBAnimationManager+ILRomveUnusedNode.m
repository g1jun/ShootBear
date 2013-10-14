//
//  CCBAnimationManager+ILRomveUnusedNode.m
//  BearHunter
//
//  Created by mac on 13-10-14.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCBAnimationManager+ILRomveUnusedNode.h"

@implementation CCBAnimationManager (ILRomveUnusedNode)

- (void)removeUnusedNode:(id)node
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
