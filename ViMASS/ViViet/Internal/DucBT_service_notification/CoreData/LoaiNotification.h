//
//  LoaiNotification.h
//  ViMASS
//
//  Created by DucBT on 10/1/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Notification, TaiKhoan;

@interface LoaiNotification : NSManagedObject

@property (nonatomic, retain) NSNumber * nKieu;
@property (nonatomic, retain) NSNumber * nThoiGianDocGanNhat;
@property (nonatomic, retain) NSString * sTenLoai;
@property (nonatomic, retain) NSSet *notifications;
@property (nonatomic, retain) TaiKhoan *taiKhoan;
@end

@interface LoaiNotification (CoreDataGeneratedAccessors)

- (void)addNotificationsObject:(Notification *)value;
- (void)removeNotificationsObject:(Notification *)value;
- (void)addNotifications:(NSSet *)values;
- (void)removeNotifications:(NSSet *)values;

@end
