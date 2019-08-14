//
//  UpdateLocation.m
//  ViMASS
//
//  Created by Chung NV on 11/19/13.
//
//

#import "UpdateLocation.h"

@implementation UpdateLocation
{
    
}
-(void)start
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 0.1;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    NSLog(@"UpdateLocation : lat = %f - lng = %f",location.coordinate.latitude,location.coordinate.longitude);
}
@end
