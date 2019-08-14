//
//  GiaoDienBaoHiem.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 6/27/17.
//
//

#import "GiaoDichViewController.h"
#import "UmiTextView.h"
#import "TPKeyboardAvoidAcessory.h"
#import "DucNT_LoginSceen.h"

@interface GiaoDienBaoHiem : GiaoDichViewController
@property (retain, nonatomic) IBOutlet UIView *viewThanhToan;
@property (retain, nonatomic) IBOutlet ExTextField *tfLoaiBaoHiem;
@property (retain, nonatomic) IBOutlet ExTextField *tfMaKhachHang;
@property (retain, nonatomic) IBOutlet ExTextField *tfTenKhachHang;
@property (retain, nonatomic) IBOutlet ExTextField *tfSoTien;
@property (retain, nonatomic) IBOutlet UmiTextView *tvNoiDung;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *scrMain;
@end
