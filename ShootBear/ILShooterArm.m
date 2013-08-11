//
//  ILShooterArm.m
//  ShootBear
//
//  Created by mac on 13-8-10.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILShooterArm.h"
#import "CCControlExtension.h"

@implementation ILShooterArm

- (void)didLoadFromCCB
{
     [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

- (BOOL)isTouchInside:(UITouch *)touch
{
    CGPoint touchLocation   = [touch locationInView:[touch view]];
    touchLocation           = [[CCDirector sharedDirector] convertToGL:touchLocation]; 
    touchLocation           = [self convertToNodeSpace:touchLocation]; 
    
    return CGRectContainsPoint([_touchRotation boundingBox], touchLocation);
}



- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self isTouchInside:touch]) {
        NSLog(@"YYYYYYYYY");
        return YES;

    }
    NSLog(@"xxxxxxx");

    return NO;
}

- (void)onEnter
{
    [super onEnter];
   
}

- (void)pressedButton:(id)sender event:(CCControlEvent)event
{
    NSLog(@"ddddddd");

}

- (void)onExit
{
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
    [super onExit];
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

@end
