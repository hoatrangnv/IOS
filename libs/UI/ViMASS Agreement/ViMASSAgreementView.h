//
//  ViMASSAgreementView.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 10/15/13.
//
//

#import <UIKit/UIKit.h>
#import "BaseScreen.h"
#import "UmiCheckBox.h"

@interface ViMASSAgreementView : UIView <UIWebViewDelegate>
{
    IBOutlet UmiCheckBox *v_agree;
    IBOutlet UIWebView *v_agreement;
    NSString *agreement;
}

@property (nonatomic, copy) NSString *agreement;
@property (nonatomic, assign) IBOutlet BaseScreen *controller;
@property (nonatomic, readonly) BOOL agree;

@end
