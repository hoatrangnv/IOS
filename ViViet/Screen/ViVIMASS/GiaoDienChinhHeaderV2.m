//
//  GiaoDienChinhHeaderV2.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/2/15.
//
//

#import "GiaoDienChinhHeaderV2.h"
#import "Common.h"
#import "DucNT_LuuRMS.h"
@implementation GiaoDienChinhHeaderV2{
    int nDem;
    KASlideShow *temp;
    NSTimer *timeQC;
    int nLoaiQC;
}

- (IBAction)suKienChonRutTien:(id)sender {
    if (self.mDelegate) {
        [self.mDelegate xuLySuKienbamNutRutTien];
    }
}

- (IBAction)suKienChonNapTien:(id)sender{
    if (self.mDelegate) {
        [self.mDelegate xuLySuKienBamNutNapTien];
    }
}

- (IBAction)suKienChonMuonTien:(id)sender{
    if (self.mDelegate) {
        [self.mDelegate xuLySuKienBamNutMuonTien];
    }
}

- (IBAction)suKienChonQuangCao:(id)sender {
    if (_arrImageQC && _arrImageQC.count - 1 >= nDem) {
        NSDictionary *dic = [_arrImageQC objectAtIndex:nDem];
        if (_mDelegate) {
            [_mDelegate suKienChonQuangCao:[dic objectForKey:@"nameImage"]];
        }
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setInteger:temp.currentIndex forKey:@"KEY_INDEX_CLICK_QC"];
        [user synchronize];
    }
}

- (IBAction)suKienChonQRCode:(id)sender {
    if (self.mDelegate) {
        [self.mDelegate suKienChonQRCode];
    }
}

- (void)suKienChonQuangCaoTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"%s - START", __FUNCTION__);
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self khoiTaoGiaoDienHeader];
    nDem = 0;
    nLoaiQC = 0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGRect rect = self.bounds;
    if (width > 320) {
        rect = CGRectMake(0, 0, width, rect.size.height);
    }
    temp = [[KASlideShow alloc] initWithFrame:rect];
    temp.delegate = self;
    [temp setDelay:10.0];
    [temp setTransitionDuration:1];
    [temp setTransitionType:KASlideShowTransitionSlide];
    [temp setImagesContentMode:UIViewContentModeScaleAspectFill];
    [temp addGestureOnline:KASlideShowGestureAll];

    [self.slideShow addSubview:temp];

    self.lblSaoKeChinh.layer.masksToBounds = YES;
    self.lblSaoKeChinh.layer.cornerRadius = 12;
    [self.lblSaoKeChinh setHidden:YES];
//    [self updateTrangThaiThanhPhan:NO];
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"tamnv_hienthi"];
    NSLog(@"%s - %s : ==========> value : %@", __FILE__, __FUNCTION__, value);
    if ([value isEqualToString:@"0"]) {
        _imgHeader.hidden = NO;
    }
    else
        _imgHeader.hidden = YES;
    [self bringSubviewToFront:_btnNapTien];
    [self bringSubviewToFront:_btnRutTien];
    [self bringSubviewToFront:_btnMuonTien];
    [self bringSubviewToFront:_btnSaoKe];
}

- (void)capNhatFrameSlide {
    temp.frame = CGRectMake(0, 0, temp.frame.size.width, self.frame.size.height);
}

- (void)setMThongTinTaiKhoanVi:(DucNT_TaiKhoanViObject *)mThongTinTaiKhoanVi
{
    if(_mThongTinTaiKhoanVi)
    {
        [_mThongTinTaiKhoanVi release];
    }

    _mThongTinTaiKhoanVi = [mThongTinTaiKhoanVi retain];
    [self khoiTaoGiaoDienHeader];
}

