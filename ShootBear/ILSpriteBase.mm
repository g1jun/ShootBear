//
//  ILSpriteBase.m
//  ShootBear
//
//  Created by mac on 13-8-17.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILSpriteBase.h"
#import "CCSpriteFrameCache+ILSpriteNameSearch.h"
#import "ILBox2dFactory.h"
#import "ILShapeCache.h"
#import "ILTools.h"

@implementation ILSpriteBase

- (id)init
{
    self = [super init];
    if (self) {
        _isStatic = NO;
    }
    return self;
}

- (void)box2dMode
{
    _mode = Box2dMode;
    [self unscheduleUpdate];
    
}

- (void)animationMode
{
    _mode = AnimationMode;
    [self scheduleUpdate];
}

- (void)dealloc
{
    [ILBox2dFactory sharedFactory].world->DestroyBody(self.b2Body);
    self.imageName = nil;
    _b2Body = NULL;
    [super dealloc];
}

- (void)didLoadFromCCB
{
    b2BodyDef bodyDef;
    bodyDef.type = _isStatic ? b2_staticBody : b2_dynamicBody;
    b2Body *body = [ILBox2dFactory sharedFactory].world->CreateBody(&bodyDef);
    [self setPTMRatio:PIXELS_PER_METER];
    [[ILShapeCache sharedShapeCache] addFixturesToBody:body forPhysicsSprite:self];
    [self setB2Body:body];
}

- (NSString *)collisionType
{
    return kCollisionNothing;
}

- (id)collisionCCNode
{
    return self;
}

- (void)setDisplayFrame:(CCSpriteFrame *)newFrame
{
    [super setDisplayFrame:newFrame];
    NSString *name = [[CCSpriteFrameCache sharedSpriteFrameCache] nameBySpriteFrame:newFrame];
    self.imageName = [name stringByDeletingPathExtension];
}

#pragma - mark mode

- (CGPoint)position
{
    if (_mode == Box2dMode) {
        return [self box2dModePosition];
    }
    return super.position;
}

- (void)setPosition:(CGPoint)position
{
    if (_mode == Box2dMode) {
        [self box2dModeSetPosition:position];
    }
    return [super setPosition:position];;
}


- (void)setRotation:(float)rotation
{
    if (_mode == Box2dMode) {
        [self box2dModeSetRotation:rotation];
    }
    [super setRotation:rotation];
}


- (void)setB2Body:(b2Body *)b2Body
{
    _b2Body = b2Body;
    self.b2Body->SetUserData(self);
    if (_mode == Box2dMode) {
        [self box2dModeSetB2Body:b2Body];
    } else {
        [self animationModeSetB2Body:b2Body];
    }
}

- (CGAffineTransform)nodeToParentTransform
{
    if (_mode == Box2dMode) {
        return [self box2dModeNodeToParentTransform];
    }
    return [super nodeToParentTransform];
}


#pragma -mark Box2dMode

- (void)box2dModeSetB2Body:(b2Body *)b2Body
{
    CGPoint position = super.position;
    [self setPosition:position];
    [self setRotation:super.rotation];
}


-(CGPoint)box2dModePosition
{
    if (self.b2Body == NULL) {
        return CGPointZero;
    }
    b2Vec2 pos  = self.b2Body->GetPosition();
    
    float x = pos.x * self.PTMRatio;
    float y = pos.y * self.PTMRatio;
    return [self.parent convertToNodeSpace:ccp(x, y)];
}

-(void)box2dModeSetPosition:(CGPoint)position
{
    [super setPosition:position];
    if (self.b2Body != NULL) {
        float angle = self.b2Body->GetAngle();
        CGPoint worldP = [self.parent convertToWorldSpace:position];
        self.b2Body->SetTransform( b2Vec2(worldP.x / self.PTMRatio, worldP.y / self.PTMRatio), angle );
    }
}

-(void)box2dModeSetRotation:(float)rotation
{
    [super setRotation:rotation];
    if(self.ignoreBodyRotation){
		return;
	} else if(self.b2Body != NULL) {
		b2Vec2 p = self.b2Body->GetPosition();
        float r = [ILTools rotationTotal:self.parent] + rotation;
		float radians = -CC_DEGREES_TO_RADIANS(r);
		self.b2Body->SetTransform( p, radians);
	}
}

-(CGAffineTransform) box2dModeNodeToParentTransform
{
    if (self.b2Body == NULL) {
        return CGAffineTransformIdentity;
    }
    b2Vec2 pos  = self.b2Body->GetPosition();
    CGPoint local = [self.parent convertToNodeSpace:ccp(pos.x * self.PTMRatio, pos.y * self.PTMRatio)];
    float x = local.x;
    float y = local.y;
    if ( _ignoreAnchorPointForPosition ) {
        x += _anchorPointInPoints.x;
        y += _anchorPointInPoints.y;
    }
    float degree = [ILTools rotationTotal:self.parent];
    float pRadians = CC_DEGREES_TO_RADIANS(degree);
    float radians = (self.b2Body->GetAngle() + pRadians);
    //    float radians = CC_DEGREES_TO_RADIANS(super.rotation);
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


#pragma -mark AnimationMode

- (void)update:(ccTime)delta
{
    [self updateB2BodyPosition];
    [self updateB2BodyRotation];
}


- (void)updateB2BodyPosition
{
    if (self.b2Body == NULL) {
        return;
    }
    CGPoint taregt = [self.parent convertToWorldSpace:super.position];
    self.b2Body->SetTransform( b2Vec2(taregt.x / self.PTMRatio, taregt.y / self.PTMRatio), self.b2Body->GetAngle());
    
}

- (void)animationModeSetB2Body:(b2Body *)b2Body
{
    self.b2Body->SetGravityScale(0);
}

- (void)updateB2BodyRotation
{
    if (self.b2Body == NULL) {
        return;
    }
	if(!self.ignoreBodyRotation){
		b2Vec2 p = self.b2Body->GetPosition();
        
		float radians = -CC_DEGREES_TO_RADIANS([self getTotalRotation]);
		self.b2Body->SetTransform(p, radians);
	}
}

- (float)getTotalRotation
{
    return [ILTools rotationTotal:self];
}


@end
