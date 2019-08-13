//
//  MapAnnotation.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 11/13/12.
//
//

#import "MapAnnotation.h"

@implementation MapAnnotation

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

@synthesize coordinate = _coordinate, title, subtitle;

@end
