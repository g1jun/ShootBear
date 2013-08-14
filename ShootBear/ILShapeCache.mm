//
//  ILShapeCache.m
//  ShootBear
//
//  Created by mac on 13-8-12.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILShapeCache.h"
#import "CCNode+CCBRelativePositioning.h"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#   define CGPointFromString_ CGPointFromString
#else
static CGPoint CGPointFromString_(NSString* str)
{
    NSString* theString = str;
    theString = [theString stringByReplacingOccurrencesOfString:@"{ " withString:@""];
    theString = [theString stringByReplacingOccurrencesOfString:@" }" withString:@""];
    NSArray *array = [theString componentsSeparatedByString:@","];
    return CGPointMake([[array objectAtIndex:0] floatValue], [[array objectAtIndex:1] floatValue]);
}
#endif


class FixtureDef
{
public:
    FixtureDef()
    : next(0)
    {}
    
    ~FixtureDef()
    {
        delete next;
        delete fixture.shape;
    }
    
    FixtureDef *next;
    b2FixtureDef fixture;
    int callbackData;
};


@interface BodyDef : NSObject
{
@public
    FixtureDef *fixtures;
    CGPoint anchorPoint;
}
@end


@implementation BodyDef

-(id) init
{
    self = [super init];
    if(self)
    {
        fixtures = 0;
    }
    return self;
}

-(void) dealloc
{
    delete fixtures;
    [super dealloc];
}

@end



@implementation ILShapeCache

+ (ILShapeCache *)sharedShapeCache
{
    static ILShapeCache *shapeCache = 0;
    if(!shapeCache)
    {
        shapeCache = [[ILShapeCache alloc] init];
    }
    return shapeCache;
}


-(id) init
{
    self = [super init];
    if(self)
    {
        shapeObjects_ = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [shapeObjects_ release];
    [super dealloc];
}

-(void) addFixturesToBody:(b2Body*)body forPhysicsSprite:(ILPhysicsSprite *)sprite
{
}

-(void) addFixturesToBody:(b2Body*)body forShapeName:(NSString*)shape
{
    BodyDef *so = [shapeObjects_ objectForKey:shape];
    assert(so);
    
    FixtureDef *fix = so->fixtures;
    while(fix)
    {
        body->CreateFixture(&fix->fixture);
        fix = fix->next;
    }
}

-(CGPoint) anchorPointForShape:(NSString*)shape
{
    BodyDef *bd = [shapeObjects_ objectForKey:shape];
    assert(bd);
    return bd->anchorPoint;
}


-(void) addShapesWithFile:(NSString*)plist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:plist
                                                     ofType:nil
                                                inDirectory:nil];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *metadataDict = [dictionary objectForKey:@"metadata"];
    int format = [[metadataDict objectForKey:@"format"] intValue];
    ptmRatio_ =  [[metadataDict objectForKey:@"ptm_ratio"] floatValue];
    NSAssert(format == 1, @"Format not supported");
    NSDictionary *bodyDict = [dictionary objectForKey:@"bodies"];
    [self putBodyToCache:bodyDict];
    
    
}

- (BOOL)isPolygons:(NSDictionary *)fixtureData
{
    return [[fixtureData objectForKey:@"fixture_type"] isEqual:@"POLYGON"];
}

- (BOOL)isCycle:(NSDictionary *)fixtureData
{
    return [[fixtureData objectForKey:@"fixture_type"] isEqual:@"CIRCLE"];
}


