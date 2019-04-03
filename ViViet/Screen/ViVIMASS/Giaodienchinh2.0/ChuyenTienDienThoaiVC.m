//
//  ChuyenTienDienThoaiVC.m
//  ViViMASS
//
//  Created by Mac Mini on 10/10/18.
//

#import "ChuyenTienDienThoaiVC.h"
#import "Contact.h"
#import "ContactViewCell.h"
#import "ContactScreen.h"
#import "PhoneTableViewCell.h"
#import "TblHomeFooterView.h"
#import "MoneyContact.h"
#import "UIImage+GKContact.h"
#import "PhoneContacts.h"
#import "FooterTable.h"
#import "ObjectItemChuyenTienAnDanh.h"
#import "CommonUtils.h"
#import "DanhsachsotayViewController.h"
#import "ContactScreenMultiSelect.h"
@interface ChuyenTienDienThoaiVC ()<UITableViewDelegate,UITableViewDataSource,PhoneTableViewCellChangeMoneyDelegate,UITextViewDelegate,FooterTableDelegate,DucNT_ServicePostDelegate,UIAlertViewDelegate,DanhsachsotayViewControllerDelegate>{
    FooterTable *footer;
    NSTimer *mTimer;
}
@property (nonatomic,strong) NSMutableArray *arrPhone;
@property (nonatomic,strong) NSDictionary*dict;

@property (retain, nonatomic) NSString *mPhoneAuthenticate;
@property (assign, nonatomic) NSString *mIsToken;

@property (assign, nonatomic) NSInteger mTongSoThoiGian;
@property (assign, nonatomic) BOOL mChayLanDau;
@property (strong, nonatomic) NSString *idGiaoDich;
@property (strong, nonatomic) NSString *strNoidung;

@end

@implementation ChuyenTienDienThoaiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.arrPhone = [NSMutableArray array];
    [self.tblContatcs setDelegate:self];
    [self.tblContatcs setDataSource:self];
    [self.tblContatcs registerNib:[UINib nibWithNibName:@"PhoneTableViewCell" bundle:nil] forCellReuseIdentifier:@"PhoneCell"];
    [self.tblContatcs registerNib:[UINib nibWithNibName:@"FooterTable" bundle:nil] forHeaderFooterViewReuseIdentifier:@"Footer"];
    MoneyContact *footer = [MoneyContact new];
    footer.money = @"0";
    [self.arrPhone addObjectsFromArray:[NSArray arrayWithObject:footer]];
    
    [self.tblContatcs reloadData];
    //Xac thuc = dien thoai
    self.mPhoneAuthenticate = [DucNT_LuuRMS layThongTinDangNhap:KEY_PHONE_AUTHENTICATE];
    //Xac thuc = token
    self.mIsToken = [[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_TRANG_THAI_CO_TOKEN] intValue];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    _lblChuyenTienDienThoai.text = [@"financer_viewer_wallet_to_dienthoai" localizableString];

}
-(void)dismissKeyboard
{
    for (UIView *v in self.tblContatcs.subviews) {
        if ([v isKindOfClass:[PhoneTableViewCell class]]){
            PhoneTableViewCell *vt = (PhoneTableViewCell*)v;
            [vt.txtMoney resignFirstResponder];
        }
    }
    [footer.txtNoiDung resignFirstResponder];
     [footer.txtOtp resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    // Request authorization to Address Book
    //ios 9+


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textViewDidChange:(UITextView *)textView{
    self.strNoidung = textView.text;
    if([textView.text length] > 0){
        footer.tfNoiDung.placeholder = @"";
    }
    else{
        [footer.tfNoiDung setPlaceholder:[NSString stringWithFormat:@"%@(%@)",[@"noi_dung" localizableString], [@"co_the_bo_qua" localizableString]]];
    }
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == [self.arrPhone count] - 1){
        return 240.0;
    }
    else{
        return 69.0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    if(index == [self.arrPhone count] - 1){
        footer = (FooterTable*) [[[NSBundle mainBundle] loadNibNamed:@"FooterTable" owner:self options:nil] lastObject];
        [footer setupView];
        [footer setDelegate:self];
        [footer.txtNoiDung setDelegate:self];
        footer.lbTongPhi.text = [self.dict objectForKey:@"Fee"];
        footer.lbTongTien.text = [self.dict objectForKey:@"Total"];
        if ([CommonUtils isEmptyOrNull: footer.lbTongPhi.text]){
            footer.lbTongPhi.text = @"0 đ";
        }
        if ([CommonUtils isEmptyOrNull: footer.lbTongTien.text]){
            footer.lbTongTien.text = @"0 đ";
        }
        [footer.tfNoiDung setPlaceholder:[@"place_holder_noi_dung" localizableString]];
        footer.txtNoiDung.textfield = footer.tfNoiDung;
        if(![CommonUtils isEmptyOrNull:self.strNoidung]){
            footer.txtNoiDung.text = self.strNoidung;
            footer.tfNoiDung.placeholder = @"";
        }
        return footer;
    }
    else{
        PhoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhoneCell"];
        [cell.txtMoney setDelegate:self];
        MoneyContact * money = self.arrPhone[indexPath.row];
        cell.moneyContact = money;
        cell.delegate = self;
        cell.btnRemove.tag = indexPath.row;
        [cell.btnRemove setTag:indexPath.row];
        if(money.fromSotay){
            cell.lbName.text = [CommonUtils isEmptyOrNull:money.contact.firstName] == YES?@"":money.contact.firstName;
        }
        else{
            cell.lbName.text = [CommonUtils isEmptyOrNull:money.contact.fullName] == YES?money.contact.phone:money.contact.fullName;
        }
        cell.lbPhone.text = money.contact.phone;
        cell.imgVi.image = [self getImageFromVi:money.loaiMapping andManganhang:money.manganhang];
        UIImage * imgAvatar = [PhoneContacts getAvatarByRecordID:money.contact.recordID];
        if (imgAvatar)
        {
            cell.imgAvatar.image = imgAvatar;
        }
        else
        {
            if(money.fromSotay){
                NSString *name = money.contact.firstName;
                name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                name = [name stringByReplacingOccurrencesOfString:@"." withString:@" "];
                if([[name componentsSeparatedByString:@" "] count] == 1){
                    NSMutableString *mu = [NSMutableString stringWithString:name];
                    [mu insertString:@" " atIndex:1];
                    cell.imgAvatar.image = [UIImage imageForName:mu size:cell.imgAvatar.frame.size];
                }
                else{
                    cell.imgAvatar.image = [UIImage imageForName:name size:cell.imgAvatar.frame.size];
                }
                if(money.money > 0){
                    cell.txtMoney.text = [Common hienThiTienTe:[money.money doubleValue]];
                }
            }
            else{
                if ([CommonUtils isEmptyOrNull:money.contact.fullName]){
                    cell.imgAvatar.image = [UIImage imageNamed:@"danhba64x64"];
                }
                else{
                    NSString *name = [NSString stringWithFormat:@"%@ %@",money.contact.firstName,money.contact.lastName];
                    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    name = [name stringByReplacingOccurrencesOfString:@"." withString:@" "];
                    if([[name componentsSeparatedByString:@" "] count] == 1){
                        NSMutableString *mu = [NSMutableString stringWithString:name];
                        [mu insertString:@" " atIndex:1];
                        cell.imgAvatar.image = [UIImage imageForName:mu size:cell.imgAvatar.frame.size];
                        
                    }
                    else{
                        cell.imgAvatar.image = [UIImage imageForName:name size:cell.imgAvatar.frame.size];
                    }
                }
            }
        }
        [cell.btnRemove addTarget:self action: @selector(doRemove:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
   
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    int maxleng = 15;
    if(range.length +range.location > textField.text.length){
        return NO;
    }
    NSInteger newLenght = textField.text.length +[string length];
    return newLenght <=15;
}
- (void)didChangeMoney{
//    NSInteger index = phoneCell.btnRemove.tag;
//    [self.tblContatcs reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self calculateMoney];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrPhone count];
}
- (IBAction)onAddNewPhone:(id)sender {
    ContactScreenMultiSelect *danhBa = [[[ContactScreenMultiSelect alloc] initWithNibName:@"ContactScreenMultiSelect" bundle:nil] autorelease];
    danhBa.mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:danhBa animated:YES];
    [danhBa selectMulticontact:^(NSMutableArray *contacts) {
        if (contacts.count > 0) {
            [self.arrPhone removeLastObject];
            for (Contact *contact in contacts) {
                MoneyContact *money = [MoneyContact new];
                money.loaiMapping = 0;
                money.contact = contact;
                money.money = @"0";
                [self.arrPhone addObject: money];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                MoneyContact *footer = [MoneyContact new];
                footer.money = @"0";
                [self.arrPhone addObjectsFromArray:[NSArray arrayWithObject:footer]];
                [self.tblContatcs reloadData];
                [self calculateMoney];
            });
        }
        [danhBa.navigationController popViewControllerAnimated:YES];
    }];
    
}
- (void)calculateMoney{
    double total = 0.0;
    double phi = 0.0;
    for (int i=0;i<[self.arrPhone count]-1;i++) {
        MoneyContact *moneyCt =  [self.arrPhone objectAtIndex:i];
        total += [[[moneyCt.money componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];;
        double money = [[[moneyCt.money componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
        if( money == 0){
            phi += 0;
        }
        else {
            switch (moneyCt.loaiMapping) {
                case 0:
                {
                    if (money > 0 && money < 1000000.0) {
                        phi += 330.0;
                    }
                    else if(money <= 20000000.0){
                        phi += 1100.0;
                    }
                    else if(money > 20000000.0){
                        phi += 2200.0;
                    }
                    else{
                        phi += 0;
                    }
                }
                    break;
                case 11:
                case 12:
                case 13:
                {
                    if (money <= 50000000 && money >0) {
                        phi += 3300;
                    }
                    else if (money > 50000000){
                        int X = (money/50000000);
                        int Y = money - X*50000000;
                        if (Y == 0){
                            phi += 3300*X ;
                        }
                        else{
                            phi += 1 + 3300*X ;
                        }
                    }
                    else{
                        phi += 0;
                    }
                }
                    break;
                default:
                    if (money > 0) {
                        phi += 6600.0;
                    }
                    else{
                        phi += 0;
                    }
                    break;
            }
        }
    }
    self.dict = @{@"Total":[Common hienThiTienTe:total],@"Fee":[Common hienThiTienTe:phi]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CountMoney" object:self.dict];
}
-(void)doRemove:(UIButton*)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(int)sender.tag inSection:0];
    [self.arrPhone removeObjectAtIndex:indexPath.row];
    [self.tblContatcs deleteRowsAtIndexPaths:@[indexPath
                                               ] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tblContatcs reloadData];
    [self calculateMoney];
}

- (void)doThucHien{
    if([CommonUtils isEmptyOrNull:footer.txtOtp.text]){
        if(self.mTypeAuthenticate == TYPE_AUTHENTICATE_SMS){
             [UIAlertView alert:@"Vui lòng nhập mã xác thực" withTitle:[@"thong_bao" localizableString] block:nil];
        }
        else{
            [UIAlertView alert:@"Vui lòng nhập mật khẩu " withTitle:[@"thong_bao" localizableString] block:nil];
        }
        return;
    }
    [self xuLySuKienChuyenTienDienThoai];
}
- (void)doToken{
    if([self.arrPhone count] == 0){
        [UIAlertView alert:@"Vui lòng thêm số điện thoại cần chuyển tiền" withTitle:[@"thong_bao" localizableString] block:nil];
        return;
    }
    else if([[self.dict objectForKey:@"Total"] doubleValue] == 0){
        [UIAlertView alert:@"Vui lòng nhập đầy đủ số tiền cần chuyển" withTitle:[@"thong_bao" localizableString] block:nil];
        return;
    }
    self.mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
    footer.txtOtp.hidden = false;
    footer.txtOtp.text = @"";
    footer.txtOtp.placeholder = @"Mật khẩu token";
    footer.btnThucHien.hidden = false;
    footer.lbCountTime.hidden = true;
    footer.lbTime.hidden = true;
}
-(void)doVanTay{
    if([self.arrPhone count] == 0){
        [UIAlertView alert:@"Vui lòng thêm số điện thoại cần chuyển tiền" withTitle:[@"thong_bao" localizableString] block:nil];
        return;
    }
    else if([[self.dict objectForKey:@"Total"] doubleValue] == 0){
        [UIAlertView alert:@"Vui lòng nhập đầy đủ số tiền cần chuyển" withTitle:[@"thong_bao" localizableString] block:nil];
        return;
    }
    self.mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
    NSString *sKeyDangNhap = [DucNT_LuuRMS layThongTinDangNhap:KEY_DANG_NHAP];
    if(sKeyDangNhap.length > 0)
    {
        [self xuLySuKienHienThiChucNangDangNhapVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_VIMASS" localizableString]];
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_chua_co_xac_thuc_van_tay" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }
}
-(void)doSMS{
    if([self.arrPhone count] == 0){
        [UIAlertView alert:@"Vui lòng thêm số điện thoại cần chuyển tiền" withTitle:[@"thong_bao" localizableString] block:nil];
        return;
    }
    else if([[self.dict objectForKey:@"Total"] doubleValue] == 0){
        [UIAlertView alert:@"Vui lòng nhập đầy đủ số tiền cần chuyển" withTitle:[@"thong_bao" localizableString] block:nil];
        return;
    }
    [self hienThiHopThoaiHaiNutBamKieu:HOP_THOAI_XAC_NHAN_XAC_THUC_SMS cauThongBao:[NSString stringWithFormat:@"%@ %@", [@"thong_bao_ma_xac_thuc_duoc_gui_ve_so_dien_thoai" localizableString], self.mPhoneAuthenticate]];

    self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_SMS;
    self.mTypeAuthenticate = TYPE_AUTHENTICATE_SMS;
}
#pragma mark - UIAlertViewDelegate

- (void)hienThiHopThoaiHaiNutBamKieu:(int)nKieu cauThongBao:(NSString*)sCauThongBao
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:sCauThongBao delegate:self cancelButtonTitle:[@"huy" localizableString] otherButtonTitles:[@"dong_y" localizableString], nil] autorelease];
    alertView.tag = nKieu;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if(alertView.tag == HOP_THOAI_XAC_NHAN_XAC_THUC_SMS)
        {
            [self xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:self.mPhoneAuthenticate];
            //[[NSNotificationCenter  defaultCenter]postNotificationName:@"ReloadFooter" object:1];
        }
        else if(alertView.tag == 198){
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
                [self hienThiLoadingChuyenTien];
            }
            NSDictionary *dicPost = @{@"id" : self.idGiaoDich,
                                      @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                                      @"session" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION],
                                      @"status":[NSNumber numberWithBool:YES]
                                      };
            NSLog(@"%s - dicPost : %@", __FUNCTION__, [dicPost JSONString]);
            
            [GiaoDichMang confirmChuyenTienDienThoai:[dicPost JSONString] noiNhanKetQua:self];

        }
    }
    else if(buttonIndex == 0)
    {
    }
}

- (void)xuLySuKienXacThucVanTayThanhCong{
    [self xuLySuKienChuyenTienDienThoai];
}
- (void)xuLyKetNoiLayMaXacThucChuyenDenTaiKhoan:(NSString*)sSendTo
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    int typeAuthenticate = 1;
    NSMutableString *sUrl = [[NSMutableString alloc] init];
    [sUrl appendFormat:@"https://vimass.vn/vmbank/services/account/getOTP?"];
    [sUrl appendFormat:@"id=%@&", sTaiKhoan];
    [sUrl appendFormat:@"appId=%d&", APP_ID];
    [sUrl appendFormat:@"funcId=%d&", FUNC_CHUYEN_TIEN_AN_DANH];
    [sUrl appendFormat:@"typeAuthenticate=%d&", typeAuthenticate];
    [sUrl appendFormat:@"sendTo=%@", sSendTo];
    
    self.mDinhDanhKetNoi = @"LAY_MA_XAC_THUC";
    DucNT_ServicePost *connect = [[DucNT_ServicePost alloc] init];
    [connect setDucnt_connectDelegate:self];
    [connect connectGet:sUrl withContent:@""];
    [connect release];
    [sUrl release];
}

- (void)hienThiThongBaoDienMatKhau
{
    [UIAlertView alert:[@"thong_bao_xac_thuc_van_tay_khong_dung" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
}
- (void)huyXacThucVanTay {
    [footer doToken:self];
}
#pragma mark - xuLyTimer
- (void)batDauDemThoiGian
{
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(capNhatDemThoiGianThayDoiThongTin) userInfo:nil repeats:YES];
}

- (void)ketThucDemThoiGian
{
    footer.lbCountTime.hidden = true;
    footer.lbTime.hidden = true;
    if(mTimer)
    {
        [mTimer invalidate];
        mTimer = nil;
    }
}

- (void)capNhatDemThoiGianThayDoiThongTin
{
    _mTongSoThoiGian --;

    if(self.mTypeAuthenticate == TYPE_AUTHENTICATE_SMS)
    {
        footer.lbCountTime.text = [NSString stringWithFormat:@"%ld s", (long)self.mTongSoThoiGian];
    }
    if(_mTongSoThoiGian == 0)
    {
        [self ketThucDemThoiGian];
    }
}


- (void)xuLySuKienChuyenTienDienThoai
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self hienThiLoadingChuyenTien];
    }
    NSMutableArray *arrData = [NSMutableArray array];
    for (MoneyContact *item in self.arrPhone) {
        if (item.contact != nil) {
            double money =[[[item.money componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] doubleValue];
            ObjectItemChuyenTienAnDanh*obj = [ObjectItemChuyenTienAnDanh new];
            obj.tenHienThi = item.contact.fullName;
            switch (item.loaiMapping) {
                case 0:
                {
                    if (money > 0 && money < 1000000.0) {
                        obj.fee = 330.0;
                    }
                    else if(money <= 20000000.0){
                        obj.fee = 1100.0;
                    }
                    else if(money > 20000000.0){
                        obj.fee = 2200.0;
                    }
                    else{
                        obj.fee = 0;
                    }
                }
                    break;
                default:
                    if (money > 0) {
                        obj.fee = 6600.0;
                    }
                    else{
                        obj.fee = 0;
                    }
                    break;
            }
            obj.soTien = money;
            obj.sdt = item.contact.phone;
            [arrData addObject: obj.toDict];
        }
    }
    NSString *sToken = @"";
    NSString *sOtpConfirm = @"";
    
    if(self.mTypeAuthenticate == TYPE_AUTHENTICATE_TOKEN)
    {
        NSString *sMatKhau = footer.txtOtp.text;
        sMatKhau = [DucNT_Token layMatKhauVanTayToken];
        
        NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
        sToken = [DucNT_Token OTPFromPIN:sMatKhau seed:sSeed];
    }
    else if(self.mTypeAuthenticate == TYPE_AUTHENTICATE_SMS )
    {
        sOtpConfirm = footer.txtOtp.text;
    }
    int giauViChuyen = 0;
    NSString *noidung = [footer.txtNoiDung.text stringByRemovingPercentEncoding];
    NSString *user = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    self.mDinhDanhKetNoi = DINH_DANH_CHUYEN_TIEN_DIEN_THOAI;
    NSDictionary *dictPost = @{
                               @"dsItem":arrData,
                               @"noiDung":noidung,
                               @"giauViChuyen":[NSNumber numberWithInt:giauViChuyen],
                               @"user" : user,
                               @"token" : sToken,
                               @"otpConfirm" : sOtpConfirm,
                               @"typeAuthenticate" : [NSNumber numberWithInt:self.mTypeAuthenticate],
                               @"appId" : [NSNumber numberWithInt:APP_ID]
                               };
    NSLog(@"%s - dicPost : %@", __FUNCTION__, [dictPost JSONString]);

    [GiaoDichMang chuyentienDienThoai:[dictPost JSONString] noiNhanKetQua:self];
    
}
-(void)ketNoiThanhCong:(NSString *)sKetQua
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [self anLoading];
    }

    NSLog(@"%s - sKetQua : %@", __FUNCTION__, sKetQua);
    NSDictionary *dicKQ = [sKetQua objectFromJSONString];
    int nCode = [[dicKQ objectForKey:@"msgCode"] intValue];
    NSString *sThongBao = [dicKQ objectForKey:@"msgContent"];
    if([self.mDinhDanhKetNoi isEqualToString: DINH_DANH_XAC_NHANH_CHUYEN_TIEN_DIEN_THOAI])
    {
        if(nCode == 1){
            // Thanh cong
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Chuyển tiền thành công"];
        }
        else{
            // Loi
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
        }
    }
    else if([self.mDinhDanhKetNoi isEqualToString:DINH_DANH_CHUYEN_TIEN_DIEN_THOAI] ){
        if(nCode == 1){
            // Thanh cong
            NSDictionary *result = [dicKQ objectForKey:@"result"];
            if(result != nil){
                NSString *idgiaodich = [result objectForKey:@"id"];
                NSArray *arr = [result objectForKey:@"dsItem"];
                for (MoneyContact *c in self.arrPhone) {
                    for (NSDictionary *dict in arr) {
                        if([c.contact.phone isEqualToString:[dict objectForKey:@"sdt"]]){
                            c.loaiMapping = [dict objectForKey:@"loaiMapping"];
                            c.soTienThanhToanHopLe = [[dict objectForKey:@"soTienThanhToanHopLe"] boolValue];
                        }
                    }
                }
                [self.tblContatcs reloadData];
            }
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Chuyển tiền thành công"];
        }
        else if(nCode == 190){
            NSDictionary *result = [dicKQ objectForKey:@"result"];
            if(result != nil){
                self.idGiaoDich = [result objectForKey:@"id"];
            }
            else{
                self.idGiaoDich = @"";
            }
            [self hienThiHopThoaiHaiNutBamKieu:198 cauThongBao:sThongBao];
            // Can confirm
        }
        else if(nCode == 48){
            // so tien k hop le
        }
        else{
            // Loi
            [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:sThongBao];
        }
    }
    else if([self.mDinhDanhKetNoi isEqualToString: @"LAY_MA_XAC_THUC"]){
        if(nCode == 31)
        {
            //Chay giay thong bao
            self.mTongSoThoiGian = THOI_GIAN_CHO_XAC_THUC_SMS;
            footer.lbCountTime.hidden = false;
            footer.lbTime.hidden = false;
            footer.txtOtp.hidden = false;
            footer.txtOtp.text = @"";
            footer.btnThucHien.hidden = false;
            footer.txtOtp.placeholder = @"Mã xác thực";

            [self batDauDemThoiGian];
        }
        else
        {
            [UIAlertView alert:sThongBao withTitle:[@"thong_bao" localizableString] block:nil];
        }
    }
}
- (IBAction)hienthisotaydienthoai:(id)sender {
    DanhsachsotayViewController * danhsach = [[[DanhsachsotayViewController alloc] initWithNibName:@"DanhsachsotayViewController" bundle:nil] autorelease];
    danhsach.delegate = self;
    [self.navigationController pushViewController:danhsach animated:YES];
}

