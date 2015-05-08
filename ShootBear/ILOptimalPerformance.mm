//
//  ILOptimalPerformance.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-13.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILOptimalPerformance.h"
#import "ILTools.h"
#import "ILBox2dEntity.h"
#import "ILMetal.h"

@implementation ILOptimalPerformance

- (id)initWithCCNode:(CCNode *)node
{
    self = [super init];
    if (self) {
        _electricBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"element.png"];
        _dic = [[NSMutableDictionary dictionary] retain];
        _node = node;
        [_node addChild:_electricBatchNode];

        
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
//    for (NSString *key in _dic) {
        NSString *key = @"element.png";
        CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:key];
        for (CCSprite *sprite in _dic[key]) {
            [sprite removeFromParent];
            if ([sprite isKindOfClass:[ILMetal class]] && [key isEqualToString:@"element.png"] && [(ILMetal *)sprite hasElctric]) {
                [_electricBatchNode addChild:sprite];
            } else {
                [batchNode addChild:sprite];
            }
        }
        [batchNodes addObject:batchNode];
//    }
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
