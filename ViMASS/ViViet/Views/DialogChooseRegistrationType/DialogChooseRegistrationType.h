//
//  DialogChooseRegistrationType.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 8/6/13.
//
//

#import <UIKit/UIKit.h>

@interface DialogChooseRegistrationType : UIView
{
    IBOutletCollection(UIButton) NSArray *btns;
    IBOutlet UIImageView *v_checkmark;
    
}
- (IBAction)OK;
- (IBAction)Cancel;
- (IBAction)did_select_wallet:(id)sender;

+(DialogChooseRegistrationType *)showin:(UIView *)showinview action:(void (^)(int))callback;
@property (nonatomic, retain) NSMutableArray *viewToText;

@end
