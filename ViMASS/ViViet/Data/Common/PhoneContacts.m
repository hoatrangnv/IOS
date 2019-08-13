//
//  PhoneContacts.m
//  testPhoneContact
//
//  Created by QUANGHIEP on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhoneContacts.h"

#pragma mark
#pragma mark PhoneContacts
@implementation PhoneContacts

+ (NSMutableArray *) getListPhoneNumber
{
    NSMutableArray *dataToReturn = [[NSMutableArray alloc] init];
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef people  = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for(int i = 0;i<ABAddressBookGetPersonCount(addressBook);i++)
    {
        ABRecordRef ref = CFArrayGetValueAtIndex(people, i);
        ABMultiValueRef phones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        NSString *firstName = (NSString *)ABRecordCopyValue(ref,kABPersonFirstNameProperty);
        NSString *lastName = (NSString *)ABRecordCopyValue(ref,kABPersonLastNameProperty);
        NSString * fullName;
        if (firstName == nil && lastName != nil) {
            fullName = lastName;
        }
        else if(firstName != nil && lastName == nil)
        {
            fullName = firstName;
        }
        else if (firstName == nil && lastName == nil) {
            fullName = @"Unnamed";
        }
        else {
            fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        }
        
        for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
        {       
            ABMultiValueCopyValueAtIndex(phones, j);
            CFTypeRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j); 
//            NSString *phoneLabel =(NSString*) ABAddressBookCopyLocalizedLabel (ABMultiValueCopyLabelAtIndex(phones, j));
            NSString *phoneLabel = fullName;
            NSString *phoneNumber = (NSString *)phoneNumberRef; 
            Contact *contact = [[Contact alloc] initWithTitle:phoneLabel andPhoneNumber:phoneNumber]; 
            [dataToReturn addObject:contact];
            [contact release];
        }
    }
    return dataToReturn;
}
@end
