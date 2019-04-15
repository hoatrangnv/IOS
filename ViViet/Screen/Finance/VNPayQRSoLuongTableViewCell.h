//
//  VNPayQRSoLuongTableViewCell.h
//  ViViMASS
//
//  Created by Nguyen Van Tam on 4/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VNPayQRSoLuongTableViewCellDelegate
- (void)suKienTangSoLuong:(int)nSoLuong;
- (void)suKienGiamSoLuong:(int)nSoLuong;
@end

@interface VNPayQRSoLuongTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIButton *btnTru;
@property (retain, nonatomic) IBOutlet UIButton *btnCong;
@property (retain, nonatomic) IBOutlet UILabel *lblSoLuong;
@property (retain, nonatomic) IBOutlet UILabel *lblDonGia;
@property (retain, nonatomic) IBOutlet UILabel *lblTitleSoLuong;
@property (assign, nonatomic) id <VNPayQRSoLuongTableViewCellDelegate> delegate;

- (void)setSoTien:(NSString *)amount;
- (int)getSoLuong;
@end

NS_ASSUME_NONNULL_END
