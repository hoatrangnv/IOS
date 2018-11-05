//
//  ItemSanBay.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/5/16.
//
//

#import <Foundation/Foundation.h>

@interface ItemSanBay : NSObject

@property (nonatomic, retain) NSString *sTenSanBay;
@property (nonatomic, retain) NSString *sMaSanBay;
@property (nonatomic, retain) NSMutableArray *arrSanBayDen;

- (id)khoiTaoBanDau;

@end
