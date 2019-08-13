//
//  PersonalPhotoCaptureView.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 6/25/13.
//
//

#import <UIKit/UIKit.h>
#import "BPButton.h"
#import "CNVCheckBox.h"
#import "UmiRadioGroup.h"

@interface PersonalPhotoCaptureView : UIView
{
    @public
    IBOutlet UIImageView *v_avatar;
    
    @public
    IBOutlet UIImageView *v_sig1;
    
    @public
    IBOutlet UIImageView *v_sig2;
    
    @public
    IBOutlet UmiRadioGroup *v_notiway;
    
    @public
    IBOutlet CNVCheckBox *v_agree;
    IBOutlet UIWebView *v_web;
}

@end
