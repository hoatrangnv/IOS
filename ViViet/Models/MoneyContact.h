//
//  MoneyContact.h
//  ViViMASS
//
//  Created by Hieu on 11/2/18.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

NS_ASSUME_NONNULL_BEGIN
@interface MoneyContact : NSObject
@property (strong, nonatomic) Contact *contact;
@property (copy, nonatomic) NSString *money;
@property (nonatomic, assign) int loaiMapping;
@property (nonatomic, assign) BOOL soTienThanhToanHopLe;

@end

NS_ASSUME_NONNULL_END
