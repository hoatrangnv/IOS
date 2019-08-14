//
//  Contact.h
//
//  Created by Ngo Ba Thuong on 3/11/13.
//  Copyright (c) 2013 Ngo Ba Thuong. All rights reserved.
//

#import "Contact.h"
#import <AddressBook/AddressBook.h>
#import "DucNT_LuuRMS.h"
#import "JSONKit.h"
#import "Common.h"
#import "GiaoDichMang.h"

ContactFullNameOrder fullNameOrder = ContactFullNameOrder_FirstLast;

@implementation Contact
{
    NSString *_phone;
}

+ (void)setFullNameOrder:(ContactFullNameOrder) order
{
    fullNameOrder = order;
}

- (NSComparisonResult)compare:(Contact *)other
{
    NSComparisonResult rslt = NSOrderedSame;
    
    if (fullNameOrder == ContactFullNameOrder_FirstLast)
        rslt = [self.firstName compare:other.firstName];
    else
        rslt = [self.lastName compare:other.lastName];
    
    if (rslt != NSOrderedSame)
        return rslt;
    
    if (fullNameOrder == ContactFullNameOrder_FirstLast)
        rslt = [self.lastName compare:other.lastName];
    else
        rslt = [self.firstName compare:other.firstName];
    
    return rslt;
}

- (NSString *)fullName
{
    NSString *f = self.firstName == nil ? @"" : self.firstName;
    NSString *l = self.lastName == nil ? @"" : self.lastName;
    
    if (fullNameOrder == ContactFullNameOrder_LastFirst)
    {
        NSString *tmp = f;
        f = l;
        l = tmp;
    };
    
    if (f.length == 0)
        return l;
    if (l.length == 0)
        return f;
    
    return [NSString stringWithFormat:@"%@ %@", f, l];
}

- (void)setPhone:(NSString *)phone
{
    if (phone != _phone)
    {
        [_phone release];
        _phone = [[phone stringByReplacingOccurrencesOfString:@" " withString:@""] copy];
    }
}
-(id)initWithPhone:(NSString *)phone_
         firstName:(NSString *)firstName_
          lastName:(NSString *)lastName_
          recordID:(ABRecordID)recordID_
{
    if(self = [super init])
    {

        self.firstName = firstName_;
        self.lastName = lastName_;
        self.phone = phone_;
        self.recordID = recordID_;
        self.hasAccount = NO;
    }
    return self;
}

- (id)initWithPhone:(NSString *)phone_
       andFirstName:(NSString *)firstName_
        andLastName:(NSString *)lastName_
{
    if ([super init])
    {
        self.firstName = firstName_;
        self.lastName = lastName_;
        self.phone = phone_;
        self.hasAccount = NO;
    }
    return self;
}

- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSString *_firstName = [dict valueForKey:@"firstName"];
        if(_firstName)
            self.firstName = _firstName;
        NSString *__phone = [dict valueForKey:@"phone"];
        if(__phone)
            self.phone = __phone;
        NSString *_lastName = [dict valueForKey:@"lastName"];
        if(_lastName)
            self.lastName = _lastName;
        NSNumber *nRecordID = [dict valueForKey:@"recordID"];
        self.recordID = [nRecordID intValue];
        NSNumber *nHasAccount = [dict valueForKey:@"hasAccount"];
        self.hasAccount = [nHasAccount boolValue];
        
    }
    return self;
}

- (void)dealloc
{
    self.firstName = nil;
    self.lastName = nil;
    self.phone = nil;
    [super dealloc];
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if(_phone)
        [dict setObject:_phone forKey:@"phone"];
    [dict setObject:[NSNumber numberWithBool:hasAccount] forKey:@"hasAccount"];
    if(firstName)
        [dict setObject:firstName forKey:@"firstName"];
    if(lastName)
        [dict setObject:lastName forKey:@"lastName"];
    [dict setObject:[NSNumber numberWithInt:recordID] forKey:@"recordID"];
    
    return [dict autorelease];
}

- (BOOL)isEqual:(id)object
{
    Contact *other = (Contact*)object;
    if (
        [self.phone isEqualToString:other.phone]
//      && [self.firstName isEqualToString:other.firstName]
//        && [self.lastName isEqualToString:other.lastName]
//        && self.recordID == other.recordID
        && self.hasAccount == other.hasAccount)
    {
        return YES;
    }
    return NO;
}

#pragma mark - Get all contacts

