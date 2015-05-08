//
//  ILSceneReplace.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-10-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILSceneReplace.h"
#define TRANSITION_DURATION (1.5f)

@implementation ILSceneReplace

+ (void)replaceScene:(CCScene *)scene
{
    id tsg = [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:scene];
    [[CCDirector sharedDirector] replaceScene:tsg];

}

+ (void)runScene:(CCScene *)scene
{
    id tsg = [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:scene];
    [[CCDirector sharedDirector] runWithScene:tsg];
}

@end
