//
//  GiaoDienBenTrai.m
//  ViViMASS
//
//  Created by DucBT on 1/5/15.
//
//

#import "Common.h"
#import "DucNT_LuuRMS.h"
#import "GiaoDienBenTrai.h"
#import "GiaoDienBenTraiTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DichVuNotification.h"

#define kDO_CAO_CELL_GIAO_DIEN_BEN_TRAI 40.0f

#define HOP_THOAI_CHUYEN_GIAO_DIEN_VI_CA_NHAN 200
#define HOP_THOAI_CHUYEN_GIAO_DIEN_VI_DOANH_NGHIEP 201


@interface GiaoDienBenTrai () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSMutableArray *mDanhSachItemTaiChinhCaNhan;
    NSMutableArray *mDanhSachItemTaiChinhDoanhNghiep;
    NSInteger mKieuHienThi;
    
}
@property (nonatomic, retain) NSArray *mDanhSachItemTaiChinh;
@property (nonatomic, retain) NSArray *mDanhSachSubItemTaiChinh;
@property (nonatomic, retain) NSIndexPath *mViTriHienTai;
@property (retain, nonatomic) IBOutlet UIView *mViewThongTinTaiKhoanChuaDangNhap;
@property (retain, nonatomic) IBOutlet UIView *mViewLuaChon;
@property (retain, nonatomic) IBOutlet UIButton *mbtnViCaNhan;
@property (retain, nonatomic) IBOutlet UIButton *mbtnViDoanhNghiep;
@property (retain, nonatomic) IBOutlet UIImageView *mimgvBg;

@end

@implementation GiaoDienBenTrai


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    NSLog(@"GiaoDienBenTrai : awakeFromNib : START");
    [self.mbtnViCaNhan setBackgroundColor:[UIColor colorWithHexString:@"#0c75c9"]];
    [self.mbtnViDoanhNghiep setBackgroundColor:[UIColor colorWithHexString:@"#308d1e"]];
    [self.mbtnViDoanhNghiep setTitle:[@"vi_doanh_nghiep" localizableString] forState:UIControlStateNormal];
    [self.mbtnViCaNhan setTitle:[@"vi_ca_nhan" localizableString] forState:UIControlStateNormal];
    
    [self khoiTaoDanhSachItemTaiChinh];
    [self khoiTaoViewThongTinTaiKhoan];
    
    [self xuLyHienThiGiaoDien];
    
    NSLog(@"GiaoDienBenTrai : awakeFromNib : END");
}

#pragma mark - khoi Tao
- (void)khoiTaoDanhSachItemTaiChinh
{
    if(mDanhSachItemTaiChinhCaNhan)
        [mDanhSachItemTaiChinhCaNhan removeAllObjects];
    else
        mDanhSachItemTaiChinhCaNhan = [[NSMutableArray alloc] init];
    NSString *ver = [NSString stringWithFormat:@"Phiên bản: %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];

    ItemMenuTaiChinh *itemVersion = [[ItemMenuTaiChinh alloc] init];
    itemVersion.mTieuDe = ver;
    itemVersion.mTenHamXuLy = @"";


    NSString *fileCaNhan = [[NSBundle mainBundle] pathForResource:@"ItemMenuTaiChinhViViMassCaNhan" ofType:@"plist"];
    NSMutableDictionary *dic_resource_ca_nhan = nil;
    if (fileCaNhan != nil)
    {
        NSPropertyListFormat fm;
        NSError *err = nil;
        dic_resource_ca_nhan = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:fileCaNhan] options:kCFPropertyListMutableContainersAndLeaves format:&fm error:&err];
    }
    NSArray *arrCaNhan = [dic_resource_ca_nhan objectForKey:@"MainItem"];
    for(NSDictionary *dict in arrCaNhan)
    {
        ItemMenuTaiChinh *item = [[ItemMenuTaiChinh alloc] initWithDict:dict];
        [mDanhSachItemTaiChinhCaNhan addObject:item];
        [item release];
    }
    [mDanhSachItemTaiChinhCaNhan addObject:itemVersion];

    if(mDanhSachItemTaiChinhDoanhNghiep)
        [mDanhSachItemTaiChinhDoanhNghiep removeAllObjects];
    else
        mDanhSachItemTaiChinhDoanhNghiep = [[NSMutableArray alloc] init];
    
    NSString *fileDoanhNghiep = [[NSBundle mainBundle] pathForResource:@"ItemMenuTaiChinhViViMassDoanhNghiep" ofType:@"plist"];
    NSMutableDictionary *dic_resource_doanhnghiep = nil;
    if (fileDoanhNghiep != nil)
    {
        NSPropertyListFormat fm;
        NSError *err = nil;
        dic_resource_doanhnghiep = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:fileDoanhNghiep] options:kCFPropertyListMutableContainersAndLeaves format:&fm error:&err];
    }
    NSArray *arrDoanhNghiep = [dic_resource_doanhnghiep objectForKey:@"MainItem"];
    for(NSDictionary *dict in arrDoanhNghiep)
    {
        ItemMenuTaiChinh *item = [[ItemMenuTaiChinh alloc] initWithDict:dict];
        [mDanhSachItemTaiChinhDoanhNghiep addObject:item];
        [item release];
    }
    [mDanhSachItemTaiChinhDoanhNghiep addObject:itemVersion];
}

