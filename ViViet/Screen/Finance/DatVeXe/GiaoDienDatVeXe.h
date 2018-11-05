//
//  GiaoDienDatVeXe.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/16/17.
//

#import <UIKit/UIKit.h>
#import "BaseScreen.h"
#import "DucNT_Token.h"
#import "DucNT_LuuRMS.h"
#import "DucNT_ServicePost.h"
#import "ExTextField.h"
#import "UmiTextView.h"
#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"
#import "DucNT_TaiKhoanThuongDungObject.h"

@interface GiaoDienDatVeXe : GiaoDichViewController
@property (retain, nonatomic) IBOutlet ExTextField *edChonNgay;
@property (retain, nonatomic) IBOutlet ExTextField *edTinhDi;
@property (retain, nonatomic) IBOutlet ExTextField *edHuyenDi;
@property (retain, nonatomic) IBOutlet ExTextField *edTinhDen;
@property (retain, nonatomic) IBOutlet ExTextField *edHuyenDen;
@property (retain, nonatomic) IBOutlet UIView *viewCalendar;
@property (retain, nonatomic) IBOutlet UIButton *btnCloseCalendarView;

- (IBAction)suKienChonNgayDi:(id)sender;
- (IBAction)suKienChonTiepTuc:(id)sender;
@end
