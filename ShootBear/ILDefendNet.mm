//
//  ILDefendNet.m
//  ShootBear
//
//  Created by mac on 13-9-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILDefendNet.h"
#import "ILBox2dTools.h"
#import "ILShapeCache.h"
#import "ILBox2dFactory.h"
#import "ILTools.h"
#import "ILLightning.h"

@implementation ILDefendNet

- (id)init
{
    self = [super init];
    if (self) {
        _isLeft =NO;
        [self box2dMode];
    }
    return self;
}

- (void)changeState
{
    if (_isLeft != !self.flipX) {
        self.flipX = !_isLeft;
        [self updateB2body];
    }
}

- (void)updateB2body
{
    b2Body *body = self.b2Body;
    [self configBody];
    [ILBox2dFactory sharedFactory].world->DestroyBody(body);
    [ILBox2dTools changeCategoryBit:self bit:1 << 2];
    
}

- (void)elctricEffect
{
    [[self layer] addStencil:self];
}

- (void)leftAnchor
{
    [self animationMode];
    _isLeft = YES;
    self.anchorPoint = ccp(0.2, self.anchorPoint.y);
    self.position = CGPointZero;
}

- (void)rightAnchor
{
    [self animationMode];
    _isLeft = NO;
    self.position = CGPointZero;
    self.anchorPoint = ccp(0.8, self.anchorPoint.y);


}

- (void)onExit
{
    [super onExit];
    [[self layer] removeStencil:self];
}

- (NSString *)collisionType
{
    return kCollisionDefendNet;
}

- (void)update:(ccTime)delta
{
    [super update:delta];
    [self changeState];
    if (!self.visible) {
        [[self layer] removeStencil:self];
    }
}


@end