- (void)khoiTaoViewThongTinTaiKhoan
{
    NSLog(@"%s - START", __FUNCTION__);
    BOOL bDaDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue];
    if(bDaDangNhap)
    {
        [self.mViewThongTinTaiKhoan setHidden:NO];
        [self.mViewThongTinTaiKhoanChuaDangNhap setHidden:YES];
    }
    else
    {
        [self.mViewThongTinTaiKhoan setHidden:YES];
        [self.mViewThongTinTaiKhoanChuaDangNhap setHidden:NO];
    }
    [self xuLyAnSubTable];
    [self khoiTaoDuLieuThongTinVi];
    [self setNeedsDisplay];
}

- (void)khoiTaoDuLieuThongTinVi
{
    if(_mThongTinTaiKhoanVi)
    {
        NSString *sDuongDanAnhDaiDien = _mThongTinTaiKhoanVi.sLinkAnhDaiDien;
        NSString *sID = _mThongTinTaiKhoanVi.sID;
        NSString *sTenCMND = _mThongTinTaiKhoanVi.sNameAlias;
        if([sDuongDanAnhDaiDien isEqualToString:@""])
        {
            self.mimgvDaiDien.image = [UIImage imageNamed:@"icon_danhba"];
        }
        else
        {
            if([sDuongDanAnhDaiDien rangeOfString:@"http"].location != NSNotFound){
                [self.mimgvDaiDien sd_setImageWithURL:[NSURL URLWithString:sDuongDanAnhDaiDien]];
            }
            else{
                [self.mimgvDaiDien sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", sDuongDanAnhDaiDien]]];
            }
        }
        self.mlblTenChuTaiKhoan.text = sTenCMND;
        self.mlblSoDienThoaiChuTaiKhoan.text = sID;
        [self capNhatSoDu:0 soDuKhuyenMai:0];
    }
}


- (void)capNhatSoDu:(double)fSoDu soDuKhuyenMai:(double)fSoDuKhuyenMai
{
    self.mlblSoTienTrongVi.text = [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:fSoDu]];
    self.lblKhuyenMai.text = [NSString stringWithFormat:@"KM: %@ đ", [Common hienThiTienTe:fSoDuKhuyenMai]];
    [self.mtbHienThi reloadData];
}

#pragma mark - get & set
- (void)setMThongTinTaiKhoanVi:(DucNT_TaiKhoanViObject *)mThongTinTaiKhoanVi
{
    if(_mThongTinTaiKhoanVi)
    {
        [_mThongTinTaiKhoanVi release];
    }
    
    _mThongTinTaiKhoanVi = [mThongTinTaiKhoanVi retain];
    [self khoiTaoViewThongTinTaiKhoan];
}

