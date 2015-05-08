//
//  ILLoadManager.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-29.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ILLoadManagerDelegate <NSObject>

- (void)loadPercent:(float)percent;

- (void)startLoad;

- (void)finishLoad;

@end

@interface ILLoadManager : NSObject
{
    int _totoalResources;
    int _currentFinished;
}

- (void)load;

@property (assign, nonatomic)id<ILLoadManagerDelegate> delegate;

@end
