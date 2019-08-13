//
//  WithdrawViewController.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/3/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseScreen.h"
#import "BalanceView.h"
#import "AmountTextField.h"

@interface WithdrawViewController : BaseScreen<UITextFieldDelegate>
{
    IBOutlet UILabel *lb_amount;
    
    IBOutlet AmountTextField *txtAmount;
    IBOutlet UILabel *lb_amount_title;
    
    IBOutlet UIView *viewToken;
    IBOutlet ExTextField *txtToken;
    IBOutlet UIButton *btnWithdraw;
}

- (IBAction)didSelectWithdraw:(id)sender;
- (void)setNeedToken:(BOOL)need;

@end
