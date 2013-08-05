//
//  ILTMXLayer.h
//  ShootBear
//
//  Created by mac on 13-8-4.
//  Copyright 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ILShootBear.h"
#import "Box2D.h"

@interface ILTMXLayer : CCLayer {
    
}

+ (id)nodeWithB2World:(b2World *) world;

@end
