//
//  ILShapeCache.h
//  ShootBear
//
//  Created by mac on 13-8-12.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Box2D.h>
#import "ILPhysicsSprite.h"

@interface ILShapeCache : NSObject 
{
    NSMutableDictionary *shapeObjects_;
    float ptmRatio_;
    NSMutableDictionary *shapDic_;
}

+ (ILShapeCache *)sharedShapeCache;

-(void) addShapesWithFile:(NSString*)plist;

-(void) addFixturesToBody:(b2Body*)body forShapeName:(NSString*)shape;

-(void) addFixturesToBody:(b2Body*)body forPhysicsSprite:(ILPhysicsSprite *)sprite;

-(CGPoint) anchorPointForShape:(NSString*)shape;

-(float) ptmRatio;

@end
