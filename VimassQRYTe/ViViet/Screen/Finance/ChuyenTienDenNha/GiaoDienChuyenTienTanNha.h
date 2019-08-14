//
//  GiaoDienChuyenTienTanNha.h
//  ViViMASS
//
//  Created by nguyen tam on 7/2/15.
//
//

#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"
#import "UmiTextView.h"

@interface GiaoDienChuyenTienTanNha : GiaoDichViewController
@property (retain, nonatomic) IBOutlet ExTextField *mtfHoTen;
@property (retain, nonatomic) IBOutlet ExTextField *mtfCMND;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;

@property (retain, nonatomic) IBOutlet ExTextField *mtfPhi;
@property (retain, nonatomic) IBOutlet ExTextField *mtfPhoneNumber;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTinhThanh;
@property (retain, nonatomic) IBOutlet ExTextField *mtfQuanHuyen;
@property (retain, nonatomic) IBOutlet ExTextField *mtfPhuongXa;
@property (retain, nonatomic) IBOutlet ExTextField *mtfDiaChi;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNoiDung;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidAcessory *mScrMain;

@end
