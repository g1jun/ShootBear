//
//  ILLevelLayer.h
//  ShootBear
//
//  Created by mac on 13-8-27.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILStruct.h"
#import "CCLayer.h"
#import "ILShooter.h"
#import "ILBear.h"
#import "ILBearCollisionDelegate.h"
#import "ILPlayControl.h"

@protocol ILLevelCompletedDelegate <NSObject>

@required
- (void)levelCompleted;

@end


@interface ILLevelLayer : CCLayer <ILBearCollisionDelegate, ILPlayControlDelegate>
{
    ILShooter *_shooter;
    NSMutableArray *_bears;
}

@property (assign, nonatomic) id<ILLevelCompletedDelegate> delegate;
//@property (nonatomic, readwrite)Level level;

@end
