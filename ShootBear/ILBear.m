//
//  ILBear.m
//  ShootBear
//
//  Created by mac on 13-8-15.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBear.h"
#import "CCBAnimationManager.h"


@implementation ILBear
- (void)didLoadFromCCB
{
    _leftBear.visible = NO;
    _rightBear.visible = NO;
    [self parseRule];
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
    [manager setCompletedAnimationCallbackBlock:^(id sender) {
        NSArray *states = [_animationRule componentsSeparatedByString:@";"];
        [self parseRule:states[1]];
    }];
}


- (void)parseRule:(NSString *)state
{
    NSArray *rules = [state componentsSeparatedByString:@":"];
    NSArray *states = [rules[1] componentsSeparatedByString:@"."];
    SEL selector = [[self stateSEL][states[0]] pointerValue];
    [self performSelector:selector];
    SEL turnSEL = [[self turnTowardSEL][states[1]] pointerValue];
    float delay = CCRANDOM_0_1();
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
    _rightBear.visible = YES;
    _leftBear.visible = NO;
    [self runAnimation];
}

- (void)runAnimation
{
    CCBAnimationManager *rightManager = _rightBear.userObject;
    [rightManager runAnimationsForSequenceNamed:_rightTowardAnimationName];
    CCBAnimationManager *leftManager = _leftBear.userObject;
    [leftManager runAnimationsForSequenceNamed:_rightTowardAnimationName];
}

- (void)turnLeft
{
    _rightBear.visible = NO;
    _leftBear.visible = YES;
    [self runAnimation];
}

@end
