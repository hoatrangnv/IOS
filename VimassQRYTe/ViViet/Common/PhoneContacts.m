//
//  PhoneContacts.m
//  testPhoneContact
//
//  Created by QUANGHIEP on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhoneContacts.h"
#import "Globals.h"
#import "JSONKit.h"
#import "Common.h"
#import "DucNT_LuuRMS.h"
#import "Contact.h"

#pragma mark
#pragma mark PhoneContacts


#define LINK_KIEM_TRA_ACC_DA_THUOC_DANH_BA @"https://vimass.vn/vmbank/services/account/checkAccount"

ABAddressBookRef addressBook = NULL;
@implementation PhoneContacts

+(UIImage*)getAvatarByRecordID:(ABRecordID) recordID
{
    ABRecordRef ref =  ABAddressBookGetPersonWithRecordID(addressBook,recordID);
    UIImage *avatar = [UIImage imageWithData:((NSData*)ABPersonCopyImageDataWithFormat(ref,kABPersonImageFormatThumbnail))];
    return avatar;
}

+ (NSArray*) getPhones: (ABAddressBookRef) addressBook
{
    NSArray *returnArray = nil;
    returnArray = [PhoneContacts layDanhSachTaiKhoanTrongRMS:addressBook];
    if(!returnArray)
    {
        NSArray *dsTaiKhoanTrongDanhBa = [PhoneContacts layDanhSachTaiKhoanTrongDanhBa:addressBook];
        NSArray *dsTaiKhoanSauKiemTra = [PhoneContacts kiemTraDaCoTaiKhoan:dsTaiKhoanTrongDanhBa];
        if(dsTaiKhoanSauKiemTra && dsTaiKhoanSauKiemTra.count > 0)
        {
            //Luu vao RMS
            [PhoneContacts luuDanhSachTaiKhoanXuongRMS:dsTaiKhoanSauKiemTra];
            return dsTaiKhoanSauKiemTra;
        }
        else
        {
            //Loc ra so dien thoai de tra ve
            NSMutableArray *arrTraVe = [[[NSMutableArray alloc] init] autorelease];
            for(Contact *contact in dsTaiKhoanTrongDanhBa)
            {
                if(![arrTraVe containsObject:contact])
                    [arrTraVe addObject:contact];
            }
            return arrTraVe;
        }
    }
    return returnArray;
}

+ (NSArray*)layDanhSachTaiKhoanTrongRMS:(ABAddressBookRef)addressBook
{
    NSDictionary *dictTaiKhoan = [DucNT_LuuRMS layThongTinTrongRMSTheoKey:KEY_LUU_DANH_SACH_CONTACT];
    if(dictTaiKhoan)
    {
        NSArray *returnArray = nil;
        NSString *sKey = [[dictTaiKhoan allKeys] objectAtIndex:0];
        NSTimeInterval fThoiGianLuuDictTaiKhoan = [sKey doubleValue];
        NSTimeInterval fThoiGianHienTai = [[NSDate date] timeIntervalSince1970];
    
        if(fThoiGianHienTai > fThoiGianLuuDictTaiKhoan + 12*3600)
        {
            //Lay tai khoan dua len server kiem tra
            NSArray *dsTaiKhoanTrongDanhBa = [PhoneContacts layDanhSachTaiKhoanTrongDanhBa:addressBook];
            NSArray *dsTaiKhoanSauKiemTra = [PhoneContacts kiemTraDaCoTaiKhoan:dsTaiKhoanTrongDanhBa];
            if(dsTaiKhoanSauKiemTra && dsTaiKhoanSauKiemTra.count > 0)
            {
                [PhoneContacts luuDanhSachTaiKhoanXuongRMS:dsTaiKhoanSauKiemTra];
                return dsTaiKhoanSauKiemTra;
            }
        }
        NSArray *arrTemp = [[dictTaiKhoan objectForKey:sKey] objectFromJSONString];
        NSMutableArray *arrTemp2 = [[NSMutableArray alloc] initWithCapacity:arrTemp.count];
        for(NSDictionary *dict in arrTemp)
        {
            Contact *contact = [[Contact alloc] initWithDict:dict];
            [arrTemp2 addObject:contact];
            [contact release];
        }
        returnArray = [NSArray arrayWithArray:arrTemp2];
        [arrTemp2 release];
        return returnArray;
    }
    return nil;
}

+ (void)luuDanhSachTaiKhoanXuongRMS:(NSArray*)dsTaiKhoan
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for(Contact *contact in dsTaiKhoan)
    {
        NSDictionary *dict = [contact toDictionary];
        [arr addObject:dict];
    }
    
    NSString *value = [arr JSONString];
    NSTimeInterval fThoiGianHienTai = [[NSDate date] timeIntervalSince1970];
    NSString *sKey = [NSString stringWithFormat:@"%f", fThoiGianHienTai];
    NSDictionary *dictLuu = @{sKey : value};
    [DucNT_LuuRMS luuThongTinTrongRMSTheoKey:KEY_LUU_DANH_SACH_CONTACT value:dictLuu];
}

