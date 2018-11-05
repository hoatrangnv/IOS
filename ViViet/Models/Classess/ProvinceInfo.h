//
//  ProvinceInfo.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/5/12.
//
//

#import <Foundation/Foundation.h>

@interface ProvinceInfo : NSObject

@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *provinceID;


+(ProvinceInfo *) provinceInfoFromDictionary:(NSDictionary *)dict;

@end
