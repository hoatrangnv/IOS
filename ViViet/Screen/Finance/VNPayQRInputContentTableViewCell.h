//
//  VNPayQRInputContentTableViewCell.h
//  ViViMASS
//
//  Created by Nguyen Van Tam on 4/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VNPayQRInputContentTableViewCell : UITableViewCell <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *lblContent;

@end

NS_ASSUME_NONNULL_END
