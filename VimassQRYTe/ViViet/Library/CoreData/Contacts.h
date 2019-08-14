//
//  Contacts.h
//  ViMASS
//
//  Created by Quang Hiep on 10/2/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contacts : NSManagedObject

@property (nonatomic, retain) NSString * accountName;
@property (nonatomic, retain) NSString * accountNo;
@property (nonatomic, retain) NSString * isMobileApp;
@property (nonatomic, retain) NSString * isVivietAcc;
@property (nonatomic, retain) NSString * isFavourite;

@end
