//
//  MapAnnotation.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 11/13/12.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
