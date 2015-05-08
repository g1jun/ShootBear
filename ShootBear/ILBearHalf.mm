//
//  ILBearHalf.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBearHalf.h"

@implementation ILBearHalf

- (id)init
{
    self = [super init];
    if (self ) {
        _batch= [CCSpriteBatchNode batchNodeWithFile:@"bear.png"];
        [super addChild:_batch];
    }
    return self;
}

- (void)addChild:(CCNode *)node
{
    if ([node isKindOfClass:[ILBearArmOutter class]]) {
        [super addChild:node];
        return;
    }
//    CCSprite *sprite = (CCSprite *)node;
//    [sprite setTexture:_batchNode.textureAtlas.texture];
    [_batch addChild:node];
}

@end