+(void)getContacts:(void (^)(NSMutableArray *contacts))delegate
{
    void (^tmp)(NSMutableArray *contacts) = [delegate copy];
    delegate = tmp;
    
    ABAddressBookRef address_book = NULL;
    
//    if (ABAddressBookCreateWithOptions == NULL)
//    {
////        address_book = ABAddressBookCreate();
//    }
//    else
//    {
        address_book = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if (status != kABAuthorizationStatusAuthorized)
        {
            ABAddressBookRequestAccessWithCompletion(address_book, ^(bool granted, CFErrorRef error)
                                                     {
                                                         if (granted)
                                                         {
                                                             NSMutableArray *contacts = [Contact getAddressBook:address_book];
                                                             delegate(contacts);
                                                         }
                                                     });
            return;
        }
//    };
    
    delegate([Contact getAddressBook:address_book]);
}

+ (NSMutableArray *) getAddressBook: (ABAddressBookRef) address_book
{
    NSMutableArray *contacts = [[[NSMutableArray alloc] init] autorelease];
    
    CFArrayRef people  = ABAddressBookCopyArrayOfAllPeople(address_book);
    
    for(int i = 0; i< ABAddressBookGetPersonCount(address_book); i++)
    {
        ABRecordRef ref = CFArrayGetValueAtIndex(people, i);
        
        NSString *firstName = (NSString *)ABRecordCopyValue(ref,kABPersonFirstNameProperty);
        NSString *lastName = (NSString *)ABRecordCopyValue(ref,kABPersonLastNameProperty);
        
        ABMultiValueRef phones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        
        for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
        {
            CFTypeRef phone = ABMultiValueCopyValueAtIndex(phones, j);
            
            Contact *ct = [[Contact alloc] initWithPhone:(NSString *)phone andFirstName:firstName andLastName:lastName];
            [contacts addObject:ct];
            [ct release];
            
            CFRelease(phone);
        }
        
        CFRelease(phones);
        [firstName release];
        [lastName release];
    }
    
    [contacts sortUsingSelector:@selector(compare:)];
    [((NSArray *)people) release];
    [((NSArray *)address_book) release];
    
    return contacts;
}

+ (BOOL)kiemTraQuyenLayDanhBa
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status != kABAuthorizationStatusAuthorized)
    {
        __block BOOL *_granted = NO;
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     _granted = granted;
                                                 });
        return _granted;
    }
    return YES;
}

+ (NSDictionary*)layDictDanhSachTaiKhoan
{
    if([Contact kiemTraQuyenLayDanhBa])
    {
        NSString *sThoiGianLuuDict = @"";
        NSDictionary *dict = [Contact layDictDanhSachTaiKhoanTuRMS:&sThoiGianLuuDict];
        if(dict && sThoiGianLuuDict)
        {
            if([Contact kiemTraDuThoiGianDeCapNhatDictTaiKhoan:[sThoiGianLuuDict doubleValue]])
            {
                return [Contact capNhatDictDanhSachTaiKhoan:dict];
            }
            return dict;
        }
        return [Contact capNhatDictDanhSachTaiKhoan:@{}];
    }
    return nil;
}

+ (BOOL)kiemTraDuThoiGianDeCapNhatDictTaiKhoan:(NSTimeInterval)fThoiGian
{
    NSTimeInterval fThoiGianHienTai = [[NSDate date] timeIntervalSince1970];
    if(fThoiGianHienTai > fThoiGian + 12*3600)
    {
        return YES;
    }
    return NO;
}

+ (void)luuDictDanhSachTaiKhoanXuongRMS:(NSDictionary*)dictDanhSachTaiKhoan
{
    NSMutableDictionary *tempDict = [[[NSMutableDictionary alloc] init] autorelease];
    for(NSString *sKey in [dictDanhSachTaiKhoan allKeys])
    {
        Contact *contact = [dictDanhSachTaiKhoan valueForKey:sKey];
        [tempDict setValue:[[contact toDictionary] JSONString] forKey:sKey];
    }
    
    NSString *value = [tempDict JSONString];
    NSTimeInterval fThoiGianHienTai = [[NSDate date] timeIntervalSince1970];
    NSString *sKey = [NSString stringWithFormat:@"%f", fThoiGianHienTai];
    NSDictionary *dictLuu = @{sKey : value};
    [DucNT_LuuRMS luuThongTinTrongRMSTheoKey:KEY_LUU_DANH_SACH_CONTACT_1 value:dictLuu];
}


