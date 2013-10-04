//
//  ILMenuItem.h
//  ShootBear
//
//  Created by mac on 13-9-3.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "CCControlButton.h"
#import "ILStruct.h"



@interface ILMenuItem : CCNode
{
    CCSprite *_lockSprite;
    CCLabelTTF *_label;
    CCControlButton *_button;
}

@property (assign, nonatomic, readonly) int levelNO;
@property (assign, nonatomic, readonly) BOOL hasOpen;
@property (assign, nonatomic,)int groupIndex;
@property (assign, nonatomic)CCSprite *goodSprite;
@property (assign, nonatomic)CCSprite *generalSprite;

- (void)open:(LevelGrade) grade;

@end
