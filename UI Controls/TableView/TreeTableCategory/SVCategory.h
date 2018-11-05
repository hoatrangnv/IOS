//
//  TreeCategory.h
//  ViMASS
//
//  Created by Chung NV on 6/13/13.
//
//

#import <Foundation/Foundation.h>

@interface SVCategory : NSObject

@property (nonatomic, assign) BOOL showSubCate;
@property (nonatomic, assign) BOOL selected;
// server properties
@property (nonatomic, assign) int catId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString * summary;
@property (nonatomic, retain) NSMutableArray *subCates;
@property (nonatomic, assign) SVCategory *parentCate;


-(id)initWithDictionary:(NSDictionary *)dict;
-(NSArray *)getSelected;
-(NSArray *) getSubsSelected;
-(NSString *) subCateIDs;
-(NSDictionary *) getSubsSelectedDictionary;
@end
