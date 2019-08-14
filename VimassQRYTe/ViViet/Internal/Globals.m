//
//  Globals.m
//  ViMASS
//
//  Created by QUANGHIEP on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Globals.h"
#import "PhoneContacts.h"
#import "TestFlight.h"

@implementation Globals

@synthesize languages, contacts, account, password;
@synthesize accountName, balance, accountNo;

#pragma mark - Init
-(void)dealloc
{
    if(_mDanhSachLienHeDaCoVi)
        [_mDanhSachLienHeDaCoVi release];
    if(_mDictDanhSachLienHe)
        [_mDictDanhSachLienHe release];
    [accountNo release];
    [password release];
    [languages release];
    [contacts release];
    [account release];
    [accountName release];
    [balance release];
    languages = nil;
    [super dealloc];
}
- (id) init
{
    if (self = [super init])
    {
        self.loadContactSuccess = NO;
    }
    
    return self;
}

- (void) loadLaguages:(NSString *)_lagName
{
    if (_lagName == nil) {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Vietnamese" ofType:@"plist"];
        languages = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    else {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Vietnamese" ofType:@"plist"];
        languages = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
}

- (void)loadContacts
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(thread_loadContact_success:) name: @"thread_loadContact"
                                               object: nil];
    
    NSDictionary *dict = [Contact layDictDanhSachTaiKhoan];
    if(dict)
    {
        self.mDictDanhSachLienHe = dict;
        
        self.contacts = [dict allValues];
        
        NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithCapacity:self.contacts.count];
        for(Contact *contact in contacts)
        {
            if(contact.hasAccount) {
                if ([contact.phone hasPrefix:@"09"] || [contact.phone hasPrefix:@"01"] || [contact.phone hasPrefix:@"088"] || [contact.phone hasPrefix:@"089"] || [contact.phone hasPrefix:@"086"] || [self NSStringIsValidEmail:contact.phone]) {
                    [arrTemp addObject:contact];
                }
            }
        }
        
        self.mDanhSachLienHeDaCoVi = arrTemp;
        [arrTemp release];
    }
    else
    {
        self.mDictDanhSachLienHe = [NSDictionary dictionary];
        self.contacts = [NSArray array];
        self.mDanhSachLienHeDaCoVi = [NSArray array];
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)refreshContacts
{
    NSDictionary *dict = [Contact capNhatDictDanhSachTaiKhoan:self.mDictDanhSachLienHe];
    if(dict)
    {
        self.mDictDanhSachLienHe = dict;
        
        self.contacts = [dict allValues];
        NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithCapacity:self.contacts.count];
        for(Contact *contact in contacts)
        {
            if(contact.hasAccount) {
                NSLog(@"%s - phone : %@", __FUNCTION__, contact.phone);
                if ([contact.phone hasPrefix:@"09"] || [contact.phone hasPrefix:@"01"] || [contact.phone hasPrefix:@"088"] || [contact.phone hasPrefix:@"089"] || [contact.phone hasPrefix:@"086"] || [self NSStringIsValidEmail:contact.phone]) {
                    [arrTemp addObject:contact];
                }
            }
//            if(contact.hasAccount)
//                [arrTemp addObject:contact];
        }
        self.mDanhSachLienHeDaCoVi = arrTemp;
        [arrTemp release];
    }
    else
    {
        self.contacts = [NSArray array];
        self.mDanhSachLienHeDaCoVi = [NSArray array];
    }
}

-(void)thread_loadContact_success:(NSNotification *)noti
{
    self.loadContactSuccess = YES;
}

@end
