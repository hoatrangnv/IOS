//
//  DoiTuongNotification.h
//  ViMASS
//
//  Created by DucBT on 10/14/14.
//
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    DA_GUI,
    DANG_GUI,
    THAT_BAI,
} TRANG_THAI_GUI;

@interface DoiTuongNotification : NSObject

@property (nonatomic, copy) NSNumber *appId;
@property (nonatomic, copy) NSNumber *funcID;
@property (nonatomic, copy) NSString *alertId;
@property (nonatomic, copy) NSString *alertContent;
@property (nonatomic, copy) NSString *alert;
@property (nonatomic, copy) NSNumber *time;
@property (nonatomic, copy) NSNumber *totalFunc;
@property (nonatomic, copy) NSNumber *badge;
@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *recipient;
@property (nonatomic, copy) NSString *nameAlias;
@property (nonatomic, copy) NSString *nameAliasRecipient;
@property (nonatomic, copy) NSNumber *status;
@property (nonatomic, copy) NSString *idShow;
@property (nonatomic, copy) NSString *lydo;
@property (nonatomic, copy) NSNumber *statusShow;
@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, copy) NSNumber *typeShow;

//Trang thai dung cho chat
@property (nonatomic, assign) int mTrangThai;

- (id)initWithDict:(NSDictionary*)dict;

- (NSString*)layThoiGian;

- (NSDate*)layThoiGianTraVeNSDate;

@end
