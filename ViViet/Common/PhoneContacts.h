//
//  PhoneContacts.h
//  testPhoneContact
//
//  Created by QUANGHIEP on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "Contact.h"


@interface PhoneContacts : NSObject

+(UIImage*)getAvatarByRecordID:(ABRecordID) recordID;
+ (void) getListPhoneNumber: (NSArray**)contacts;


//+ (void)layDanhSachTaiKhoanTrongDanhBa:(NSArray**)danhSachTraVe;

//+ (NSDictionary*)layDanhBa

@end