- (void)putBodyToCache:(NSDictionary *)bodyDict
{
    for(NSString *bodyName in bodyDict) {
        NSDictionary *bodyData = [bodyDict objectForKey:bodyName];
        BodyDef *bodyDef = [[[BodyDef alloc] init] autorelease];
        bodyDef->anchorPoint = CGPointFromString_([bodyData objectForKey:@"anchorpoint"]);
        NSArray *fixtureList = [bodyData objectForKey:@"fixtures"];
        FixtureDef **nextFixtureDef = &(bodyDef->fixtures);
        for(NSDictionary *fixtureData in fixtureList) {
            if([self isPolygons:fixtureData]) {
                NSArray *polygonsArray = [fixtureData objectForKey:@"polygons"];
                for(int i = 0; i < polygonsArray.count; i++) {
                    FixtureDef *fix = [self createPolygonFixtureDef:fixtureData index:i];
                    *nextFixtureDef = fix;
                    nextFixtureDef = &(fix->next);
                }
            }
            else if([self isCycle:fixtureData]) {
                FixtureDef *fix = [self createCircleFixtureDef:fixtureData];
                *nextFixtureDef = fix;
                nextFixtureDef = &(fix->next);
            } else {
                assert(0);
            }
        }
        
        [shapeObjects_ setObject:bodyDef forKey:bodyName];
    }
}

- (FixtureDef *)createPolygonFixtureDef:(NSDictionary *)fixtureData index:(int)index
{
    FixtureDef *fix = new FixtureDef();
    fix->fixture = [self fixtureDef:fixtureData];; // copy basic data
    fix->callbackData = [[fixtureData objectForKey:@"userdataCbValue"] intValue];
    NSArray *polygonsArray = [fixtureData objectForKey:@"polygons"];
    NSArray *polygonArray = polygonsArray[index];
    fix->fixture.shape = [self createPolygonShape:polygonArray];
    return fix;
}

- (b2PolygonShape *)createPolygonShape:(NSArray *)polygonArray
{
    b2Vec2 vertices[b2_maxPolygonVertices];
    b2PolygonShape *polyshape = new b2PolygonShape();
    int vindex = 0;
    assert([polygonArray count] <= b2_maxPolygonVertices);
    for(NSString *pointString in polygonArray)
    {
        CGPoint offset = CGPointFromString_(pointString);
        vertices[vindex].x = (offset.x / ptmRatio_) ;
        vertices[vindex].y = (offset.y / ptmRatio_) ;
        vindex++;
    }
    
    polyshape->Set(vertices, vindex);
    return polyshape;
}

- (FixtureDef *)createCircleFixtureDef:(NSDictionary *)fixtureData
{
    FixtureDef *fix = new FixtureDef();
    fix->fixture = [self fixtureDef:fixtureData]; // copy basic data
    fix->callbackData = [[fixtureData objectForKey:@"userdataCbValue"] intValue];
    b2CircleShape *circleShape = [self createCircleshape:fixtureData];
    fix->fixture.shape = circleShape;
    return fix;
}

- (b2FixtureDef) fixtureDef:(NSDictionary *)fixtureData
{
    b2FixtureDef basicData;
    basicData.filter.categoryBits = [[fixtureData objectForKey:@"filter_categoryBits"] intValue];
    basicData.filter.maskBits = [[fixtureData objectForKey:@"filter_maskBits"] intValue];
    basicData.filter.groupIndex = [[fixtureData objectForKey:@"filter_groupIndex"] intValue];
    basicData.friction = [[fixtureData objectForKey:@"friction"] floatValue];
    basicData.density = [[fixtureData objectForKey:@"density"] floatValue];
    basicData.restitution = [[fixtureData objectForKey:@"restitution"] floatValue];
    basicData.isSensor = [[fixtureData objectForKey:@"isSensor"] boolValue];
    return basicData;
}


- (b2CircleShape *)createCircleshape:(NSDictionary*)fixtureData
{
    NSDictionary *circleData = [fixtureData objectForKey:@"circle"];
    b2CircleShape *circleShape = new b2CircleShape();
    circleShape->m_radius = [[circleData objectForKey:@"radius"] floatValue]  / ptmRatio_;
    CGPoint p = CGPointFromString_([fixtureData objectForKey:@"position"]);
    circleShape->m_p = b2Vec2(p.x / ptmRatio_, p.y / ptmRatio_);
    return circleShape;
}

-(float) ptmRatio
{
    return ptmRatio_;
}

@end
