//
//  Globals.h
//  ViMASS
//
//  Created by QUANGHIEP on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Globals : NSObject
{
//    NSDictionary *languages;
}
@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *accountNo;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, retain) NSDictionary *languages;
@property (nonatomic, retain) NSArray *contacts;
@property (nonatomic, retain) NSArray *mDanhSachLienHeDaCoVi;

@property (nonatomic, retain) NSDictionary *mDictDanhSachLienHe;

@property (nonatomic, assign) BOOL loadContactSuccess;
- (void) loadLaguages:(NSString *)_lagName;

- (void)loadContacts;

- (void)refreshContacts;

@end
