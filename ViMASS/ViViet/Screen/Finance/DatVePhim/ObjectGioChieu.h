//
//  ObjectGioChieu.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/9/15.
//
//

#import <Foundation/Foundation.h>

@interface ObjectGioChieu : NSObject

@property (nonatomic, copy) NSString *idRap;
@property (nonatomic, copy) NSString *idPhim;
@property (nonatomic, copy) NSString *ngayChieu;
@property (nonatomic, copy) NSString *idKhungGio;
@property (nonatomic, retain) NSMutableArray *groupNgayChieu;

- (id)khoiTaoObjectGioChieu:(NSDictionary *)dict;

@end