#pragma mark - suKien

- (IBAction)suKienBamNutThongTinVi:(UIButton *)sender
{
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienChonThongTinVi)])
    {
        [self.mDelegate xuLySuKienChonThongTinVi];
    }
}

- (IBAction)suKienBamNutViCaNhan:(id)sender
{
    if(mKieuHienThi != KIEU_CA_NHAN)
    {
        NSString *loginState = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE];
        if([loginState isEqualToString:@"YES"])
        {
            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_CHUYEN_GIAO_DIEN_VI_CA_NHAN cauThongBao:[@"thong_bao_chuyen_doi_giua_vi_ca_nhan_va_vi_doanh_nghiep" localizableString]];
            return;
        }
        //Neu dang dang nhap
        mKieuHienThi = KIEU_CA_NHAN;
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_HIEN_THI_VI value:[NSString stringWithFormat:@"%ld", (long)mKieuHienThi]];
        [self xuLyHienThiGiaoDien];
    }
}

- (IBAction)suKienBamNutViDoanhNghiep:(id)sender
{
    if(mKieuHienThi != KIEU_DOANH_NGHIEP)
    {
        NSString *loginState = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE];
        if([loginState isEqualToString:@"YES"])
        {
            [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_CHUYEN_GIAO_DIEN_VI_DOANH_NGHIEP cauThongBao:[@"thong_bao_chuyen_doi_giua_vi_ca_nhan_va_vi_doanh_nghiep" localizableString]];
            return;
        }
        
        mKieuHienThi = KIEU_DOANH_NGHIEP;
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_HIEN_THI_VI value:[NSString stringWithFormat:@"%ld", (long)mKieuHienThi]];
        [self xuLyHienThiGiaoDien];
    }
}

