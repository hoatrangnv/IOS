//
//  ItemPhongXemFilm.h
//  ViViMASS
//
//  Created by nguyen tam on 9/17/15.
//
//

#import <Foundation/Foundation.h>

@interface ItemPhongXemFilm : NSObject

@property (nonatomic, copy) NSString* phong;
@property (nonatomic, retain) NSMutableArray *arrDayGhe;
@property (nonatomic, assign) int typeRap;
- (void)khoiTaoPhongXemFilm:(NSDictionary *)dic;

@end
