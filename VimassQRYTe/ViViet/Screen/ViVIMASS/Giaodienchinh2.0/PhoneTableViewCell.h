//
//  PhoneTableViewCell.h
//  ViViMASS
//
//  Created by Mac Mini on 10/2/18.
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
@protocol PhoneTableViewCellChangeMoneyDelegate <NSObject>
- (void)didChangeMoney;
@end
@class MoneyContact;

@interface PhoneTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (retain, nonatomic) IBOutlet UILabel *lbName;
@property (retain, nonatomic) IBOutlet UILabel *lbPhone;
@property (retain, nonatomic) IBOutlet UIImageView *imgVi;
@property (retain, nonatomic) IBOutlet ExTextField *txtMoney;
@property (retain, nonatomic) IBOutlet UIButton *btnRemove;
@property (strong, nonatomic) MoneyContact *moneyContact;
@property (assign, nonatomic) id<PhoneTableViewCellChangeMoneyDelegate> delegate;
@end



