//
//  ILPhysicsSprite.m
//  ShootBear
//
//  Created by mac on 13-8-9.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILPhysicsSprite.h"
#import <objc/message.h>
#import "Box2D.h"

@implementation ILPhysicsSprite


- (void)dealloc
{
    self.imageName = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self scheduleUpdate];
    }
    return self;
}

- (void)update:(ccTime)delta
{
    [self updateB2BodyPosition];
    [self updateB2BodyRotation];
}


- (void)updateB2BodyPosition
{
    if (_b2Body == NULL) {
        return;
    }
    CGPoint taregt = [self.parent convertToWorldSpace:super.position];
    _b2Body->SetTransform( b2Vec2(taregt.x / _PTMRatio, taregt.y / _PTMRatio), _b2Body->GetAngle());

}

- (void)setB2Body:(b2Body *)b2Body
{
    _b2Body = b2Body;
    [self setPosition:super.position];
}

- (void)updateB2BodyRotation
{
    if (_b2Body == NULL) {
        return;
    }
	if(!_ignoreBodyRotation){
		b2Vec2 p = _b2Body->GetPosition();
        
		float radians = -CC_DEGREES_TO_RADIANS([self getTotalRotation]);
		_b2Body->SetTransform(p, radians);
	}
}

- (float)getTotalRotation
{
    CCNode *temp = self;
    float rad = super.rotation;
    while ((temp = temp.parent)) {
        rad += temp.rotation;
    }
    return rad;
}



@end
