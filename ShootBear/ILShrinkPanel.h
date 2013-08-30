//
//  ILShrinkPanel.h
//  ShootBear
//
//  Created by mac on 13-8-29.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILShrinkButton.h"

@interface ILShrinkPanel : CCNode <ILShrinkButtonDelegate>
{
    ILShrinkButton *_firstButton;
    BOOL _foldState;
}

- (void)pushState;

- (void)popState;

@end
