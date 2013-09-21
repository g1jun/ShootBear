//
//  ILBearBase.m
//  ShootBear
//
//  Created by mac on 13-8-15.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILPhysicsBearBase.h"
#import "ILBear.h"
#import "ILBearCollisionDelegate.h"
#import "ILBox2dTools.h"
#import "ILDefendNet.h"

@implementation ILPhysicsBearBase

- (id)collisionCCNode
{
    CCNode *temp = self;
    do {
        if ([temp isKindOfClass:[ILBear class]]) {
            return temp;
        }
    } while ((temp = temp.parent));
    return nil;
}

- (void)animationMode
{
    if (self.b2Body) {
        self.b2Body->SetType(b2_dynamicBody);
    }
    self.isStatic = NO;
    self.mode = AnimationMode;
    [self scheduleUpdate];
}

- (ILCollisionParameter *)collisionResponse:(id<ILCollisionDelegate>)another
{
    if ([[another collisionType] isEqualToString:kCollisionDefendNet]) {
        ILDefendNet *net = [another collisionCCNode];
        if (!net.hasElctric) {
            ILBear *bear = [self collisionCCNode];
            [bear pickUp:net];
            [ILBox2dTools changeCategoryBit:net bit:1 << 2];
            return nil;
        }
    }
//    } else if ([[another collisionType] isEqual:kCollisionBullet]) {
//        ILBulletBase *base = (ILBulletBase *)[another collisionCCNode];
//        if ([[base bulletType] isEqual:kCannonBullet]) {
//            return nil;
//        }
//    }
    ILCollisionParameter *param = [ILCollisionParameter new];
    param.delegateKey = kILBearCollisionDelegate;
    param.selector = [self selectorWithType:[another collisionType]];
    param.meReference = [self collisionCCNode];
    param.anotherReference = [another collisionCCNode];
    return [param autorelease];
}

@end
