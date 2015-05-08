//
//  ILCannonIndicator.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-16.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILCannonIndicator.h"

@implementation ILCannonIndicator

- (void)didLoadFromCCB
{
    _array = [[NSMutableArray array] retain];
    for (id ch in self.children) {
        [_array addObject:ch];
    }
//    [self hideAll];
}

- (float)cannonSpeed
{
    return _speed;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.visible) {
        [self touchDealWith:touch];

        return YES;
    }
    return NO;
}

- (void)touchDealWith:(UITouch *)touch
{
    CGPoint nodePosition = [self convertTouchToNodeSpace:touch];
    float dis = ccpLength(nodePosition);
    [self showGrade:dis];
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    [self touchDealWith:touch];
    
}

- (void)showGrade:(float)dis
{
     float grade = dis / 25;
    if (grade > _array.count - 1) {
        grade = _array.count - 0.1;
    }
    _speed = (grade + 1) * 2.5;
    int show = grade;
    [self hideAll];
    for (int i = 0; i <= show; i++) {
        [_array[i] setVisible:YES];
    }
}

- (void)onEnter
{
    [super onEnter];
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:9 swallowsTouches:NO];
}

- (void)onExit
{
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
    [super onExit];
}

- (void)hideAll
{
    for (id ch in _array) {
        [ch setVisible:NO];
    }
}

- (void)dealloc
{
    [_array release];
    [super dealloc];
}

@end
