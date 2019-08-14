//
//  PhoneTableViewCell.m
//  ViViMASS
//
//  Created by Mac Mini on 10/2/18.
//

#import "PhoneTableViewCell.h"
#import "Common.h"
#import "MoneyContact.h"
@implementation PhoneTableViewCell
@synthesize delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imgAvatar.layer.cornerRadius = 20.0;
    _imgAvatar.clipsToBounds = true;
    _txtMoney.keyboardType = UIKeyboardTypeNumberPad;
    [_txtMoney sizeToFit];
    self.txtMoney.adjustsFontSizeToFitWidth = YES; self.txtMoney.minimumFontSize = 10.0; //Optionally specify min size

}

- (IBAction)moneyChanged:(id)sender {
    NSString *sSoTien = [_txtMoney.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    _txtMoney.text = [Common hienThiTienTeFromString:sSoTien];
    _moneyContact.money = sSoTien;
    [_txtMoney sizeToFit];
    if ([self.delegate respondsToSelector:@selector(didChangeMoney)]) {
        [self.delegate didChangeMoney];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_imgAvatar release];
    [_lbName release];
    [_lbPhone release];
    [_imgVi release];
    [_txtMoney release];
    [_btnRemove release];
    [delegate release];
    [super dealloc];
}
@end
