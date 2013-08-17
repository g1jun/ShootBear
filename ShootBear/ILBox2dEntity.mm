//
//  ILBullet.m
//  ShootBear
//
//  Created by mac on 13-8-14.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBox2dEntity.h"
#import "Box2D.h"
#import "ILTools.h"
#import <objc/message.h>

@implementation ILBox2dEntity

- (void)setB2Body:(b2Body *)b2Body
{
    _b2Body = b2Body;
    b2Body->SetGravityScale(0);
    struct objc_super sp;
    sp.receiver = self;
    sp.super_class = [CCNode class];
    id ret = objc_msgSendSuper(&sp, @selector(position), nil);
    CGPoint position = *((CGPoint *)(&ret));
    b2Body->SetUserData(self);
    [self setPosition:position];
}

- (void)setSpeed:(b2Vec2)speed
{
    if (self.b2Body != NULL) {
        self.b2Body->SetLinearVelocity(speed);
    }
}


-(CGPoint)position
{
    if (self.b2Body == NULL) {
        return CGPointZero;
    }
    b2Vec2 pos  = self.b2Body->GetPosition();
    
    float x = pos.x * self.PTMRatio;
    float y = pos.y * self.PTMRatio;
    return [self.parent convertToNodeSpace:ccp(x, y)];
}



-(void)setPosition:(CGPoint)position
{
    if (self.b2Body != NULL) {
        	float angle = _b2Body->GetAngle();
            CGPoint worldP = [self.parent convertToWorldSpace:position];
        	self.b2Body->SetTransform( b2Vec2(worldP.x / _PTMRatio, worldP.y / _PTMRatio), angle );
    }
}

-(float)rotation
{
    if (self.b2Body == NULL) {
        return 0;
    }
    return (_ignoreBodyRotation ? super.rotation :
                   CC_RADIANS_TO_DEGREES( _b2Body->GetAngle() ) );
}

-(void)setRotation:(float)rotation
{
    if (self.b2Body == NULL) {
        return;
    }
    if(_ignoreBodyRotation){
		self.rotation = rotation;
	} else {
		b2Vec2 p = _b2Body->GetPosition();
		float radians = CC_DEGREES_TO_RADIANS(rotation);
		_b2Body->SetTransform( p, radians);
	}
}

-(CGAffineTransform) nodeToParentTransform
{
    if (self.b2Body == NULL) {
        return CGAffineTransformIdentity;
    }
    b2Vec2 pos  = _b2Body->GetPosition();
    CGPoint local = [self.parent convertToNodeSpace:ccp(pos.x * _PTMRatio, pos.y * _PTMRatio)];
    float x = local.x;
    float y = local.y;
    if ( _ignoreAnchorPointForPosition ) {
        x += _anchorPointInPoints.x;
        y += _anchorPointInPoints.y;
    }
    float radians = _b2Body->GetAngle();
    float c = cosf(radians);
    float s = sinf(radians);
    if( ! CGPointEqualToPoint(_anchorPointInPoints, CGPointZero) ){
        x += c*-_anchorPointInPoints.x * _scaleX + -s*-_anchorPointInPoints.y * _scaleY;
        y += s*-_anchorPointInPoints.x * _scaleX + c*-_anchorPointInPoints.y * _scaleY;
    }
    _transform = CGAffineTransformMake( c * _scaleX, s * _scaleX,
                                           -s * _scaleY, c * _scaleY,
                                           x, y );
    return _transform;
}

- (NSString *)collisionType
{
    return kCollisionNothing;
}

- (id)collisionCCNode
{
    return self;
}

-(BOOL) dirty
{
	return YES;
}



@end
