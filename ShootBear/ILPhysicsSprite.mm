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

//-(CGPoint)position
//{
//    if (super.b2Body == NULL) {
//        return [self superCCSpritePosition];
//    }
//     return [super position];
//    
//}
//
//-(void)setPosition:(CGPoint)position
//{
//    if (super.b2Body == NULL) {
//        [self callCCSpriteMethod:@selector(setPosition:) withCGPoint:position];
//        return;
//    }
//    [super setPosition:position];
//}
//
//- (CGPoint) superCCSpritePosition
//{
//    id superValue = [self callCCSpriteMethod:@selector(position)];
//    CGPoint ret = *(CGPoint *)(&superValue);
//    return ret;
//}
//
//-(float)rotation
//{
//    if (super.b2Body == NULL) {
//        id ret = [self callCCSpriteMethod:@selector(rotation)];
//       return *(float *)(&ret) ;
//    }
//    return [super rotation];
//}
//
//- (void) setB2Body:(b2Body *)b2Body
//{
//    [super setB2Body:b2Body];
//    [self setPosition:[self superCCSpritePosition]];
//}
//
//-(void)setRotation:(float)rotation
//{
//    if (super.b2Body == NULL) {
//        [self callCCSpriteMethod:@selector(setRotation:) withFlost:rotation];
//        return;
//    }
//    [super setRotation:rotation];
//}
//
////- (id)callCCSpriteMethod:(SEL) selector, ...
////{
////    va_list argList;
////    struct objc_super sp;
////    sp.receiver = self;
////    sp.super_class = [CCSprite class];
////    va_start(argList, selector);
////    id ret = objc_msgSendSuper(&sp, selector, argList, nil);
////    va_end(argList);
////    return ret;
////}
//
//- (id)callCCSpriteMethod:(SEL)sel
//{
//    struct objc_super sp = [self getSuperObj];
//    id ret = objc_msgSendSuper(&sp, sel, nil);
//    return ret;
//}
//
//- (struct objc_super) getSuperObj
//{
//    struct objc_super sp;
//    sp.receiver = self;
//    sp.super_class = [CCSprite class];
//    return sp;
//}
//
//- (id)callCCSpriteMethod:(SEL)sel withCGPoint:(CGPoint)parma
//{
//    struct objc_super sp = [self getSuperObj];
//    id ret = objc_msgSendSuper(&sp, sel, parma, nil);
//    return ret;
//}
//
//- (id)callCCSpriteMethod:(SEL)sel withFlost:(float)param
//{
//    struct objc_super sp = [self getSuperObj];
//    id ret = objc_msgSendSuper(&sp, sel, param, nil);
//    return ret;
//}
//
//-(CGAffineTransform) nodeToParentTransform
//{
//   
//    if (super.b2Body == NULL) {
//        if ( _isTransformDirty ) {
//            
//            // Translate values
//            float x = _position.x;
//            float y = _position.y;
//            
//            if ( _ignoreAnchorPointForPosition ) {
//                x += _anchorPointInPoints.x;
//                y += _anchorPointInPoints.y;
//            }
//            
//            // Rotation values
//            // Change rotation code to handle X and Y
//            // If we skew with the exact same value for both x and y then we're simply just rotating
//            float cx = 1, sx = 0, cy = 1, sy = 0;
//            if( _rotationX || _rotationY ) {
//                float radiansX = -CC_DEGREES_TO_RADIANS(_rotationX);
//                float radiansY = -CC_DEGREES_TO_RADIANS(_rotationY);
//                cx = cosf(radiansX);
//                sx = sinf(radiansX);
//                cy = cosf(radiansY);
//                sy = sinf(radiansY);
//            }
//            
//            BOOL needsSkewMatrix = ( _skewX || _skewY );
//            
//            // optimization:
//            // inline anchor point calculation if skew is not needed
//            // Adjusted transform calculation for rotational skew
//            if( !needsSkewMatrix && !CGPointEqualToPoint(_anchorPointInPoints, CGPointZero) ) {
//                x += cy * -_anchorPointInPoints.x * _scaleX + -sx * -_anchorPointInPoints.y * _scaleY;
//                y += sy * -_anchorPointInPoints.x * _scaleX +  cx * -_anchorPointInPoints.y * _scaleY;
//            }
//            
//            
//            // Build Transform Matrix
//            // Adjusted transfor m calculation for rotational skew
//            _transform = CGAffineTransformMake( cy * _scaleX, sy * _scaleX,
//                                               -sx * _scaleY, cx * _scaleY,
//                                               x, y );
//            
//            // XXX: Try to inline skew
//            // If skew is needed, apply skew and then anchor point
//            if( needsSkewMatrix ) {
//                CGAffineTransform skewMatrix = CGAffineTransformMake(1.0f, tanf(CC_DEGREES_TO_RADIANS(_skewY)),
//                                                                     tanf(CC_DEGREES_TO_RADIANS(_skewX)), 1.0f,
//                                                                     0.0f, 0.0f );
//                _transform = CGAffineTransformConcat(skewMatrix, _transform);
//                
//                // adjust anchor point
//                if( ! CGPointEqualToPoint(_anchorPointInPoints, CGPointZero) )
//                    _transform = CGAffineTransformTranslate(_transform, -_anchorPointInPoints.x, -_anchorPointInPoints.y);
//            }
//            
//            _isTransformDirty = NO;
//        }
//        
//        return _transform;
////        struct objc_super sp;
////        sp.receiver = self;
////        sp.super_class = [self class];
////        id retValue = nil;
//////        objc_msgSend(self, @selector(nodeToParentTransform), nil);
//////        objc_msgSend_fpret(self, @selector(nodeToParentTransform));
////        retValue = objc_msgSendSuper(&sp, @selector(worldToNodeTransform));
//////        id ret = [self callCCSpriteMethod:@selector(nodeToParentTransform)];
////        CGAffineTransform transfrom = *(CGAffineTransform *)(&retValue);
////        return transfrom;
//    }
//    return [super nodeToParentTransform];
//}

