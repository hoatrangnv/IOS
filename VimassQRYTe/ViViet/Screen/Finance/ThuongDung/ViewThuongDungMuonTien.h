//
//  ViewThuongDungMuonTien.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 2/7/17.
//
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "UmiTextView.h"
#import "DucNT_TaiKhoanThuongDungObject.h"

@protocol ViewThuongDungMuonTienDelegate <NSObject>

- (void)xuLySuKienBamNutDanhBaMuonTien;

@end

@interface ViewThuongDungMuonTien : UIView
@property (assign, nonatomic) id<ViewThuongDungMuonTienDelegate> mDelegate;
@property (retain, nonatomic) DucNT_TaiKhoanThuongDungObject *mTaiKhoanThuongDung;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTien;
@property (retain, nonatomic) IBOutlet UmiTextView *tvNoiDung;
@property (retain, nonatomic) IBOutlet ExTextField *edNameAlias;
@property (retain, nonatomic) IBOutlet ExTextField *edSoVi;
- (BOOL)kiemTraNoiDung;
- (DucNT_TaiKhoanThuongDungObject*)getTaiKhoanThuongDungDayLenServer;
- (IBAction)suKienBamNutDanhBa:(id)sender;
- (void)capNhatViMuonTien:(NSString *)sSoVi;
@end
