//
//  ILBear.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-15.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBear.h"
#import "CCBAnimationManager.h"
#import "ILBox2dTools.h"
#import "ILBox2dFactory.h"
#import "ILTools.h"

@implementation ILBear



- (void)didLoadFromCCB
{
    _leftBear.visible = NO;
    _rightBear.visible = NO;
    [self parseRule];
    _previousX = self.position.x;
    [self scheduleUpdate];
}



- (void)parseRule
{
    NSArray *states = [_animationRule componentsSeparatedByString:@";"];
    [self parseRule:states[0]];
    if (states.count > 1) {
        [self configEndRule];
    }
}


- (void)configEndRule
{
    CCBAnimationManager *manager = _rightBear.userObject;
    __block typeof(self) bself = self;
    [manager setCompletedAnimationCallbackBlock:^(id sender) {
        NSArray *states = [bself.animationRule componentsSeparatedByString:@";"];
        [bself parseRule:states[1]];
    }];
}


- (void)parseRule:(NSString *)state
{
    NSArray *rules = [state componentsSeparatedByString:@":"];
    NSArray *states = [rules[1] componentsSeparatedByString:@"."];
    SEL selector = (SEL)[[self stateSEL][states[0]] pointerValue];
    [self performSelector:selector];
    SEL turnSEL = (SEL)[[self turnTowardSEL][states[1]] pointerValue];
    float delay = CCRANDOM_0_1() / 2;
    [self performSelector:turnSEL withObject:nil afterDelay:delay];
}

- (void)staticState
{
    _leftTowardAnimationName  = @"static";
    _rightTowardAnimationName = @"static";
}

- (void)dynamicState
{
    _leftTowardAnimationName  = @"dynamic";
    _rightTowardAnimationName = @"dynamic";
}



- (NSDictionary *)stateSEL
{
    return @{@"static": [NSValue valueWithPointer:@selector(staticState)],
      @"dynamic":[NSValue valueWithPointer:@selector(dynamicState)]};
}

- (NSDictionary *)turnTowardSEL
{
    return @{@"left":[NSValue valueWithPointer:@selector(turnLeft)],
        @"right":[NSValue valueWithPointer:@selector(turnRight)]};
}


- (void)turnRight
{
    if (_rightBear.visible) {
        return;
    }
    [ILBox2dTools  changeCategoryBit:_rightBear bit:1 << 1];
    [ILBox2dTools changeCategoryBit:_leftBear bit:1 << 15];
    _rightBear.visible = YES;
    _leftBear.visible = NO;
    [self runAnimation];
}

- (void)dead
{
    [ILBox2dTools changeCategoryBit:_leftBear bit:1 << 15];
    [ILBox2dTools changeCategoryBit:_rightBear bit:1 << 15];
}

- (void)turnLeft
{
    if (_leftBear.visible) {
        return;
    }
    _rightBear.visible = NO;
    _leftBear.visible = YES;
    [ILBox2dTools changeCategoryBit:_leftBear bit:1 << 1];
    [ILBox2dTools changeCategoryBit:_rightBear bit:1 << 15];
    [self runAnimation];
}

- (void)runAnimation
{
    CCBAnimationManager *rightManager = _rightBear.userObject;
    [rightManager runAnimationsForSequenceNamed:_rightTowardAnimationName];
    CCBAnimationManager *leftManager = _leftBear.userObject;
    [leftManager runAnimationsForSequenceNamed:_rightTowardAnimationName];
}

- (CGPoint)explisionPosition
{
    return [_explisionNode.parent convertToWorldSpace:_explisionNode.position];
}



- (void)autoTurn
{
    if (self.position.x - _previousX > 0.0001) {
        [self turnRight];
    } else if(_previousX - self.position.x   > 0.0001) {
        [self turnLeft];
    }
    _previousX = self.position.x;
}

- (void)update:(ccTime)delta
{
    [self autoTurn];
    [self autoShowThing];
}


- (CCNode *)pickUp:(CCNode *)node
{
    if (_thing) {
        [_thing release];
    }
    _thing = (ILDefendNet *)[node retain];
    [node removeFromParent];
    [node.userObject removeUnusedNode:node];
    return node;
}

- (void)autoShowThing
{
    if (_thing == nil) {
        return;
    }
    if (_thing.parent && _thing.isLeft == _rightBear.visible) {
        return;
    }
    [_thing removeFromParent];
    if (_rightBear.visible) {
        [_thing leftAnchor];
        float degree = [ILTools rotationTotal:_rightBear.armOutter.palm ];
        _thing.rotation = -degree;
        [_rightBear.armOutter.palm addChild:_thing z:-1];
    }  else {
        float degree = [ILTools rotationTotal:_leftBear.armOutter.palm];
        _thing.rotation = -degree;
        [_thing rightAnchor];
        [_leftBear.armOutter.palm addChild:_thing z:-1];
    }
}

- (CGPoint)footPosition
{
    return [_footNode.parent convertToWorldSpace:_footNode.position];
}

- (void)dealloc
{
    [_thing release];
    [self unscheduleUpdate];
    self.animationRule = nil;
    self.levelState = nil;
    [super dealloc];
}

@end
