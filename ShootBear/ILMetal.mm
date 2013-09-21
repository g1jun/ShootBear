//
//  ILMetal.m
//  ShootBear
//
//  Created by mac on 13-8-25.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILMetal.h"
#import "CCBReader.h"
#import "ILQueryTool.h"
#import "CCBAnimationManager.h"
#import "ILBullet.h"
#import "ILLevelLayer.h"
#import "ILBox2dTools.h"

class MetalQueryCallback : public b2QueryCallback
{
    bool ReportFixture(b2Fixture* fixture) {
        id node = (id)fixture->GetBody()->GetUserData();
        if ([node isKindOfClass:[ILMetal class]]) {
            [node conductElectricity];
        }
        return YES;
    }
};

@implementation ILMetal

- (NSString *)collisionType
{
    return kCollisionMetal;
}

- (void)didFromCCB
{
    if (_hasElctric) {
        [self electricity];
    }
}

- (void)onEnter
{
    [super onEnter];
}

- (BOOL)isElectriBullet:(id)another
{
    return [[another collisionType]isEqualToString:kCollisionBullet] &&
    [[[another collisionCCNode] bulletType] isEqualToString:kElectriGunBullet];
}

- (BOOL)isEcectricMetal:(id)another
{
    return [[another collisionType] isEqualToString:kCollisionMetal] && [[another collisionCCNode] hasElctric];
}

- (void)collisionDealWith:(id<ILCollisionDelegate>)another
{
    if ([self isElectriBullet:another] || [self isEcectricMetal:another]) {
        [self conductElectricity];
    }
}

- (void)conductElectricity
{
    if (self.hasElctric) {
        return;
    }
    [self electricity];
}

- (void)electricity
{
    self.hasElctric = YES;
    [ILBox2dTools changeCategoryBit:self bit:1 << 3];
    [self elctricEffect];
    [self conductAround];
}



- (ILLevelLayer *)layer
{
    CCNode *temp = self;
    while (temp.parent) {
        temp = temp.parent;
        if ([temp isKindOfClass:[ILLevelLayer class]]) {
            return (ILLevelLayer *)temp;
        }
    }
    return nil;
}

- (void)elctricEffect
{
    [[self layer] switchMetalParent:self];
}




- (void)conductAround
{
    MetalQueryCallback callback;
    [ILQueryTool queryAround:self callback:&callback];
}

@end
