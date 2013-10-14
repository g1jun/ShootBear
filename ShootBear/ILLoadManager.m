//
//  ILLoadManager.m
//  ShootBear
//
//  Created by mac on 13-9-29.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILLoadManager.h"
#import "SimpleAudioEngine.h"
#import "ILDataSimpleSave.h"

@implementation ILLoadManager

- (void)loadSoundResources
{
    [self firstLoad];
    [self loadBackgroundSound];
    [self loadEffectSound];
}

- (void)firstLoad
{
    BOOL hasGive = [[ILDataSimpleSave sharedDataSave] boolWithKey:@"has_give_guns"];
    if (!hasGive) {
        [[ILDataSimpleSave sharedDataSave] saveInt:3 forKey:kFireGun];
        [[ILDataSimpleSave sharedDataSave] saveInt:3 forKey:kElectriGun];
        [[ILDataSimpleSave sharedDataSave] saveInt:3 forKey:kCannon];
        [[ILDataSimpleSave sharedDataSave] saveBool:YES forKey:@"has_give_guns"];
    }
}

- (void)loadBackgroundSound
{
    
}

- (void)loadEffectSound
{
    NSArray *effectNames = @[@"bear_dead.mp3", @"bear_dead_good.wav", @"bomb.wav", @"bullet_use_up.mp3", @"cannon_fire.mp3", @"elctric_gun.mp3", @"", @"fire_gun_fire.mp3", @"game_dead.mp3", @"hand_gun_fire.wav", @"metal_collision.mp3", @"pick_up_coin"];
    for (NSString *sound in effectNames) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:sound];
    }
}

@end