- (void)setAnhQuangCao:(NSArray *)arrQC {

    nLoaiQC = 1;
    self.arrImageQC = arrQC;
    NSMutableArray *arrLinkAnh = [[NSMutableArray alloc] init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    BOOL isWifi = [user boolForKey:@"QUANG_CAO_WIFI"];
    NSString *keyQC = @"nameSave";
    if (!isWifi) {
        keyQC = @"nameSave3g";
    }
    NSLog(@"%s - keyQC : %@", __FUNCTION__, keyQC);
    for (NSDictionary *dicTemp in arrQC) {

        NSString *sURL = [dicTemp objectForKey:keyQC];
        if (sURL.isEmpty) {
            keyQC = @"nameSave";
            sURL = [dicTemp objectForKey:keyQC];
        }
        [arrLinkAnh addObject:sURL];
    }
    if (arrLinkAnh.count > 0) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSInteger nIndexQC = [user integerForKey:@"KEY_INDEX_CLICK_QC"];
        temp.currentIndex = nIndexQC;
        [temp setImagesDataSourceOnline:arrLinkAnh];
        [self performSelector:@selector(chaySlideShowOnline1) withObject:nil afterDelay:10];
    }
}

- (void)tamDungQuangCao {
    [temp stopOnline];
}

- (void)chaySlideShow:(NSTimer *)timer{
//    if(nLoaiQC == 0)
        [temp start];
//    else
//        [temp startOnline];
}

- (void)chaySlideShowOnline1{
//    NSLog(@"%s - START", __FUNCTION__);
    [temp startOnline];

}

- (void)chaySlideShowOnline:(NSTimer *)timer{
    NSLog(@"%s - START", __FUNCTION__);
    [temp startOnline];
}


