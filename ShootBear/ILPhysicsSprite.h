//
//  ILPhysicsSprite.h
//  ShootBear
//
//  Created by mac on 13-8-9.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCPhysicsSprite.h"

@interface ILPhysicsSprite : CCSprite
{
    	BOOL	_ignoreBodyRotation;
    b2Body	*_b2Body;
	
	// Pixels to Meters ratio
	float	_PTMRatio;
}

@property(nonatomic, assign) BOOL ignoreBodyRotation;

@property (copy, nonatomic) NSString *imageName;
@property(nonatomic, assign) b2Body *b2Body;

@property(nonatomic, assign) float PTMRatio;

@end
