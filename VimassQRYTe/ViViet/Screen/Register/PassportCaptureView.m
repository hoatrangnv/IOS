//
//  PassportCaptureView.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 6/27/13.
//
//

#import "PassportCaptureView.h"

@implementation PassportCaptureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [v_passport release];
    [super dealloc];
}
@end
