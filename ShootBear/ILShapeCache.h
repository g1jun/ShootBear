//
//  ILShapeCache.h
//  ShootBear
//
//  Created by mac on 13-8-12.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Box2D.h>
#import "ILPhysicsSprite.h"


//PTM_Radio 为缩放的百分比

@interface ILShapeCache : NSObject 
{
    NSMutableDictionary *shapeDic_;
    float ptmRatio_;
    float localRatio_;
}

+ (ILShapeCache *)sharedShapeCache;

-(void) addShapesWithFile:(NSString*)plist;

-(void) addFixturesToBody:(b2Body*)body forShapeName:(NSString*)shape;

-(void) addFixturesToBody:(b2Body*)body forPhysicsSprite:(ILPhysicsSprite *)sprite;

-(CGPoint) anchorPointForShape:(NSString*)shape;

-(float) shapeScale:(NSString *)shape;

- (void)setPTMRatio:(float)ptmRatio;

@end
