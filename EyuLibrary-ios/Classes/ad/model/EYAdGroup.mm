//
//  AdGroup.m
//  ballzcpp-mobile
//
//  Created by apple on 2018/5/2.
//

#import <Foundation/Foundation.h>
#include "EYAdGroup.h"


@implementation EYAdGroup

@synthesize groupId = _groupId;
@synthesize keyArray = _keyArray;
@synthesize isAutoLoad = _isAutoLoad;
@synthesize type = _type;

-(instancetype) initWithId : (NSString*) groupId
{
    self = [self init];
    if(self)
    {
        self.groupId = groupId;
        self.keyArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) addAdKey:(EYAdKey*)key
{
    if(key){
        [self.keyArray addObject:key];
    }
}

@end
