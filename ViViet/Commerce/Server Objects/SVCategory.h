//
//  SVCategory.h
//  ViMASS
//
//  Created by Chung NV on 5/31/13.
//
//

#import <Foundation/Foundation.h>

@interface SVCategory : NSObject

@property (nonatomic, assign) BOOL showSubCate;
@property (nonatomic, assign) int ID;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *subs;


-(id)initWithDictionary:(NSDictionary *)dict;

@end
