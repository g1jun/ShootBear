//
//  ILQueryTool.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-25.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILSpriteBase.h"
#import <Box2D.h>

@interface ILQueryTool : NSObject

+ (void)queryAround:(ILSpriteBase *)sprite callback:(b2QueryCallback *)callback;

+ (void)queryAround:(ILSpriteBase *)sprite callback:(b2QueryCallback *)callback scale:(float)scale;
@end