- (IBAction)suKienBamNutDongViewBenTrai:(id)sender
{
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienDongViewBenTrai)])
    {
        [self.mDelegate xuLySuKienDongViewBenTrai];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.mtbSubHienThi)
    {
        if(_mDanhSachSubItemTaiChinh)
            return self.mDanhSachSubItemTaiChinh.count;
        return 0;
    }

    if(_mDanhSachItemTaiChinh)
        return _mDanhSachItemTaiChinh.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.mtbSubHienThi)
    {
        static NSString *cellGiaoDienBenTraiSubIdentifier = @"cellGiaoDienBenTraiSubIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellGiaoDienBenTraiSubIdentifier];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellGiaoDienBenTraiSubIdentifier];
        }
        
        ItemMenuTaiChinh *item = [self.mDanhSachSubItemTaiChinh objectAtIndex:indexPath.row];
        cell.textLabel.text = [item.mTieuDe localizableString];
        NSLog(@"%s - cell.textLabel.text : %@", __FUNCTION__, cell.textLabel.text);
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.minimumScaleFactor = 0.8f;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0f];
        if(mKieuHienThi == KIEU_DOANH_NGHIEP)
        {
            cell.backgroundColor = [UIColor colorWithHexString:@"#42b52b"];
        }
        else if(mKieuHienThi == KIEU_CA_NHAN)
        {
            cell.backgroundColor = [UIColor colorWithHexString:@"#0083ec"];
        }
        return cell;
    }
    static NSString *cellGiaoDienBenTraiIdentifier = @"cellGiaoDienBenTraiIdentifier";
    GiaoDienBenTraiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellGiaoDienBenTraiIdentifier];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GiaoDienBenTraiTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.mKieuHienThi = mKieuHienThi;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ItemMenuTaiChinh *item = [_mDanhSachItemTaiChinh objectAtIndex:indexPath.row];
    NSString *sTieuDe = item.mTieuDe;

    if([sTieuDe isEqualToString:@"dang_xuat"])
    {
        if(![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
        {
            sTieuDe = @"dang_nhap";
        }
    }
    else if ([sTieuDe isEqualToString:@"sao_ke"])
    {
        int nBagdeNumber = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:TIN_TAI_CHINH];
        NSLog(@"%s - nBagdeNumber : %d", __FUNCTION__, nBagdeNumber);
        if(nBagdeNumber > 0)
        {
            [cell.mlblBadgeNumber setHidden:NO];
        }
        else
        {
            [cell.mlblBadgeNumber setHidden:YES];
        }
        [cell.mlblBadgeNumber setText:[NSString stringWithFormat:@"%d", nBagdeNumber]];
    }

//    NSLog(@"GiaoDienBenTrai : cellForRowAtIndexPath :==> item.mAnhDaiDien : %@", item.mAnhDaiDien);
    cell.mimgvDaiDien.image = [UIImage imageNamed:item.mAnhDaiDien];
    if (indexPath.row == _mDanhSachItemTaiChinh.count - 1) {
        [cell.mlblTieuDe setText:sTieuDe];
        CGRect rectTemp = cell.mlblTieuDe.frame;
        rectTemp.origin.x = 3;
        cell.mlblTieuDe.frame = rectTemp;
    }
    else {
        [cell.mlblTieuDe setText:[sTieuDe localizableString]];
        if([sTieuDe isEqualToString:@"Giay_phep"])
        {
            [cell.mlblTieuDe setText:[NSString stringWithFormat:@"Giấy phép Ví điện tử số 41/GP-NHNN\nNgân hàng nhà nước VN cấp 12/3/2018"]];
            [cell.mlblTieuDe sizeThatFits:CGSizeMake(cell.frame.size.width, cell.frame.size.height)];
            [cell.mlblTieuDe setAdjustsFontSizeToFitWidth:YES];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(tableView == self.mtbHienThi)
//    {
//        if (cell.isSelected == YES)
//        {
//    //        [cell setBackgroundColor:SelectedCellBGColor];
//            if(mKieuHienThi == KIEU_DOANH_NGHIEP)
//            {
//                cell.backgroundColor = [UIColor colorWithHexString:@"#43b030"];
//            }
//            else if(mKieuHienThi == KIEU_CA_NHAN)
//            {
//                cell.backgroundColor = [UIColor colorWithHexString:@"#3c97d2"];
//            }
//        }
//        else
//        {
//    //        [cell setBackgroundColor:NotSelectedCellBGColor];
//            cell.backgroundColor = [UIColor clearColor];
//        }
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s : START!!! indexPath : %d",__FUNCTION__, (int)indexPath.row);
    if(tableView == self.mtbSubHienThi)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        ItemMenuTaiChinh *item = [self.mDanhSachSubItemTaiChinh objectAtIndex:indexPath.row];
        if([self.mDelegate respondsToSelector:@selector(xuLySuKienChonItemMenuTaiChinh:)])
        {
            [self.mDelegate xuLySuKienChonItemMenuTaiChinh:item];
        }
    }
    else if(tableView == self.mtbHienThi)
    {
        if (indexPath.row == 11) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.sbv.gov.vn/webcenter/portal/vi/menu/trangchu/ttsk/ttsk_chitiet?centerWidth=80%25&dDocName=SBV331391&leftWidth=20%25&rightWidth=0%25&showFooter=false&showHeader=false&_adf.ctrl-state=1c7kax1f62_4&_afrLoop=1291034936391000"]];
        }
        ItemMenuTaiChinh *item = [_mDanhSachItemTaiChinh objectAtIndex:indexPath.row];
        if(item.mDsCon.count > 0)
        {
            self.mDanhSachSubItemTaiChinh = item.mDsCon;
            [self.mtbSubHienThi reloadData];
            if([indexPath isEqual:self.mViTriHienTai])
            {
                [self xuLyAnSubTable];
            }
            else
            {
                [self xuLyHienThiSubTableCuaCellTaiViTri:indexPath];
            }
        }
        else
        {
            [self xuLyAnSubTable];
            if([self.mDelegate respondsToSelector:@selector(xuLySuKienChonItemMenuTaiChinh:)])
            {
                [self.mDelegate xuLySuKienChonItemMenuTaiChinh:item];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDO_CAO_CELL_GIAO_DIEN_BEN_TRAI;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.mtbHienThi)
    {
        [self xuLyAnSubTable];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if(alertView.tag == HOP_THOAI_CHUYEN_GIAO_DIEN_VI_DOANH_NGHIEP)
        {
            int nViTriDangXuat = (int)_mDanhSachItemTaiChinh.count - 1;
            [_mtbHienThi.delegate tableView:_mtbHienThi didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:nViTriDangXuat inSection:0]];
            [self suKienBamNutViDoanhNghiep:_mbtnViDoanhNghiep];
        }
        else if (alertView.tag == HOP_THOAI_CHUYEN_GIAO_DIEN_VI_CA_NHAN)
        {
            int nViTriDangXuat = (int)_mDanhSachItemTaiChinh.count - 1;
            [_mtbHienThi.delegate tableView:_mtbHienThi didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:nViTriDangXuat inSection:0]];
            [self suKienBamNutViCaNhan:_mbtnViCaNhan];
        }
    }
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if([touch view] != self.mtbSubHienThi)
    {
        [self xuLyAnSubTable];
    }
}

