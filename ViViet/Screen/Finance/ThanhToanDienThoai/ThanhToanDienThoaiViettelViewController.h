//
//  ThanhToanDienThoaiViettelViewController.h
//  ViViMASS
//
//  Created by DucBT on 3/23/15.
//
//

#import "GiaoDichViewController.h"
#import "DoiTuongThanhToanCuocDienThoaiViettel.h"

@interface ThanhToanDienThoaiViettelViewController : GiaoDichViewController

@property (retain, nonatomic) IBOutlet ExTextField *mtfSoDienThoai;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoTien;
@property (retain, nonatomic) IBOutlet ExTextField *mtfSoPhi;
@property (retain, nonatomic) IBOutlet UILabel *mlblKhuyenMai;
@property (retain, nonatomic) IBOutlet ExTextField *mtfTenLoaiThanhToan;

@property (retain, nonatomic) IBOutlet UIButton *mbtnTraCuu;
@property (retain, nonatomic) IBOutlet UIView *mViewThanhToan;
@property (retain, nonatomic) IBOutlet UIView *mViewSoDienThoai;

//View thong bao
@property (retain, nonatomic) IBOutlet UIView *mViewThongBao;
@property (retain, nonatomic) IBOutlet UITextView *mtvHienThiThongBao;
@property (retain, nonatomic) IBOutlet UIView *mViewNenThongBao;

@property (retain, nonatomic) DoiTuongThanhToanCuocDienThoaiViettel *mDoiTuongThanhToanCuocDienThoaiViettel;

@end
