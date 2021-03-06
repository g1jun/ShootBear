//
//  ILLevelCompletedLayer.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-29.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILTouchStopLayer.h"

@implementation ILTouchStopLayer

- (id)init
{
    self = [super init];
    if (self) {
        [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:2 swallowsTouches:YES];
    }
    return self;
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
    if (!self.visible || !CGRectContainsPoint(self.boundingBox, touchPoint)) {
        return NO;
    }
    return YES;
}


@end
