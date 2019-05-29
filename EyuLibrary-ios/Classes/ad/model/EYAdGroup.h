//
//  AdGroup.h
//  ballzcpp-mobile
//
//  Created by apple on 2018/5/2.
//

#ifndef AdGroup_h
#define AdGroup_h
#import "EYAdKey.h"

@interface EYAdGroup : NSObject{

}

@property(nonatomic,copy)NSString *groupId;
@property(nonatomic,strong)NSMutableArray<EYAdKey*> *keyArray;
@property(nonatomic,assign)bool isAutoLoad;
@property(nonatomic,copy)NSString *type;

-(instancetype) initWithId : (NSString*) groupId;

-(void) addAdKey:(EYAdKey*)key;

@end

#endif /* AdCache_h */