+ (NSArray*)kiemTraDaCoTaiKhoan:(NSArray*)contacts
{
    NSMutableArray *danhSachConTactGuiLenServer = [[[NSMutableArray alloc] initWithCapacity:contacts.count] autorelease];
    for(Contact *contact in contacts)
    {
        NSDictionary *dict = @{
                               @"idVi"  : contact.phone,
                               @"status": [NSNumber numberWithBool:NO]
                               };
        [danhSachConTactGuiLenServer addObject:dict];
    }

    NSArray *danhSachTuSerVer = [PhoneContacts ketNoiLayDanhSachTaiKhoanDaDangKy:danhSachConTactGuiLenServer];

    if(danhSachTuSerVer)
    {
        NSMutableArray *dsTaiKhoan = [[NSMutableArray alloc] init];
        for(Contact *contact in contacts)
        {
            BOOL hasAccount = NO;
            for(NSDictionary *dictTaiKhoan in danhSachTuSerVer)
            {
                bool status = [[dictTaiKhoan valueForKey:@"status"] boolValue];
                NSString *sIDVi = [dictTaiKhoan valueForKey:@"idVi"];
                NSArray *dsIdVi = [dictTaiKhoan valueForKey:@"dsIdVi"];
                
                if([sIDVi isEqualToString:contact.phone])
                {
                    hasAccount = YES;
                    if(dsIdVi.count > 0)
                    {
                        for(NSString *sID in dsIdVi)
                        {
                            Contact *ct = [[Contact alloc] initWithPhone:sID
                                                               firstName:contact.firstName
                                                                lastName:contact.lastName
                                                                recordID:contact.recordID];
                            ct.hasAccount = status;
                            if(![dsTaiKhoan containsObject:ct])
                                [dsTaiKhoan addObject:ct];
                            [ct release];
                        }
                    }
                    else
                    {
                        Contact *ct = [[Contact alloc] initWithPhone:sIDVi
                                                           firstName:contact.firstName
                                                            lastName:contact.lastName
                                                            recordID:contact.recordID];
                        ct.hasAccount = status;
                        if(![dsTaiKhoan containsObject:ct])
                            [dsTaiKhoan addObject:ct];
                        [ct release];
                    }
                }
            }
            
            if(!hasAccount)
            {
                if(![dsTaiKhoan containsObject:contact])
                    [dsTaiKhoan addObject:contact];
            }
        }
        NSArray *arrTraVe = [NSArray arrayWithArray:dsTaiKhoan];
        [dsTaiKhoan release];
        return arrTraVe;
    }
    return nil;
}


+ (NSArray*)ketNoiLayDanhSachTaiKhoanDaDangKy:(NSArray*)dsTaiKhoanTheoDinhDangServer
{
    NSMutableDictionary *dictGuiLenServer = [[[NSMutableDictionary alloc] init] autorelease];
    [dictGuiLenServer setObject:dsTaiKhoanTheoDinhDangServer forKey:@"dsTaiKhoan"];
    NSString *sNoiDungGuiLenServer = [dictGuiLenServer JSONString];
    NSURL *url = [NSURL URLWithString:LINK_KIEM_TRA_ACC_DA_THUOC_DANH_BA];
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
        NSLog(@"Debug:%@: %@, statusCode : %ld", NSStringFromClass([self class]),NSStringFromSelector(_cmd), (long)[httpResponse statusCode]);
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

+ (void) getListPhoneNumber: (NSArray**)contacts
{
    addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status != kABAuthorizationStatusAuthorized)
    {
        __block BOOL _granted = NO;
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     if (granted)
                                                     {
                                                         _granted = YES;
                                                     }
                                                 });
        
        if(_granted)
        {
            *contacts = [PhoneContacts getPhones:addressBook];
        }
    }
    else
        *contacts = [PhoneContacts getPhones:addressBook];
}

+ (NSArray*)layDanhSachTaiKhoanTrongDanhBa:(ABAddressBookRef) addressBook
{
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
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
                Contact *ct = [[Contact alloc] initWithPhone:_phone
                                                   firstName:firstName
                                                    lastName:lastName
                                                    recordID:recordID];
                if(![contacts containsObject:ct])
                    [contacts addObject:ct];
                [ct release];
            }
            
            CFRelease(phone);
        }
        ABMultiValueRef emails = ABRecordCopyValue(ref, kABPersonEmailProperty);
        for(CFIndex j = 0; j < ABMultiValueGetCount(emails); j++)
        {
            CFTypeRef email = ABMultiValueCopyValueAtIndex(emails, j);
            NSString *sEmail = [(NSString*)email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(sEmail.length > 0)
            {
                Contact *ct = [[Contact alloc] initWithPhone:sEmail
                                                   firstName:firstName
                                                    lastName:lastName
                                                    recordID:recordID];
                if(![contacts containsObject:ct])
                    [contacts addObject:ct];
                [ct release];
            }
            CFRelease(email);
        }
        
        CFRelease(phones);
        CFRelease(emails);

        [firstName release];
        [lastName release];
    }
    
    [contacts sortUsingSelector:@selector(compare:)];
    
    NSArray *returnArray = [NSArray arrayWithArray:contacts];
    [contacts release];
    CFRelease(people);
    return returnArray;
}


-(void)dealloc
{
    [((NSArray*)addressBook) release];
    [super dealloc];
}
@end