#pragma mark - public

- (void)hienThiChuyenTien
{
    [self xuLyAnSubTable];
    [self suKienBamNutViCaNhan:self.mbtnViCaNhan];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.mtbHienThi selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    if ([self.mtbHienThi.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [self.mtbHienThi.delegate tableView:self.mtbHienThi didSelectRowAtIndexPath:indexPath];
    }
}

- (void)hienThiRutTien
{
    [self xuLyAnSubTable];
    [self suKienBamNutViCaNhan:self.mbtnViCaNhan];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
//    [self.mtbHienThi selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.mtbHienThi didSelectRowAtIndexPath:indexPath];
}

- (void)hienThiMuonTien
{
    [self xuLyAnSubTable];
    [self suKienBamNutViCaNhan:self.mbtnViCaNhan];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
//    [self.mtbHienThi selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.mtbHienThi didSelectRowAtIndexPath:indexPath];

}

#pragma mark - private

- (void)hienThiHopThoaiHaiNutBamKieu:(int)nKieu cauThongBao:(NSString*)sCauThongBao
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:sCauThongBao delegate:self cancelButtonTitle:[@"huy" localizableString] otherButtonTitles:[@"dong_y" localizableString], nil] autorelease];
    alertView.tag = nKieu;
    [alertView show];
}

- (void)xuLyAnSubTable
{
    [self.mtbHienThi deselectRowAtIndexPath:self.mViTriHienTai animated:YES];
    self.mViTriHienTai = nil;
    self.mDanhSachSubItemTaiChinh = nil;
    [self.mtbSubHienThi setHidden:YES];
}

