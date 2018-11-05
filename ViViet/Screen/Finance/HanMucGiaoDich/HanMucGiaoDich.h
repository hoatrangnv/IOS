//
//  HanMucGiaoDich.h
//  ViViMASS
//
//  Created by DucBT on 2/11/15.
//
//

#import <Foundation/Foundation.h>

@interface HanMucGiaoDich : NSObject

@property (nonatomic, retain) NSArray *mDanhSachGioiHan;
@property (nonatomic, retain) NSString *idOwner;
@property (nonatomic, retain) NSNumber *typeAuthenticate;

- (id) initWithDictionary:(NSDictionary*)dict;


- (NSDictionary*)toDict;
@end