- (void)dealloc {
    [_lblChuyenTienDienThoai release];
    [super dealloc];
}
-(UIImage*)getImageFromVi:(int)loaiMaping andManganhang:(NSString*)manganhang{
    switch (loaiMaping) {
        case 0:
            return [UIImage imageNamed:@"vimass"];
            break;
        case 1:
            return [UIImage imageNamed:@"air"];
            break;
        case 2:
            return [UIImage imageNamed:@"momo"];
            break;
        case 3:
            return [UIImage imageNamed:@"nganluong"];
            break;
        case 4:
            return [UIImage imageNamed:@"payoo"];
            break;
        case 5:
            return [UIImage imageNamed:@"viettel"];
            break;
        case 6:
            return [UIImage imageNamed:@"vimo"];
            break;
        case 7:
            return [UIImage imageNamed:@"viviet"];
            break;
        case 8:
            return [UIImage imageNamed:@"vnpt"];
            break;
        case 9:
            return [UIImage imageNamed:@"vtc"];
            break;
        case 10:
            return [UIImage imageNamed:@"zalo"];
            break;
        case 11:
            return [UIImage imageNamed:[manganhang lowercaseString]];
            break;
        case 12:
            return [UIImage imageNamed:[manganhang lowercaseString]];
            break;
        case 13:
            return [UIImage imageNamed:[manganhang lowercaseString]];
            break;
        default:
            return nil;
            break;
    }
}
- (void)didSeletedContact:(NSArray*)phoneContact andNoiDung:(NSString*)noidung {
    [self.arrPhone removeLastObject];
    [self.arrPhone addObjectsFromArray: phoneContact];
    dispatch_async(dispatch_get_main_queue(), ^{
        MoneyContact *footer = [MoneyContact new];
        self.strNoidung = noidung;
        footer.money = @"0";
        [self.arrPhone addObjectsFromArray:[NSArray arrayWithObject:footer]];
        [self.tblContatcs reloadData];
        [self calculateMoney];
    });
}
@end
