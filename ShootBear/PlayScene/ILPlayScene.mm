//
//  ILPlayScene.m
//  ShootBear
//
//  Created by mac on 13-8-4.
//  Copyright 2013年 mac. All rights reserved.
//

#import "ILPlayScene.h"
#import "ILBox2dDebug.h"
#import "CCBReader.h"
#import "ILPhysicsSprite.h"
#import "CCBAnimationManager.h"
#import "ILShapeCache.h"
#import "ILShooter.h"

@interface ILPlayScene ()

@end

@implementation ILPlayScene

- (id)init {
    self = [super init];
    if(self) {
        [[ILBox2dFactory sharedFactory] prepareB2World];
        [[ILBox2dFactory sharedFactory] setBearCollisionDelegate:self];
        CCNode *layer = [CCBReader nodeGraphFromFile:@"level0.ccbi"];
        layer.position = ccp(0, 0);
        [self addChild:layer];
        ILShooter *shooter = (ILShooter *)[CCBReader nodeGraphFromFile:@"Shooter.ccbi"];
        shooter.position = ccp(100, 100);
        CCNode *bear = [CCBReader nodeGraphFromFile:@"BearRight.ccbi"];
        bear.position = ccp(600, 100);
        CCBAnimationManager* animationManager = bear.userObject;
        [animationManager runAnimationsForSequenceNamed:@"dynamic"];
        
        [self addChild:bear];
                [self addChild:shooter];
        [self scheduleUpdate];
        
        [shooter replaceGunType:kCannon];
        
        ILBox2dDebug *debug = [[ILBox2dDebug alloc] init];
//        [self addChild:debug z:100];
        [debug release];
    }
    return self;
}

- (void)dealloc
{
    [[ILBox2dFactory sharedFactory] releaseB2World];
    [super dealloc];
}



-(void) update: (ccTime) dt
{
	int32 velocityIterations = 10;
	int32 positionIterations = 10;
	[ILBox2dFactory sharedFactory].world->Step(dt, velocityIterations, positionIterations);
}


- (void)headCollision:(ILBear *)bear bullet:(ILBullet *)bullet
{
    
}

- (void)bodyCollision:(ILBear *)bear bullet:(ILBullet *)bullet
{
    
}

- (void)legCollision:(ILBear *)bear bullet:(ILBullet *)bullet
{
    
}




@end
