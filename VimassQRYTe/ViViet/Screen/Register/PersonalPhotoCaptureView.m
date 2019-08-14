//
//  PersonalPhotoCaptureView.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 6/25/13.
//
//

#import "PersonalPhotoCaptureView.h"
#import "AppDelegate.h"
#import "BaseScreen.h"

@implementation PersonalPhotoCaptureView
{
    bool initialized;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    if (initialized)
        return;
    
    initialized = true;
}

- (void)dealloc {
    [v_avatar release];
    [v_sig1 release];
    [v_sig2 release];
    [v_notiway release];
    [v_agree release];
    [v_web release];
    [super dealloc];
}
@end
