//
//  DucNT_SaoKeObject.h
//  ViMASS
//
//  Created by MacBookPro on 7/11/14.
//
//

#import <Foundation/Foundation.h>

@interface DucNT_SaoKeObject : NSObject

@property(nonatomic, retain) NSString *amount;
@property(nonatomic, retain) NSString *bankAcc;
@property(nonatomic, retain) NSString *bankShortName;
@property(nonatomic, retain) NSNumber *feeAmount;
@property(nonatomic, retain) NSString *sId;
@property(nonatomic, retain) NSString *transTime;

@property(nonatomic, retain) NSString *transDesc;
@property(nonatomic, retain) NSString *fromAcc;
@property(nonatomic, retain) NSString *toAcc;

@property(nonatomic, retain) NSString *nameBenefit;
@property(nonatomic, retain) NSString *nameUsed;

//Phuc vu sao ke qua tang
@property(nonatomic, retain) NSNumber *totalAmount;
@property(nonatomic, retain) NSNumber *type;
@property(nonatomic, retain) NSString *giftName;
@property(nonatomic, retain) NSNumber *idIcon;

@property(nonatomic, retain) NSNumber *totalAmountToAcc;
@property(nonatomic, retain) NSNumber *totalPromotion;
@property(nonatomic, retain) NSNumber *totalPromotionToAcc;
@property(nonatomic, retain) NSNumber *timeAction;
@property(nonatomic, retain) NSNumber *VMApp;


@property(nonatomic, retain) NSNumber *kieuXacThuc;
@property(nonatomic, retain) NSNumber *donViXacThuc;

- (id)initWithDictionary:(NSDictionary*)dict;

- (NSString*)layThoiGianChuyenTien;

- (NSString*)layNgayThangChuyenTien;

- (NSString*)layNgayGioChuyenTien;

- (NSString*)layNoiDung;

- (NSString*)layGiftName;

- (NSString*)layTimeAction;

@end
