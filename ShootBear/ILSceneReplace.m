//
//  ILSceneReplace.m
//  ShootBear
//
//  Created by mac on 13-10-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILSceneReplace.h"
#define TRANSITION_DURATION (1.5f)

@implementation ILSceneReplace

+ (void)replaceScene:(CCScene *)scene
{
    id tsg = [CCTransitionCrossFade transitionWithDuration:TRANSITION_DURATION scene:scene];
    [[CCDirector sharedDirector] replaceScene:tsg];

}

@end
