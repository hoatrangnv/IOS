//
//  QRSanPhamViewController.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/1/17.
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"
@interface QRSanPhamViewController : GiaoDichViewController
@property (nonatomic, retain) NSString *sTitle;
@property (nonatomic, retain) NSString *maDaiLy;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *viewXacThuc;
@property (retain, nonatomic) IBOutlet UIImageView *imgvQRPhongTo;
@property (retain, nonatomic) IBOutlet UIView *viewQRPhongTo;

- (IBAction)suKienChonXoaDV:(id)sender;
- (IBAction)suKienChonSuaDV:(id)sender;
- (IBAction)suKienChonThemSP:(id)sender;
- (IBAction)suKienAnViewXacThuc:(id)sender;
- (IBAction)suKienDongViewQR:(id)sender;

@end
