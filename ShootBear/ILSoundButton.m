//
//  ILSoundButton.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-10-10.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILSoundButton.h"
#import "SimpleAudioEngine.h"
#import "ILDataSimpleSave.h"

@implementation ILSoundButton

- (void)didLoadFromCCB
{
    BOOL isOff = [[ILDataSimpleSave sharedDataSave] boolWithKey:@"music"];
    [SimpleAudioEngine sharedEngine];
    [[SimpleAudioEngine sharedEngine] setMute:isOff];
    [self updateForbiddenSprite];
}

- (void)updateForbiddenSprite
{
    BOOL isOff = [[ILDataSimpleSave sharedDataSave] boolWithKey:@"music"];
    if (isOff) {
        _forbiddenSprite.visible = YES;
    } else {
        _forbiddenSprite.visible = NO;
    }
}


- (void)pressedSoundButton:(id)sender
{
    BOOL isOff = [[ILDataSimpleSave sharedDataSave] boolWithKey:@"music"];
    [[SimpleAudioEngine sharedEngine] setMute:!isOff];
    [[ILDataSimpleSave sharedDataSave] saveBool:!isOff forKey:@"music"];
    [self updateForbiddenSprite];
}

@end
