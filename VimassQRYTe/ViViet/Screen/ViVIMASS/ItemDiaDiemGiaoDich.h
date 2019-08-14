//
//  ItemDiaDiemGiaoDich.h
//  ViViMASS
//
//  Created by nguyen tam on 8/28/15.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ItemDiaDiemGiaoDich : NSObject<MKAnnotation>

@property(nonatomic, copy) NSString* name;
@property(nonatomic, copy) NSString* address;
@property(nonatomic, copy) NSString* audio;
@property(nonatomic, copy) NSString* phone;
@property(nonatomic) double longtitude;
@property(nonatomic) double latitude;
@property(nonatomic, copy) NSString* distance;
@property(nonatomic) int categoryId;
- (void)taoThongTinDiaDiem:(NSDictionary *)dicDiaDiem;
- (MKMapItem*)mapItem;
@end
