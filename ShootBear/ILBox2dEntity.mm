//
//  ILBullet.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-14.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBox2dEntity.h"
#import "Box2D.h"
#import "ILTools.h"
#import "ILShapeCache.h"
#import <objc/message.h>

@implementation ILBox2dEntity


- (id)init
{
    self = [super init];
    if (self) {
        [self box2dMode];
    }
    return self;
}

- (void)setSpeed:(b2Vec2)speed
{
    if (super.b2Body != NULL) {
        super.b2Body->SetLinearVelocity(speed);
    }
}
- (void)syncAnchor
{
    self.anchorPoint = [[ILShapeCache sharedShapeCache] anchorPointForShape:self.imageName];
}


@end
