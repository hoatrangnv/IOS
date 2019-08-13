//
//  ItemGheXemFilm.h
//  ViViMASS
//
//  Created by nguyen tam on 9/17/15.
//
//

#import <Foundation/Foundation.h>

@interface ItemGheXemFilm : NSObject

@property (nonatomic, retain) NSString *sHangGhe;
@property (nonatomic, copy) NSString *sId;
@property (nonatomic, copy) NSString *hienThi;
@property (nonatomic, copy) NSString *vip;
@property (nonatomic, copy) NSString *stt;
@property (nonatomic, assign) int trangthai;
@property (nonatomic, copy) NSString *gia;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;
- (void)khoiTaoGhe:(NSDictionary *)dic;

@end
