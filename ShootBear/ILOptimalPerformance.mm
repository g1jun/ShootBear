//
//  ILOptimalPerformance.m
//  ShootBear
//
//  Created by mac on 13-9-13.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILOptimalPerformance.h"
#import "ILTools.h"
#import "ILBox2dEntity.h"

@implementation ILOptimalPerformance

- (id)initWithCCNode:(CCNode *)node
{
    self = [super init];
    if (self) {
        _dic = [[NSMutableDictionary dictionary] retain];
        _node = node;
        
    }
    return self;
}

- (void)dealloc
{
    [_dic release];
    [super dealloc];
}

- (void)executeOptimized
{
    NSMutableArray *batchNodes = [NSMutableArray array];
    [self classified:_node];
    for (NSString *key in _dic) {
        CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:key];
        for (CCSprite *sprite in _dic[key]) {
            [sprite removeFromParent];
            [batchNode addChild:sprite];
        }
        [batchNodes addObject:batchNode];
    }
    for (CCSpriteBatchNode * ch in batchNodes) {
        ch.position = CGPointZero;
        ch.anchorPoint = CGPointZero;
        [_node addChild:ch z:-100];
    }

}

- (void)classifiedSprite:(CCNode *)node fileName:(NSString *)fileName
{
    NSMutableArray *tempArray = _dic[fileName];
    if (tempArray == nil) {
        NSMutableArray *newArray = [NSMutableArray array];
        tempArray = newArray;
        _dic[fileName] = newArray;
    }
    [tempArray addObject:node];
}

- (void)classified:(CCNode *)node
{
    for (id ch in node.children) {
        if ([ch isKindOfClass:[ILBox2dEntity class]] &&  [ch pngFileName]) {
            NSString *pngName = [ch pngFileName];
            [self classifiedSprite:ch fileName:pngName];
        }
        [self classified:ch];
    }
}

@end
