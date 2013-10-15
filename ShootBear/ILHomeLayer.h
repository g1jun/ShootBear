//
//  ILHomeLayer.h
//  BearHunter
//
//  Created by mac on 13-10-15.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILLabelTTF.h"
#import "ILLoadManager.h"

@interface ILHomeLayer : CCLayer <ILLoadManagerDelegate>
{
    CCNode *_control;
    ILLabelTTF *_label;
    ILLoadManager *_loadManager;
    
}

@end
