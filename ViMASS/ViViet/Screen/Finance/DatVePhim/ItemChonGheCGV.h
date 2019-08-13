//
//  ItemChonGheCGV.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 7/4/16.
//
//

#import <Foundation/Foundation.h>

@interface ItemChonGheCGV : NSObject
@property (nonatomic, retain) NSMutableArray *arrGheChon;
@property (nonatomic, assign) BOOL isChon;
@property (nonatomic, assign) int nGiaTri;

- (id)init;
- (NSString *)convertJSON;
@end
