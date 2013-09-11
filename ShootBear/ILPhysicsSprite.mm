//
//  ILPhysicsSprite.m
//  ShootBear
//
//  Created by mac on 13-8-9.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILPhysicsSprite.h"
#import "Box2D.h"
#import "ILTools.h"

@implementation ILPhysicsSprite

- (id)init
{
    self = [super init];
    if (self) {
        [self animationMode];
    }
    return self;
}


//- (id)init
//{
//    self = [super init];
//    if (self) {
//        [self scheduleUpdate];
//    }
//    return self;
//}
//
//- (void)update:(ccTime)delta
//{
//    [self updateB2BodyPosition];
//    [self updateB2BodyRotation];
//}
//
//
//- (void)updateB2BodyPosition
//{
//    if (super.b2Body == NULL) {
//        return;
//    }
//    CGPoint taregt = [self.parent convertToWorldSpace:super.position];
//    super.b2Body->SetTransform( b2Vec2(taregt.x / super.PTMRatio, taregt.y / super.PTMRatio), super.b2Body->GetAngle());
//
//}
//
//- (void)setB2Body:(b2Body *)b2Body
//{
//    super.b2Body = b2Body;
//    super.b2Body->SetUserData(self);
//    super.b2Body->SetGravityScale(0);
//}
//
//- (void)updateB2BodyRotation
//{
//    if (super.b2Body == NULL) {
//        return;
//    }
//	if(!super.ignoreBodyRotation){
//		b2Vec2 p = super.b2Body->GetPosition();
//        
//		float radians = -CC_DEGREES_TO_RADIANS([self getTotalRotation]);
//		super.b2Body->SetTransform(p, radians);
//	}
//}
//
//- (float)getTotalRotation
//{
//    return [ILTools rotationTotal:self];
//}


@end
