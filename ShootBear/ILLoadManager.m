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


- (id)init
{
    self = [super init];
    if (self) {
        _totoalResources = [self imageResources].count + [self soundResources].count;

    }
    return self;
}

- (void)load
{
    [self performSelectorInBackground:@selector(asyncLoad) withObject:nil]; 
}

- (void)firstLoad
{
    BOOL hasGive = [[ILDataSimpleSave sharedDataSave] boolWithKey:@"has_give_guns"];
    if (!hasGive) {
        [[ILDataSimpleSave sharedDataSave] saveInt:3 forKey:kFireGun];
        [[ILDataSimpleSave sharedDataSave] saveInt:3 forKey:kElectriGun];
        [[ILDataSimpleSave sharedDataSave] saveInt:3 forKey:kCannon];
        [[ILDataSimpleSave sharedDataSave] saveBool:YES forKey:@"has_give_guns"];
        [[ILDataSimpleSave sharedDataSave] saveFloat:1.0 forKey:@"version"];
    }
}

- (void)asyncLoad
{
    [self firstLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate startLoad];
    });
    [self loadBackgroundSound];
    [self loadEffectSound];
    [self loadImages];
}

- (void)loadImages
{
    for (NSString *name in [self imageResources]) {
        [[CCTextureCache sharedTextureCache] addImageAsync:name withBlock:^(CCTexture2D *tex) {
            [self increasePercent];
        }];
    }
    
}

- (void)increasePercent
{
    @synchronized(self) {

    dispatch_async(dispatch_get_main_queue(), ^{
            _currentFinished++;
            [self.delegate loadPercent:(float)_currentFinished / _totoalResources];
            if (_currentFinished == _totoalResources) {
                [self.delegate finishLoad];
            }
    });
    }
    
}



- (void)loadBackgroundSound
{
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"menu_sound.mp3"];
}

- (NSArray *)imageResources
{
    return @[@"bear.png", @"element.png", @"others.png", @"clound.png"];
}

- (NSArray *)soundResources
{
    return @[@"bear_dead.mp3", @"bear_dead_good.wav", @"bomb.wav", @"bullet_use_up.mp3", @"cannon_fire.mp3", @"elctric_gun.mp3", @"", @"fire_gun_fire.mp3", @"game_dead.mp3", @"hand_gun_fire.wav", @"metal_collision.mp3", @"pick_up_coin"];
}

- (void)loadEffectSound
{
    for (NSString *sound in [self soundResources]) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:sound];
        [self increasePercent];
    }
}

@end
