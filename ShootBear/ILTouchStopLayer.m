//
//  ILLevelCompletedLayer.m
//  ShootBear
//
//  Created by mac on 13-8-29.
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
    if (!self.visible) {
        return NO;
    }
    return YES;
}


@end
