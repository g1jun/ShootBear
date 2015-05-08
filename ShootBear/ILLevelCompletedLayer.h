//
//  ILLevelCompletedLayer.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-10-4.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILTouchStopLayer.h"
#import "ILStruct.h"

@interface ILLevelCompletedLayer : ILTouchStopLayer
{
    CCLabelTTF *_percentLabel;
}

@property (assign, nonatomic)LevelGrade grade;

@property (assign, nonatomic)float percent;

@end
