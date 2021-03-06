//
//  ILShapeCache.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-12.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Box2D.h>
#import "ILSpriteBase.h"


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

-(void) addFixturesToBody:(b2Body*)body forPhysicsSprite:(ILSpriteBase *)sprite;

-(CGPoint) anchorPointForShape:(NSString*)shape;

-(float) shapeScale:(NSString *)shape;

- (void)setPTMRatio:(float)ptmRatio;

@end
