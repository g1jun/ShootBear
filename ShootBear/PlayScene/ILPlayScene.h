//
//  ILPlayScene.h
//  ShootBear
//
//  Created by mac on 13-8-4.
//  Copyright 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ILBearCollisionDelegate.h"
#import "ILLevelLayer.h"
#import "ILBox2dFactory.h"
#import "ILStruct.h"



@interface ILPlayScene : CCScene <ILLevelCompletedDelegate, ILPlayFailedDelegate> {
    
    @private
    ILLevelLayer *_currentLevel;
    ILPlayControl *_playControl;
    NSMutableDictionary *_cacheLayers;
    Level _currentLevelNO;
}

- (id)initWithLevel:(Level) level;


@end
