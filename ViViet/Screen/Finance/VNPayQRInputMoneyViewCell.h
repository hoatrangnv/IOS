//
//  VNPayQRInputMoneyViewCell.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/27/19.
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
NS_ASSUME_NONNULL_BEGIN

@interface VNPayQRInputMoneyViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UITextField *tfSoTien;
@property (retain, nonatomic) IBOutlet UILabel *lblPhi;
- (void)setIsNhapTien:(BOOL)isNhap;
@end

NS_ASSUME_NONNULL_END
