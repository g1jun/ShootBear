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

- (ILCollisionParameter *)collisionResponse:(id<ILCollisionDelegate>)another
{
    ILCollisionParameter *param = [ILCollisionParameter new];
    param.delegateKey = kILBearCollisionDelegate;
    param.selector = [self selectorWithType:[another collisionType]];
    param.meReference = [self collisionCCNode];
    param.anotherReference = [another collisionCCNode];
    return [param autorelease];
}

@end
