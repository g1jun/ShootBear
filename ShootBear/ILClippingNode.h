

#import "CCNode.h"

@interface ILClippingNode : CCNode
{
//    CCNode *_stencil;
    GLfloat _alphaThreshold;
    BOOL _inverted;
    NSMutableArray *_stencils;
}


//@property (nonatomic, retain) CCNode *stencil;


@property (nonatomic) GLfloat alphaThreshold;


@property (nonatomic) BOOL inverted;

+ (id)clippingNode;

- (void)addStencil:(CCNode *)node;

- (void)removeStencil:(CCNode *)node;


- (id)init;

@end
