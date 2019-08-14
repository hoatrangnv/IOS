//
//  DangKyTheDaNangViewController.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 5/23/19.
//

#import "GiaoDichViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DangKyTheDaNangViewController : GiaoDichViewController
@property (retain, nonatomic) IBOutlet UIWebView *webDieuKhoan;
@property (retain, nonatomic) IBOutlet ExTextField *tfHoTen;
@property (retain, nonatomic) IBOutlet ExTextField *tfCMND;
@property (retain, nonatomic) IBOutlet ExTextField *tfNgaySinh;
@property (retain, nonatomic) IBOutlet ExTextField *tfEmail;
@property (retain, nonatomic) IBOutlet ExTextField *tfMatKhau;
@property (retain, nonatomic) IBOutlet ExTextField *tfNhacLaiMatKhau;
@property (retain, nonatomic) IBOutlet ExTextField *tfSoSeri;
- (IBAction)suKienChonDangKy:(id)sender;

@end

NS_ASSUME_NONNULL_END
