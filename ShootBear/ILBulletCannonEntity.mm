//
//  ILBulletCannonEntity.m
//  ShootBear
//
//  Created by mac on 13-9-17.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBulletCannonEntity.h"
#import "ILBulletBase.h"

@implementation ILBulletCannonEntity

- (void)collisionDealWith:(id<ILCollisionDelegate>)another
{
    if ([another isKindOfClass:[ILSpriteBase class]]) {
        ILSpriteBase *base = (ILSpriteBase *)another;
        if(!base.isStatic) {
            ILBulletBase *p = (ILBulletBase *)self.parent;
            [p lifeStart];
        }
    }

}

- (void)setB2Body:(b2Body *)b2Body
{
    [super setB2Body:b2Body];
    b2Body->SetBullet(YES);
}

@end
