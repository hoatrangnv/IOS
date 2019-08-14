//
//  Notification.h
//  ViMASS
//
//  Created by DucBT on 10/15/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LoaiNotification;

@interface Notification : NSManagedObject

@property (nonatomic, retain) NSString * alert;
@property (nonatomic, retain) NSString * alertContent;
@property (nonatomic, retain) NSString * alertID;
@property (nonatomic, retain) NSNumber * appID;
@property (nonatomic, retain) NSNumber * daXoa;
@property (nonatomic, retain) NSNumber * funcID;
@property (nonatomic, retain) NSNumber * isSended;
@property (nonatomic, retain) NSNumber * readed;
@property (nonatomic, retain) NSString * recipient;
@property (nonatomic, retain) NSNumber * send;
@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) LoaiNotification *loaiNotification;

@end
