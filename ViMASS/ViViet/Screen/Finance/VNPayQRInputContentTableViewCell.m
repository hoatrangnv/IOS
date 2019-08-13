//
//  VNPayQRInputContentTableViewCell.m
//  ViViMASS
//
//  Created by Nguyen Van Tam on 4/1/19.
//

#import "VNPayQRInputContentTableViewCell.h"

@implementation VNPayQRInputContentTableViewCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    _lblContent.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc {
    [_lblContent release];
    [super dealloc];
}
@end
