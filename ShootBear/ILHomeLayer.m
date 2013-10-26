//
//  ILHomeLayer.m
//  BearHunter
//
//  Created by mac on 13-10-15.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "SimpleAudioEngine.h"
#import "ILHomeLayer.h"

@implementation ILHomeLayer

- (id)init
{
    self = [super init];
    if (self) {
        _loadManager = [[ILLoadManager alloc] init];
        _loadManager.delegate = self;
    }
    return self;
}


- (void)onEnter
{
    [super onEnter];
    [_loadManager load];
}

- (void)dealloc
{
    [_loadManager release];
    [super dealloc];
}

- (void)showPercent:(int)percent
{
    NSString *string = [NSString stringWithFormat:@"%@%i", NSLocalizedString(@"home_load", nil),percent];
    _label.string = string;
}

- (void)startLoad
{
    [self showPercent:0];
}


- (void)finishLoad
{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menu_sound.mp3"];
    _label.visible = NO;
    _control.visible = YES;
}


- (void)onExit
{
    [super onExit];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void)loadPercent:(float)percent
{
    [self showPercent:percent * 100];
}

@end
