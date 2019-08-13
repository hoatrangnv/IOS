//
//  RegisterTokenViewController.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/20/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseScreen.h"
#import "ExTextField.h"

@interface RegisterTokenViewController : BaseScreen<UITextFieldDelegate>
{
    IBOutlet ExTextField *txtSerial;
    IBOutlet ExTextField *txtToken;
    IBOutletCollection(ExTextField) NSArray *textFields;
}
+ (RegisterTokenViewController *)create;

- (IBAction)didSelectRegister;

@end