- (void)updateFontChu{
    [self.btnMuonTien.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [self.btnNapTien.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [self.btnRutTien.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [self.lblTen setFont:[UIFont systemFontOfSize:self.lblTen.font.pointSize + 3.0]];
    [self.lblSoDu setFont:[UIFont boldSystemFontOfSize:self.lblSoDu.font.pointSize + 3.0]];
    [self.lblKM setFont:[UIFont systemFontOfSize:self.lblKM.font.pointSize + 2.0]];
}

- (void)updateTrangThaiAnhSlide{
    if ((nDem == 5 || nDem == 0) && self.lblTen.hidden) {
//        [self updateTrangThaiThanhPhan:NO];
    }
    else{
//        [self updateTrangThaiThanhPhan:YES];
    }
}

- (IBAction)suKienChonDieuKhienGiongNoi:(id)sender {
    if (_mDelegate) {
        [_mDelegate xuLySuKienDieuKhienGiongNoi];
    }
}

- (void) kaSlideShowDidShowPrevious:(KASlideShow *) slideShow {
    nDem --;
    if (nDem < 0) {
        nDem = 0;
    }
}

- (void) kaSlideShowDidShowNext:(KASlideShow *) slideShow{
    nDem ++;
    if (_arrImageQC && nDem >= _arrImageQC.count) {
        nDem = 0;
    }
//    [self performSelector:@selector(chaySlideShowOnline1) withObject:nil afterDelay:50];
}

- (void)kaSlideShowWillShowNext:(KASlideShow *)slideShow{
//    if (nDem < 9) {
//        nDem ++;
//    }
//    else
//        nDem = 0;
//    if ((nDem == 5 || nDem == 0) && self.lblTen.hidden) {
////        [self updateTrangThaiThanhPhan:NO];
//    }
//    else{
////        [self updateTrangThaiThanhPhan:YES];
//    }
}

- (void)kaSlideShowTapOnImage:(NSUInteger)nIndex nViTriChon:(int)nIndexChon{
    NSLog(@"%s - nIndex : %d -  nIndexChon : %d", __FUNCTION__, (int)nIndex, nIndexChon);
    if (_arrImageQC && _arrImageQC.count - 1 >= (int)nIndex) {
        NSDictionary *dic = [_arrImageQC objectAtIndex:(int)nIndex];
        if (_mDelegate) {
            NSString *sTenAnh = [dic objectForKey:@"nameImage"];
            sTenAnh = [sTenAnh stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([sTenAnh hasPrefix:@"5"]) {
                NSArray *arrTenAnh = [sTenAnh componentsSeparatedByString:@"#"];
                if (arrTenAnh.count > nIndexChon + 1) {
                    NSString *sTenViTri = arrTenAnh[nIndexChon + 1];
                    NSLog(@"%s - sTenViTri : %@", __FUNCTION__, sTenViTri);
                    [_mDelegate suKienChonQuangCao:sTenViTri];
                }
            }
            else if ([sTenAnh hasPrefix:@"4"]) {
                if (nIndexChon == 4) {
                    nIndexChon = 0;
                }
                NSArray *arrTenAnh = [sTenAnh componentsSeparatedByString:@"#"];
                if (arrTenAnh.count > nIndexChon + 1) {
                    NSString *sTenViTri = arrTenAnh[nIndexChon + 1];
                    NSLog(@"%s - sTenViTri : %@", __FUNCTION__, sTenViTri);
                    [_mDelegate suKienChonQuangCao:sTenViTri];
                }
            }
            else {
                NSLog(@"%s - vao den day", __FUNCTION__);
                [_mDelegate suKienChonQuangCao:sTenAnh];
            }
        }
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setInteger:nIndex forKey:@"KEY_INDEX_CLICK_QC"];
        [user synchronize];
    }
}

- (void)capNhatSoDu:(double)fSoDu soDuKhuyenMai:(double)fSoDuKhuyenMai theQuaTang:(double)fTheQuaTang{
    self.lblSoDu.text = [NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:fSoDu]];
    self.lblKM.text = [NSString stringWithFormat:@"KM %@ đ", [Common hienThiTienTe:fSoDuKhuyenMai]];
}

- (void)khoiTaoGiaoDienHeader
{
    bool bDaDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue];
    if(bDaDangNhap)
    {
//        [self updateTrangThaiThanhPhan:NO];
    }
    else
    {
//        [self updateTrangThaiThanhPhan:YES];
    }
    if(_mThongTinTaiKhoanVi)
    {
        NSString *sTenCMND = _mThongTinTaiKhoanVi.sNameAlias;
        self.lblTen.text = sTenCMND;
        [self capNhatSoDu:[_mThongTinTaiKhoanVi.nAmount floatValue] soDuKhuyenMai:[_mThongTinTaiKhoanVi.nPromotionTotal floatValue] theQuaTang:0];
    }
}

- (void)updateTrangThaiThanhPhan:(BOOL)bHien{
    if (!bHien) {
        if(![[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
        {
            NSLog(@"%s ======================>", __FUNCTION__);
            return;
        }
    }
//    bHien = YES;
    self.lblTen.hidden = bHien;
    self.lblSoDu.hidden = bHien;
    self.lblKM.hidden = bHien;
    self.btnSaoKeKM.hidden = bHien;
}

- (void)xuLySuKienBamNutTroChuyen{
    
}

- (IBAction)suKienBamNutXemSaoKe:(id)sender {
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienXemSaoKe:)])
    {
        [self.mDelegate xuLySuKienXemSaoKe:sender];
    }
}

- (void)dealloc {
    [_btnNapTien release];
    [_btnRutTien release];
    [_btnMuonTien release];
    [_lblTen release];
    [_lblSoDu release];
    [_lblKM release];
    if (temp) {
        [temp release];
    }
//    if (timeQC) {
//        [timeQC invalidate];
//        timeQC = nil;
//    }
    if (_arrImageQC) {
        [_arrImageQC release];
    }
    [_slideShow release];
    [_btnSaoKeChinh release];
    [_btnSaoKeKM release];
    [_lblSaoKeChinh release];
    [_imgHeader release];
    [_btnSaoKe release];
    [super dealloc];
}
@end
