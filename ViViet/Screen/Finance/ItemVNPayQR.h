//
//  ItemVNPayQR.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/27/19.
//

#import <Foundation/Foundation.h>

@interface ItemVNPayQR : NSObject
@property (nonatomic, strong) NSString *payLoad;
@property (nonatomic, strong) NSString *pointOIMethod;
@property (nonatomic, strong) NSString *masterMerchant;
@property (nonatomic, strong) NSString *merchantCode;
@property (nonatomic, strong) NSString *merchantCC;
@property (nonatomic, strong) NSString *ccy;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *merchantName;
@property (nonatomic, strong) NSString *merchantCity;
@property (nonatomic, strong) NSString *pinCode;
@property (nonatomic, strong) NSString *addtionalData;
@property (nonatomic, strong) NSString *crc16;
@property (nonatomic, strong) NSString *storeID;
@property (nonatomic, strong) NSString *billNumber;
@property (nonatomic, strong) NSString *terminalID;
@property (nonatomic, strong) NSString *purpose;
@property (nonatomic, strong) NSString *consumerData;
@property (nonatomic, strong) NSString *customerID;
@property (nonatomic, strong) NSString *referenceID;
@property (nonatomic, strong) NSString *expDate;
@property (nonatomic, assign) int typeQRShow;
- (id)initWithDict:(NSDictionary*)dict;
- (void)setData:(NSDictionary *)dict;
@end

