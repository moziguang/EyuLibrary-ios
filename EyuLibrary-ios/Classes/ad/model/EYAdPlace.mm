//
//  AdPlace.m
//  ballzcpp-mobile
//
//  Created by apple on 2018/5/2.
//

#import "EYAdPlace.h"

@implementation EYAdPlace
@synthesize placeId = _placeId;
@synthesize groupId = _groupId;

-(instancetype) initWithId : (NSString*) placeId groupId:(NSString*) groupId
{
    self = [super init];
    if(self)
    {
        self.placeId = placeId;
        self.groupId = groupId;
    }
    return self;
}
@end
