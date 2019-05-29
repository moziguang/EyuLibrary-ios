//
//  AdPlace.h
//  ballzcpp-mobile
//
//  Created by apple on 2018/5/2.
//

#import <Foundation/Foundation.h>

@interface EYAdPlace : NSObject{

}

@property(nonatomic,copy)NSString *placeId;
@property(nonatomic,copy)NSString *groupId;

-(instancetype) initWithId : (NSString*) placeId groupId:(NSString*) groupId;

@end
