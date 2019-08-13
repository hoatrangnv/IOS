//
//  ItemHangXemFilm.h
//  ViViMASS
//
//  Created by nguyen tam on 9/17/15.
//
//

#import <Foundation/Foundation.h>

@interface ItemHangXemFilm : NSObject

@property (nonatomic, copy) NSString* stt;
//@property (nonatomic, copy) NSString* stt_day;
@property (nonatomic, assign) int typeHienThi;
@property (nonatomic, retain) NSMutableArray* arrGhe;

- (void)khoiTaoHangXemFilm:(NSDictionary *)dic;

@end
