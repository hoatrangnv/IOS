//
//  ItemTongChuyenBay.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/9/16.
//
//

#import <Foundation/Foundation.h>

@interface ItemTongChuyenBay : NSObject
@property (nonatomic, assign) int nDinhDanh;//0-chuyen di; 1-chuyen ve
@property (nonatomic, retain) NSMutableArray *arrItemChuyenBay;
- (id)khoiTao;
@end
