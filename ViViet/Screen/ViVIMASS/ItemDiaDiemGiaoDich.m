//
//  ItemDiaDiemGiaoDich.m
//  ViViMASS
//
//  Created by nguyen tam on 8/28/15.
//
//

#import "ItemDiaDiemGiaoDich.h"
#import <AddressBook/AddressBook.h>

@interface ItemDiaDiemGiaoDich()
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

@end

@implementation ItemDiaDiemGiaoDich

- (void)taoThongTinDiaDiem:(NSDictionary *)dicDiaDiem{
    self.name = [dicDiaDiem objectForKey:@"name"];
    self.address = [dicDiaDiem objectForKey:@"address"];
    NSNumber *lat = [dicDiaDiem objectForKey:@"latitude"];
    self.latitude = [lat doubleValue];
    NSNumber *lng = [dicDiaDiem objectForKey:@"longtitude"];
    self.longtitude = [lng doubleValue];
    NSArray *arrCate = [dicDiaDiem objectForKey:@"categories"];
    self.categoryId = [[arrCate objectAtIndex:0] intValue];
    
    NSString *khoangCach = [dicDiaDiem valueForKey:@"distance"];
    self.distance = khoangCach;
    NSString *sAudio = [dicDiaDiem valueForKey:@"audio"];
    self.audio = sAudio;
    NSString *sPhone = [dicDiaDiem valueForKey:@"phone"];
    self.phone = sPhone;
    CLLocationCoordinate2D location;
    location.latitude = self.latitude;
    location.longitude = self.longtitude;
    self.theCoordinate = location;
}

- (NSString *)title{
    return self.name;
}

- (NSString *)subtitle{
    return self.address;
}

- (CLLocationCoordinate2D)coordinate{
    return self.theCoordinate;
}

- (MKMapItem*)mapItem{
    NSDictionary *dic = @{(NSString *)kABPersonAddressStreetKey:_address};
    MKPlacemark *pm = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:dic];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:pm];
    mapItem.name = self.name;
    return mapItem;
}

@end
