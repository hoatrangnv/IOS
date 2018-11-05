//
//  IDPhotoCaptureView.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 6/26/13.
//
//

#import "IDPhotoCaptureView.h"

@implementation IDPhotoCaptureView

- (void)dealloc {
    [v_front release];
    [v_back release];
    [super dealloc];
}
@end
