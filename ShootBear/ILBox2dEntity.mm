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
#import "ILShapeCache.h"
#import <objc/message.h>

@implementation ILBox2dEntity

- (void)setB2Body:(b2Body *)b2Body
{
    [super setB2Body:b2Body];
    CGPoint position = super.position;
    super.b2Body->SetUserData(self);
    [self setPosition:position];
}

- (void)setSpeed:(b2Vec2)speed
{
    if (super.b2Body != NULL) {
        super.b2Body->SetLinearVelocity(speed);
    }
}


-(CGPoint)position
{
    if (super.b2Body == NULL) {
        return CGPointZero;
    }
    b2Vec2 pos  = super.b2Body->GetPosition();
    
    float x = pos.x * super.PTMRatio;
    float y = pos.y * super.PTMRatio;
    return [self.parent convertToNodeSpace:ccp(x, y)];
}

- (void)syncAnchor
{
    self.anchorPoint = [[ILShapeCache sharedShapeCache] anchorPointForShape:self.imageName];
}


-(void)setPosition:(CGPoint)position
{
    [super setPosition:position];
    if (super.b2Body != NULL) {
        float angle = super.b2Body->GetAngle();
        CGPoint worldP = [self.parent convertToWorldSpace:position];
        super.b2Body->SetTransform( b2Vec2(worldP.x / super.PTMRatio, worldP.y / super.PTMRatio), angle );
    }
}

-(float)rotation
{
    if (super.b2Body == NULL) {
        return 0;
    }
    return (super.ignoreBodyRotation ? super.rotation :
                   CC_RADIANS_TO_DEGREES( super.b2Body->GetAngle() ) );
}

-(void)setRotation:(float)rotation
{
    [super setRotation:rotation];
    if(super.ignoreBodyRotation){
		self.rotation = rotation;
	} else if(super.b2Body != NULL) {
		b2Vec2 p = super.b2Body->GetPosition();
		float radians = CC_DEGREES_TO_RADIANS(rotation);
		super.b2Body->SetTransform( p, radians);
	}
}

-(CGAffineTransform) nodeToParentTransform
{
    if (super.b2Body == NULL) {
        return CGAffineTransformIdentity;
    }
    b2Vec2 pos  = super.b2Body->GetPosition();
    CGPoint local = [self.parent convertToNodeSpace:ccp(pos.x * super.PTMRatio, pos.y * super.PTMRatio)];
    float x = local.x;
    float y = local.y;
    if ( _ignoreAnchorPointForPosition ) {
        x += _anchorPointInPoints.x;
        y += _anchorPointInPoints.y;
    }
    float radians = super.b2Body->GetAngle();
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



-(BOOL) dirty
{
	return YES;
}



@end