+ (NSDictionary*)layDictDanhSachTaiKhoanTuRMS:(NSString**)ThoiGianLuuDict
{
    NSDictionary *tempDict = [DucNT_LuuRMS layThongTinTrongRMSTheoKey:KEY_LUU_DANH_SACH_CONTACT_1];
    if(tempDict)
    {
        NSString *sKey = [[tempDict allKeys] objectAtIndex:0];
        if(sKey)
        {
            *ThoiGianLuuDict = sKey;
//            NSLog(@"%s - tempDict : %@", __FUNCTION__, tempDict);
            NSDictionary *dict = [[tempDict valueForKey:sKey] objectFromJSONString];
            NSMutableDictionary *dictTraVe = [[[NSMutableDictionary alloc] init] autorelease];
            for(NSString *sKey in [dict allKeys])
            {
                NSString *jsonStringContact = [dict valueForKey:sKey];
                Contact *contact = [[Contact alloc] initWithDict:[jsonStringContact objectFromJSONString]];
                [dictTraVe setValue:contact forKey:sKey];
            }
            return [NSDictionary dictionaryWithDictionary:dictTraVe];
        }
    }
    return nil;
}

+ (NSDictionary*)capNhatDictDanhSachTaiKhoan:(NSDictionary*)dictDanhSachTaiKhoan
{
    if(dictDanhSachTaiKhoan)
    {
        NSDictionary *newDictDsTaiKhoanTuDanhBa = [Contact layDictDanhSachTaiKhoanChuaCoViTuDanhBa:dictDanhSachTaiKhoan];
        NSDictionary *newDictDsTaiKhoanTuServer = [Contact capNhatDictTaiKhoanTuServer:newDictDsTaiKhoanTuDanhBa];
        
        return newDictDsTaiKhoanTuServer;
    }
    return nil;
}

+ (NSDictionary*)layDictDanhSachTaiKhoanChuaCoViTuDanhBa:(NSDictionary*)dictDanhSachTaiKhoan
{
    if(dictDanhSachTaiKhoan)
    {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dictDanhSachTaiKhoan];
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        if(addressBook != NULL)
        {
            CFArrayRef people  = ABAddressBookCopyArrayOfAllPeople(addressBook);
            for(int i = 0; i< ABAddressBookGetPersonCount(addressBook); i++)
            {
                ABRecordRef ref = CFArrayGetValueAtIndex(people, i);
                ABRecordID recordID = ABRecordGetRecordID(ref);
                NSString *firstName = (NSString *)ABRecordCopyValue(ref,kABPersonFirstNameProperty);
                NSString *lastName = (NSString *)ABRecordCopyValue(ref,kABPersonLastNameProperty);
                ABMultiValueRef phones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
                for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
                {
                    CFTypeRef phone = ABMultiValueCopyValueAtIndex(phones, j);
                    NSString *_phone = [(NSString*)phone stringByReplacingOccurrencesOfString:@"+84" withString:@"0"];
                    _phone = [_phone stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [_phone length])];
                    if (_phone.length > 0 && [Common kiemTraLaSoDienThoai:_phone])
                    {
                        Contact *contact = [tempDict valueForKey:_phone];
                        if(!contact)
                        {
                            Contact *newContact = [[Contact alloc] initWithPhone:_phone
                                                                       firstName:firstName
                                                                        lastName:lastName
                                                                        recordID:recordID];
                            [tempDict setValue:newContact forKey:_phone];
                        }
                        else
                        {
                            contact.firstName = firstName;
                            contact.lastName = lastName;
                            contact.recordID = recordID;
                        }
                    }
                    
                    CFRelease(phone);
                }
//                ABMultiValueRef emails = ABRecordCopyValue(ref, kABPersonEmailProperty);
//                for(CFIndex j = 0; j < ABMultiValueGetCount(emails); j++)
//                {
//                    CFTypeRef email = ABMultiValueCopyValueAtIndex(emails, j);
//                    NSString *sEmail = [(NSString*)email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                    if(sEmail.length > 0)
//                    {
//                        @try {
//                            Contact *contact = [tempDict valueForKey:sEmail];
//                            if(!contact)
//                            {
//                                Contact *newContact = [[Contact alloc] initWithPhone:sEmail
//                                                                           firstName:firstName
//                                                                            lastName:lastName
//                                                                            recordID:recordID];
//                                [tempDict setValue:newContact forKey:sEmail];
//                            }
//                            else
//                            {
//                                contact.firstName = firstName;
//                                contact.lastName = lastName;
//                                contact.recordID = recordID;
//                            }
//                        } @catch (NSException *exception) {
//                            NSLog(@"%s - %@", __FUNCTION__, exception.reason);
//                        } @finally {
//                            NSLog(@"%s - Finally condition", __FUNCTION__);
//                        }
//
//                    }
//                    CFRelease(email);
//                }
                
                CFRelease(phones);
//                CFRelease(emails);
                
                [firstName release];
                [lastName release];
            }

            CFRelease(people);
            return tempDict;
        }
    }
    return nil;
}

