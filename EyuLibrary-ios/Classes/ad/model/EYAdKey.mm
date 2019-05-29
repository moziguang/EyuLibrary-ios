//
//  AdKey.m
//  ballzcpp-mobile
//
//  Created by apple on 2018/5/2.
//

#import "EYAdKey.h"

@implementation EYAdKey
@synthesize keyId = _keyId;
@synthesize network = _network;
@synthesize key = _key;

-(instancetype) initWithId : (NSString*) keyId network:(NSString*) network key:(NSString*) key
{
    self = [super init];
    if(self)
    {
        if(keyId!=NULL){
            self.keyId = keyId;
        }
        if(network!=NULL){
            self.network = network;
        }
        if(key!=NULL){
            self.key = key;
        }
    }
    return self;
}
@end
