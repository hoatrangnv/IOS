//
//  TaiKhoan.h
//  ViMASS
//
//  Created by DucBT on 10/1/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LoaiNotification;

@interface TaiKhoan : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *loaiNotifications;
@end

@interface TaiKhoan (CoreDataGeneratedAccessors)

- (void)addLoaiNotificationsObject:(LoaiNotification *)value;
- (void)removeLoaiNotificationsObject:(LoaiNotification *)value;
- (void)addLoaiNotifications:(NSSet *)values;
- (void)removeLoaiNotifications:(NSSet *)values;

@end