+ (NSDictionary*)capNhatDictTaiKhoanTuServer:(NSDictionary*)dictDanhSachTaiKhoan
{
    if(dictDanhSachTaiKhoan)
    {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dictDanhSachTaiKhoan];
        NSMutableArray *danhSachIdGuiLenServer = [[[NSMutableArray alloc] init] autorelease];
        for(Contact *contact in [dictDanhSachTaiKhoan allValues])
        {
            if(!contact.hasAccount)
            {
                NSDictionary *dict = @{
                                       @"idVi"  : contact.phone,
                                       @"status": [NSNumber numberWithBool:contact.hasAccount]
                                       };
                [danhSachIdGuiLenServer addObject:dict];
            }
        }
        
        NSArray *danhSachTuSerVer = [Contact ketNoiLayDanhSachTaiKhoanDaDangKy:danhSachIdGuiLenServer];
        
        if(danhSachTuSerVer)
        {
            for(NSDictionary *dictTaiKhoan in danhSachTuSerVer)
            {
                bool status = [[dictTaiKhoan valueForKey:@"status"] boolValue];
                NSString *sIDVi = [dictTaiKhoan valueForKey:@"idVi"];
                NSArray *dsIdVi = [dictTaiKhoan valueForKey:@"dsIdVi"];
                
                Contact *contact = [tempDict valueForKey:sIDVi];
                if(contact)
                {
                    if([Common kiemTraLaSoDienThoai:contact.phone])
                    {
                        contact.hasAccount = status;
                    }
                    else
                    {
                        for(NSString *idVi in dsIdVi)
                        {
                            //neu da con contact trong temp dict thi chi thay doi trang thai hasAccount
                            Contact *contact1 = [tempDict valueForKey:idVi];
                            if(!contact1)
                            {
                                Contact *newContact = [[Contact alloc] initWithPhone:idVi
                                                                           firstName:contact.firstName
                                                                            lastName:contact.lastName
                                                                            recordID:contact.recordID];
                                newContact.hasAccount = status;
                                [tempDict setValue:newContact forKey:idVi];
                            }
                            else
                            {
                                contact1.hasAccount = status;
                            }
                        }
                    }
                }
            }
            [Contact luuDictDanhSachTaiKhoanXuongRMS:tempDict];
        }
        return tempDict;
    }
    return nil;
}

+ (NSArray*)ketNoiLayDanhSachTaiKhoanDaDangKy:(NSArray*)dsTaiKhoanTheoDinhDangServer
{
    NSMutableDictionary *dictGuiLenServer = [[[NSMutableDictionary alloc] init] autorelease];
    [dictGuiLenServer setObject:dsTaiKhoanTheoDinhDangServer forKey:@"dsTaiKhoan"];
    NSString *sNoiDungGuiLenServer = [dictGuiLenServer JSONString];
    NSURL *url = [NSURL URLWithString:URL_KIEM_TRA_TAI_KHOAN_CO_VI];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[sNoiDungGuiLenServer length]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //Thoi gian time out
    //    request.timeoutInterval = 60;
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[sNoiDungGuiLenServer dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    NSURLResponse *response = nil;
    NSError *err = nil;
    
    //Send the Request
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if(!err)
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if((long)[httpResponse statusCode] == 200)
        {
            NSDictionary *ketQuaTraVe = [returnData objectFromJSONData];
            //            NSLog(@"Debug:%@: %@, ketQuaTraVe : %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd), ketQuaTraVe);
            int nCode = [[ketQuaTraVe valueForKey:@"msgCode"] intValue];
            if(nCode == 1)
            {
                NSDictionary *result = [ketQuaTraVe valueForKey:@"result"];
                NSArray *dsTaiKhoan = [result valueForKey:@"dsTaiKhoan"];
                NSArray *arrTraVe = [NSArray arrayWithArray:dsTaiKhoan];
                return arrTraVe;
            }
        }
    }
    else
    {
        NSLog(@"Debug:%@: %@, err : %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd), err.localizedDescription);
    }
    
    return nil;
}



@synthesize firstName;
@synthesize lastName;
@synthesize phone = _phone;
@synthesize hasAccount;
@synthesize recordID;
@end