// Override the setters and getters to always reflect the body's properties.

-(CGPoint)position
{
    if (_b2Body == NULL) {
        return [super position];
    }
	b2Vec2 pos  = _b2Body->GetPosition();
	
	float x = pos.x * _PTMRatio;
	float y = pos.y * _PTMRatio;
	return ccp(x,y);
}

-(void)setPosition:(CGPoint)position
{
    if (_b2Body == NULL) {
        [super setPosition:position];
        return;
    }
//	float angle = _b2Body->GetAngle();
//	_b2Body->SetTransform( b2Vec2(position.x / _PTMRatio, position.y / _PTMRatio), angle );
    float radians = -CC_DEGREES_TO_RADIANS(super.rotation);
    CGPoint worldP = [self.parent convertToWorldSpace:position];
    _b2Body->SetTransform( b2Vec2(worldP.x / _PTMRatio, worldP.y / _PTMRatio), radians );
}

-(float)rotation
{
    if (_b2Body == NULL) {
        return [super rotation];
    }
	return (_ignoreBodyRotation ? super.rotation :
			CC_RADIANS_TO_DEGREES( _b2Body->GetAngle() ) );
}

- (void)setB2Body:(b2Body *)b2Body
{
    _b2Body = b2Body;
    [self setPosition:super.position];
}

-(void)setRotation:(float)rotation
{
    if (_b2Body == NULL) {
        [super setRotation:rotation];
        return;
    }
	if(_ignoreBodyRotation){
		super.rotation = rotation;
	} else {
		b2Vec2 p = _b2Body->GetPosition();
		float radians = CC_DEGREES_TO_RADIANS(rotation);
		_b2Body->SetTransform( p, radians);
	}
}

//-(CGAffineTransform) nodeToParentTransform
//{
//    if (_b2Body == NULL) {
//        return [super nodeToParentTransform];
//    }
//	b2Vec2 pos  = _b2Body->GetPosition();
//	float x = pos.x * _PTMRatio;
//	float y = pos.y * _PTMRatio;
//	if ( _ignoreAnchorPointForPosition ) {
//		x += _anchorPointInPoints.x;
//		y += _anchorPointInPoints.y;
//	}
//    float radians = _b2Body->GetAngle();
//	float c = cosf(radians);
//	float s = sinf(radians);
//	if( ! CGPointEqualToPoint(_anchorPointInPoints, CGPointZero) ){
//		x += c*-_anchorPointInPoints.x * _scaleX + -s*-_anchorPointInPoints.y * _scaleY;
//		y += s*-_anchorPointInPoints.x * _scaleX + c*-_anchorPointInPoints.y * _scaleY;
//	}
//	_transform = CGAffineTransformMake( c * _scaleX,	s * _scaleX,
//									   -s * _scaleY,	c * _scaleY,
//									   x,	y );
//	return _transform;
//}


@end
