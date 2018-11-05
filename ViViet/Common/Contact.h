//
//  Contact.h
//
//  Created by Ngo Ba Thuong on 3/11/13.
//  Copyright (c) 2013 Ngo Ba Thuong. All rights reserved.
//
//  Require AddressBook.framework

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
typedef enum
{
    ContactFullNameOrder_FirstLast,
    ContactFullNameOrder_LastFirst
    
} ContactFullNameOrder;

@interface Contact : NSObject

@property (nonatomic, copy) NSString * phone;
@property (nonatomic, assign) BOOL hasAccount;
@property (nonatomic, copy) NSString * firstName;
@property (nonatomic, copy) NSString * lastName;
@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, assign) ABRecordID *recordID;


- (id)initWithPhone:(NSString *) phone andFirstName:(NSString *)firstName andLastName:(NSString *)lastName;
- (id)initWithPhone:(NSString *)phone
          firstName:(NSString *)firstName
           lastName:(NSString *)lastName
           recordID:(ABRecordID)recordID;

- (id)initWithDict:(NSDictionary*)dict;

- (NSDictionary*)toDictionary;

- (NSComparisonResult)compare:(Contact *)other;

+ (void)setFullNameOrder:(ContactFullNameOrder) order;
+ (void)getContacts:(void (^)(NSMutableArray *contacts))delegate;

+ (NSDictionary*)layDictDanhSachTaiKhoan;

+ (NSDictionary*)capNhatDictDanhSachTaiKhoan:(NSDictionary*)dictDanhSachTaiKhoan;



@end
