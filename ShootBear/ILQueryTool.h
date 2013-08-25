//
//  ILQueryTool.h
//  ShootBear
//
//  Created by mac on 13-8-25.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILSpriteBase.h"
#import <Box2D.h>

@interface ILQueryTool : NSObject

+ (void)queryAround:(ILSpriteBase *)sprite callback:(b2QueryCallback *)callback;

@end