- (void)xuLyHienThiSubTableCuaCellTaiViTri:(NSIndexPath*)indexPath
{
    self.mViTriHienTai = indexPath;
    float fDoCaoSubTable = self.mDanhSachSubItemTaiChinh.count * kDO_CAO_CELL_GIAO_DIEN_BEN_TRAI;
//    float fDoRongSubTable = self.mtbHienThi.frame.size.width / 2;
    float fDoRongSubTable = self.mtbSubHienThi.frame.size.width;
    float fToaDoX = self.mtbHienThi.frame.size.width  - fDoRongSubTable;
    float fToaDoY = self.mtbHienThi.frame.origin.y;

    if(fDoCaoSubTable > self.mtbHienThi.frame.size.height)
    {
        fDoCaoSubTable = self.mtbHienThi.frame.size.height;
    }
    else
    {
        
        CGRect rectInTableView = [self.mtbHienThi rectForRowAtIndexPath:indexPath];
        CGRect rectInSuperview = [self.mtbHienThi convertRect:rectInTableView toView:[self.mtbHienThi superview]];

        float fHeightConLai = self.frame.size.height - rectInSuperview.origin.y;
        if(fDoCaoSubTable > fHeightConLai)
        {
            CGRect rCell = [self.mtbHienThi rectForRowAtIndexPath:indexPath];
            CGPoint p = [self.mtbHienThi convertPoint:rCell.origin toView:self];
            
            float fKhoangCach = (fDoCaoSubTable - kDO_CAO_CELL_GIAO_DIEN_BEN_TRAI) / 2;
            
//            fToaDoY = self.frame.size.height - fDoCaoSubTable;
            fToaDoY = p.y - fKhoangCach;
        }
        else
        {
            fToaDoY = rectInSuperview.origin.y;
        }
        
    }
    NSLog(@"%s - fToaDoY : %f", __FUNCTION__, fToaDoY);
    if (fToaDoY < 0) {
        fToaDoY = 0;
    }
    CGRect rFrameSubTable = CGRectMake(fToaDoX, fToaDoY, fDoRongSubTable, fDoCaoSubTable);
    self.mtbSubHienThi.frame = rFrameSubTable;
    [self.mtbSubHienThi setHidden:NO];
    [self bringSubviewToFront:self.mtbSubHienThi];
}

- (void)xuLyHienThiGiaoDien
{
    NSString *sKieuHienThi = [DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI];
    if(sKieuHienThi && ![sKieuHienThi isEqualToString:@""])
    {
        mKieuHienThi = [sKieuHienThi intValue];
    }
    else
    {
        mKieuHienThi = KIEU_CA_NHAN;
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_HIEN_THI_VI value:[NSString stringWithFormat:@"%ld", (long)mKieuHienThi]];
    }
    [self xuLyAnSubTable];
    
    if(mKieuHienThi == KIEU_DOANH_NGHIEP)
    {
        self.mDanhSachItemTaiChinh = mDanhSachItemTaiChinhDoanhNghiep;
        [self.mimgvBg setImage:[UIImage imageNamed:@"bg-doanhnghiep-#308d1e"]];
    }
    else if (mKieuHienThi == KIEU_CA_NHAN)
    {
        self.mDanhSachItemTaiChinh = mDanhSachItemTaiChinhCaNhan;
        [self.mimgvBg setImage:[UIImage imageNamed:@"bg-canhan-#0c75c9"]];
    }
    
    [self.mtbHienThi reloadData];
}

- (void)reloadDataBagde{
    [self.mtbHienThi reloadData];
}

#pragma mark - dealloc

- (void)dealloc {
    
    if(mDanhSachItemTaiChinhDoanhNghiep)
        [mDanhSachItemTaiChinhDoanhNghiep release];
    if(mDanhSachItemTaiChinhCaNhan)
        [mDanhSachItemTaiChinhCaNhan release];
    if(_mThongTinTaiKhoanVi)
    {
        [_mThongTinTaiKhoanVi release];
    }
    if(_mDanhSachSubItemTaiChinh)
        [_mDanhSachSubItemTaiChinh release];
    if(_mDanhSachItemTaiChinh)
        [_mDanhSachItemTaiChinh release];
    if(_mViTriHienTai)
        [_mViTriHienTai release];
    [_mimgvDaiDien release];
    [_mlblTenChuTaiKhoan release];
    [_mlblSoDienThoaiChuTaiKhoan release];
    [_mlblSoTienTrongVi release];
    [_mtbHienThi release];
    [_mViewThongTinTaiKhoan release];
    [_mtbSubHienThi release];
    [_mViewThongTinTaiKhoanChuaDangNhap release];
    [_mViewLuaChon release];
    [_mbtnViCaNhan release];
    [_mbtnViDoanhNghiep release];
    [_mimgvBg release];
    [_lblKhuyenMai release];
    [super dealloc];
}
@end
