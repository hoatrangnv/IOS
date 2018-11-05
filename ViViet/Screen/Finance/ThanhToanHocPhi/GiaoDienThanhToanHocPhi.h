//
//  GiaoDienThanhToanHocPhi.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/8/16.
//
//

#import "GiaoDichViewController.h"
#import "UmiTextView.h"
#import "TPKeyboardAvoidAcessory.h"
#import "DucNT_LoginSceen.h"

@interface GiaoDienThanhToanHocPhi : GiaoDichViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;
@property (retain, nonatomic) IBOutlet ExTextField *edTruongHoc;
@property (retain, nonatomic) IBOutlet ExTextField *edLoaiGiaoDich;
@property (retain, nonatomic) IBOutlet ExTextField *edMaKH;
@property (retain, nonatomic) IBOutlet ExTextField *edTenKH;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTien;
@property (retain, nonatomic) IBOutlet UmiTextView *tvNoiDung;
- (IBAction)suKienClickSoTayHocPhi:(id)sender;
- (IBAction)suKienThayDoiSoTien:(id)sender;
@end
