//
//  VPersonalProfile.h
//  commonlib
//
//  Created by Ngo Ba Thuong on 9/26/13.
//  Copyright (c) 2013 ViMASS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIPersonalProfile : NSObject

@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL foreign;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *DOB;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *DOI;
@property (nonatomic, copy) NSString *POI;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *SQID;
@property (nonatomic, copy) NSString *SA;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, retain) NSData *id1;
@property (nonatomic, retain) NSData *id2;
@property (nonatomic, retain) NSData *passport;
@property (nonatomic, retain) NSData *photo;
@property (nonatomic, retain) NSData *sig;

@end
