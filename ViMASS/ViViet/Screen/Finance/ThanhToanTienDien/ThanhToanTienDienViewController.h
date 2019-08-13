//
//  ThanhToanTienDienViewController.h
//  ViViMASS
//
//  Created by DucBui on 4/14/15.
//
//

#import "GiaoDichViewController.h"
#import "MoTaChiTietKhachHang.h"

#import "UmiTextView.h"

@interface ThanhToanTienDienViewController : GiaoDichViewController
@property (retain, nonatomic) IBOutlet UIScrollView *mscrv;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenKhuVucThanhToan;
@property (retain, nonatomic) IBOutlet ExTextField *mtfMaKhachHang;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenKhachHang;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoDienThoaiLienHe;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvDiaChi;
@property (retain, nonatomic) IBOutlet ExTextField *mtfDiaChi;
@property (retain, nonatomic) IBOutlet ExTextField *mtfKyThanhToan;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoPhi;
@property (retain, nonatomic) IBOutlet UmiTextView *mtvNoiDung;
@property (retain, nonatomic) IBOutlet ExTextField *mtfNoiDung;
@property (nonatomic, assign) int nChucNang;
@property (nonatomic, retain) MoTaChiTietKhachHang *mMoTaChiTietKhachHang;
@property (nonatomic, retain) NSArray *mDanhSachMaDienLuc;

@end
