//
//  DucNT_TaiKhoanViObject.m
//  ViMASS
//
//  Created by MacBookPro on 7/17/14.
//
//

#import "DucNT_TaiKhoanViObject.h"
#import "DucNT_LuuRMS.h"
#import "JSONKit.h"
#import "Common.h"

NSString *const KEY_ACCOUNT_TEN_TAI_KHOAN = @"KEY_ACCOUNT_TEN_TAI_KHOAN";
NSString *const KEY_ACCOUNT_TEN_NGAN_HANG = @"KEY_ACCOUNT_TEN_NGAN_HANG";
NSString *const KEY_ACCOUNT_TEN_CMND = @"KEY_ACCOUNT_TEN_CMND";
NSString *const KEY_ACCOUNT_THU_DIEN_TU = @"KEY_ACCOUNT_THU_DIEN_TU";
NSString *const KEY_ACCOUNT_NGAY_SINH = @"KEY_ACCOUNT_NGAY_SINH";
NSString *const KEY_ACCOUNT_CMND = @"KEY_ACCOUNT_CMND";
NSString *const KEY_ACCOUNT_NGAY_CAP_CMND = @"KEY_ACCOUNT_NGAY_CAP_CMND";
NSString *const KEY_ACCOUNT_NOI_CAP_CMND = @"KEY_ACCOUNT_NOI_CAP_CMND";
NSString *const KEY_ACCOUNT_DIA_CHI_NHA = @"KEY_ACCOUNT_DIA_CHI_NHA";
NSString *const KEY_ACCOUNT_LINK_ANH_TRUOC = @"KEY_ACCOUNT_LINK_ANH_TRUOC";
NSString *const KEY_ACCOUNT_LINK_ANH_SAU = @"KEY_ACCOUNT_LINK_ANH_SAU";
NSString *const KEY_ACCOUNT_LINK_CHU_KY = @"KEY_ACCOUNT_LINK_CHU_KY";
NSString *const KEY_ACCOUNT_LINK_NAME_ALIAS = @"KEY_ACCOUNT_LINK_NAME_ALIAS";
NSString *const KEY_ACCOUNT_PHONE = @"KEY_ACCOUNT_PHONE";
NSString *const KEY_ACCOUNT_LINK_ANH_DAI_DIEN = @"KEY_ACCOUNT_LINK_ANH_DAI_DIEN";
NSString *const KEY_ACCOUNT_PHONE_AUTHENTICATE = @"KEY_ACCOUNT_PHONE_AUTHENTICATE";
NSString *const KEY_ACCOUNT_PHONE_TOKEN = @"KEY_ACCOUNT_PHONE_TOKEN";
NSString *const KEY_ACCOUNT_PASS = @"KEY_ACCOUNT_PASS";
NSString *const KEY_ACCOUNT_ID = @"KEY_ACCOUNT_ID";
NSString *const KEY_ACCOUNT_IS_TOKEN = @"KEY_ACCOUNT_IS_TOKEN";
NSString *const KEY_ACCOUNT_AMOUNT = @"KEY_ACCOUNT_AMOUNT";
NSString *const KEY_ACCOUNT_PROMOTION_STATUS = @"KEY_ACCOUNT_PROMOTION_STATUS";
NSString *const KEY_ACCOUNT_PROMOTION_TOTAL = @"KEY_ACCOUNT_PROMOTION_TOTAL";

NSString *const KEY_ACCOUNT_SECSSION = @"KEY_ACCOUNT_SECSSION";
NSString *const KEY_ACCOUNT_START = @"KEY_ACCOUNT_START";
NSString *const KEY_ACCOUNT_STATUS = @"KEY_ACCOUNT_STATUS";
NSString *const KEY_ACCOUNT_TOTALGIFT = @"KEY_ACCOUNT_TOTALGIFT";
NSString *const KEY_ACCOUNT_TOTALCREATEGIFT = @"KEY_ACCOUNT_TOTALCREATEGIFT";
NSString *const KEY_ACCOUNT_UID = @"KEY_ACCOUNT_UID";


NSString *const KEY_ACCOUNT_ACC_TYPE = @"KEY_ACCOUNT_ACC_TYPE";
NSString *const KEY_ACCOUNT_COMPANY_CODE = @"KEY_ACCOUNT_COMPANY_CODE";
NSString *const KEY_ACCOUNT_COMPANY_NAME = @"KEY_ACCOUNT_COMPANY_NAME";
NSString *const KEY_ACCOUNT_IMAGE_COMPANY_1 = @"KEY_ACCOUNT_IMAGE_COMPANY_1";
NSString *const KEY_ACCOUNT_IMAGE_COMPANY_2 = @"KEY_ACCOUNT_IMAGE_COMPANY_2";
NSString *const KEY_ACCOUNT_NAME_REPRESENT = @"KEY_ACCOUNT_NAME_REPRESENT";
NSString *const KEY_ACCOUNT_ROLES = @"KEY_ACCOUNT_ROLES";
NSString *const KEY_ACCOUNT_TK_RUT_TIEN = @"KEY_ACCOUNT_TK_RUT_TIEN";

NSString *const KEY_ACCOUNT_WALLET_ID = @"KEY_ACCOUNT_WALLET_ID";
NSString *const KEY_ACCOUNT_WALLET_LOGIN = @"KEY_ACCOUNT_WALLET_LOGIN";

NSString *const KEY_ACCOUNT_WALLET_LOGIN_EMAIL = @"KEY_ACCOUNT_WALLET_LOGIN_EMAIL";
NSString *const KEY_ACCOUNT_WALLET_LOGIN_NAME = @"KEY_ACCOUNT_WALLET_LOGIN_NAME";
NSString *const KEY_DS_LAP = @"KEY_DS_LAP";
NSString *const KEY_DS_DUYET = @"KEY_DS_DUYET";
NSString *const KEY_SDT_NGUOI_DUYET = @"KEY_SDT_NGUOI_DUYET";
NSString *const KEY_EMAIL_NGUOI_DUYET = @"KEY_EMAIL_NGUOI_DUYET";

NSString *const KEY_HAN_MUC_VI_VIMASS = @"KEY_HAN_MUC_VI_VIMASS";
NSString *const KEY_HAN_MUC_TAI_KHOAN = @"KEY_HAN_MUC_TAI_KHOAN";
NSString *const KEY_HAN_MUC_THE = @"KEY_HAN_MUC_THE";
NSString *const KEY_HAN_MUC_VI_KHAC = @"KEY_HAN_MUC_VI_KHAC";
NSString *const KEY_LINK_QR = @"KEY_LINK_QR";
NSString *const HIEN_NOI_DUNG_QR_CODE = @"HIEN_NOI_DUNG_QR_CODE";
NSString *const KEY_PKI = @"PKI";
NSString *const KEY_HAN_MUC_PKI = @"HAN_MUC_PKI";

NSString *const KEY_ID_SOFT_TOKEN = @"KEY_ID_SOFT_TOKEN";
NSString *const KEY_ID_VAN_TAY = @"KEY_ID_VAN_TAY";
NSString *const KEY_ID_MPKI = @"KEY_ID_MPKI";

NSString *const KEY_HAN_MUC_AMOUNT_DAY_SOFT_TOKEN = @"KEY_HAN_MUC_AMOUNT_DAY_SOFT_TOKEN";
NSString *const KEY_HAN_MUC_AMOUNT_TIME_SOFT_TOKEN = @"KEY_HAN_MUC_AMOUNT_TIME_SOFT_TOKEN";
NSString *const KEY_HAN_MUC_AMOUNT_DAY_SOFT_TOKEN_MAX = @"KEY_HAN_MUC_AMOUNT_DAY_SOFT_TOKEN_MAX";
NSString *const KEY_HAN_MUC_AMOUNT_TIME_SOFT_TOKEN_MAX = @"KEY_HAN_MUC_AMOUNT_TIME_SOFT_TOKEN_MAX";

NSString *const KEY_HAN_MUC_AMOUNT_DAY_VAN_TAY = @"KEY_HAN_MUC_AMOUNT_DAY_VAN_TAY";
NSString *const KEY_HAN_MUC_AMOUNT_TIME_VAN_TAY = @"KEY_HAN_MUC_AMOUNT_TIME_VAN_TAY";
NSString *const KEY_HAN_MUC_AMOUNT_DAY_VAN_TAY_MAX = @"KEY_HAN_MUC_AMOUNT_DAY_VAN_TAY_MAX";
NSString *const KEY_HAN_MUC_AMOUNT_TIME_VAN_TAY_MAX = @"KEY_HAN_MUC_AMOUNT_TIME_VAN_TAY_MAX";

NSString *const KEY_HAN_MUC_AMOUNT_DAY_MPKI = @"KEY_HAN_MUC_AMOUNT_DAY_MPKI";
NSString *const KEY_HAN_MUC_AMOUNT_TIME_MPKI = @"KEY_HAN_MUC_AMOUNT_TIME_MPKI";
NSString *const KEY_HAN_MUC_AMOUNT_DAY_MPKI_MAX = @"KEY_HAN_MUC_AMOUNT_DAY_MPKI_MAX";
NSString *const KEY_HAN_MUC_AMOUNT_TIME_MPKI_MAX = @"KEY_HAN_MUC_AMOUNT_TIME_MPKI_MAX";

NSString *const KEY_MA_DAI_LY = @"KEY_MA_DAI_LY";
//roles = "{\"list\":[{\"nguoiLapGiaoDich\":1,\"nguoiDuyetGiaoDich\":0,\"funcId\":1},{\"nguoiLapGiaoDich\":1,\"nguoiDuyetGiaoDich\":0,\"funcId\":420},{\"nguoiLapGiaoDich\":1,\"nguoiDuyetGiaoDich\":0,\"funcId\":421},{\"nguoiLapGiaoDich\":1,\"nguoiDuyetGiaoDich\":0,\"funcId\":403},{\"nguoiLapGiaoDich\":1,\"nguoiDuyetGiaoDich\":0,\"funcId\":406},{\"nguoiLapGiaoDich\":1,\"nguoiDuyetGiaoDich\":0,\"funcId\":414},{\"nguoiLapGiaoDich\":1,\"nguoiDuyetGiaoDich\":0,\"funcId\":415}],\"administrator\":0}";



@implementation DucNT_TaiKhoanViObject

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.sTenTaiKhoan = [decoder decodeObjectForKey:KEY_ACCOUNT_TEN_TAI_KHOAN];
        self.sTenNganHang = [decoder decodeObjectForKey:KEY_ACCOUNT_TEN_NGAN_HANG];
        self.sTenCMND = [decoder decodeObjectForKey:KEY_ACCOUNT_TEN_CMND];
        self.sThuDienTu = [decoder decodeObjectForKey:KEY_ACCOUNT_THU_DIEN_TU];
        self.sNgaySinh = [decoder decodeObjectForKey:KEY_ACCOUNT_NGAY_SINH];
        self.sCMND = [decoder decodeObjectForKey:KEY_ACCOUNT_CMND];
        self.sNgayCapCMND = [decoder decodeObjectForKey:KEY_ACCOUNT_NGAY_CAP_CMND];
        self.sNoiCapCMND = [decoder decodeObjectForKey:KEY_ACCOUNT_NOI_CAP_CMND];
        self.sDiaChiNha = [decoder decodeObjectForKey:KEY_ACCOUNT_DIA_CHI_NHA];
        self.sLinkAnhTruocCMND = [decoder decodeObjectForKey:KEY_ACCOUNT_LINK_ANH_TRUOC];
        self.sLinkAnhSauCMND = [decoder decodeObjectForKey:KEY_ACCOUNT_LINK_ANH_SAU];
        self.sLinkAnhChuKy = [decoder decodeObjectForKey:KEY_ACCOUNT_LINK_CHU_KY];
        self.sNameAlias = [decoder decodeObjectForKey:KEY_ACCOUNT_LINK_NAME_ALIAS];
        self.sPhone = [decoder decodeObjectForKey:KEY_ACCOUNT_PHONE];
        self.sLinkAnhDaiDien = [decoder decodeObjectForKey:KEY_ACCOUNT_LINK_ANH_DAI_DIEN];
        self.sPhoneAuthenticate = [decoder decodeObjectForKey:KEY_ACCOUNT_PHONE_AUTHENTICATE];
        self.sPhoneToken = [decoder decodeObjectForKey:KEY_ACCOUNT_PHONE_TOKEN];
        self.sPass = [decoder decodeObjectForKey:KEY_ACCOUNT_PASS];
        self.sID = [decoder decodeObjectForKey:KEY_ACCOUNT_ID];
        self.nIsToken = [decoder decodeObjectForKey:KEY_ACCOUNT_IS_TOKEN];
        self.nAmount = [decoder decodeObjectForKey:KEY_ACCOUNT_AMOUNT];
        self.nPromotionStatus = [decoder decodeObjectForKey:KEY_ACCOUNT_PROMOTION_STATUS];
        self.nPromotionTotal = [decoder decodeObjectForKey:KEY_ACCOUNT_PROMOTION_TOTAL];
        
        self.secssion = [decoder decodeObjectForKey:KEY_ACCOUNT_SECSSION];
        self.start = [decoder decodeObjectForKey:KEY_ACCOUNT_START];
        self.status = [decoder decodeObjectForKey:KEY_ACCOUNT_STATUS];
        self.toTalGift = [decoder decodeObjectForKey:KEY_ACCOUNT_TOTALGIFT];
        self.totalCreateGift = [decoder decodeObjectForKey:KEY_ACCOUNT_TOTALCREATEGIFT];
        self.uId = [decoder decodeObjectForKey:KEY_ACCOUNT_UID];

        self.accType = [decoder decodeObjectForKey:KEY_ACCOUNT_ACC_TYPE];
        self.companyCode = [decoder decodeObjectForKey:KEY_ACCOUNT_COMPANY_CODE];
        self.companyName = [decoder decodeObjectForKey:KEY_ACCOUNT_COMPANY_NAME];
        self.imageCompany1 = [decoder decodeObjectForKey:KEY_ACCOUNT_IMAGE_COMPANY_1];
        self.imageCompany2 = [decoder decodeObjectForKey:KEY_ACCOUNT_IMAGE_COMPANY_2];
        self.nameRepresent = [decoder decodeObjectForKey:KEY_ACCOUNT_NAME_REPRESENT];
        self.roles = [decoder decodeObjectForKey:KEY_ACCOUNT_ROLES];
        self.tKRutTien = [decoder decodeObjectForKey:KEY_ACCOUNT_TK_RUT_TIEN];
        
        self.walletId = [decoder decodeObjectForKey:KEY_ACCOUNT_WALLET_ID];
        self.walletLogin = [decoder decodeObjectForKey:KEY_ACCOUNT_WALLET_LOGIN];
        self.walletLoginName = [decoder decodeObjectForKey:KEY_ACCOUNT_WALLET_LOGIN_NAME];
        self.walletLoginEmail = [decoder decodeObjectForKey:KEY_ACCOUNT_WALLET_LOGIN_EMAIL];
        self.dsLap = [decoder decodeObjectForKey:KEY_DS_LAP];
        self.dsDuyet = [decoder decodeObjectForKey:KEY_DS_DUYET];
        self.sdtNguoiDuyet = [decoder decodeObjectForKey:KEY_SDT_NGUOI_DUYET];
        self.sEmail = [decoder decodeObjectForKey:KEY_EMAIL_NGUOI_DUYET];

        self.nHanMucDenViKhac = [decoder decodeObjectForKey:KEY_HAN_MUC_VI_KHAC];
        self.nHanMucDenVi = [decoder decodeObjectForKey:KEY_HAN_MUC_VI_VIMASS];
        self.nHanMucDenTaiKhoan = [decoder decodeObjectForKey:KEY_HAN_MUC_TAI_KHOAN];
        self.nHanMucDenThe = [decoder decodeObjectForKey:KEY_HAN_MUC_THE];
        self.linkQR = [decoder decodeObjectForKey:KEY_LINK_QR];
        self.hienThiNoiDungThanhToanQR = [decoder decodeObjectForKey:HIEN_NOI_DUNG_QR_CODE];
        self.pki3 = [decoder decodeObjectForKey:KEY_PKI];
        self.hanMucPki3 = [decoder decodeObjectForKey:KEY_HAN_MUC_PKI];

        self.idSoftToken = [decoder decodeObjectForKey:KEY_ID_SOFT_TOKEN];
        self.hanMucTimeSoftToken = [decoder decodeObjectForKey:KEY_HAN_MUC_AMOUNT_TIME_SOFT_TOKEN];
        self.hanMucDaySoftToken = [decoder decodeObjectForKey:KEY_HAN_MUC_AMOUNT_DAY_SOFT_TOKEN];
        self.hanMucTimeSoftTokenMax = [decoder decodeObjectForKey:KEY_HAN_MUC_AMOUNT_TIME_SOFT_TOKEN_MAX];
        self.hanMucDaySoftTokenMax = [decoder decodeObjectForKey:KEY_HAN_MUC_AMOUNT_DAY_SOFT_TOKEN_MAX];
        
        self.idVantay = [decoder decodeObjectForKey:KEY_ID_VAN_TAY];
        self.hanMucTimeVanTay = [decoder decodeObjectForKey:KEY_HAN_MUC_AMOUNT_TIME_VAN_TAY];
        self.hanMucDayVanTay = [decoder decodeObjectForKey:KEY_HAN_MUC_AMOUNT_DAY_VAN_TAY];
        self.hanMucTimeVanTayMax = [decoder decodeObjectForKey:KEY_HAN_MUC_AMOUNT_TIME_VAN_TAY_MAX];
        self.hanMucDayVanTayMax = [decoder decodeObjectForKey:KEY_HAN_MUC_AMOUNT_DAY_VAN_TAY_MAX];
        
        self.idMPKI = [decoder decodeObjectForKey:KEY_ID_MPKI];
        self.hanMucTimeMPKI = [decoder decodeObjectForKey:KEY_HAN_MUC_AMOUNT_TIME_MPKI];
        self.hanMucDayMPKI = [decoder decodeObjectForKey:KEY_HAN_MUC_AMOUNT_DAY_MPKI];
        self.hanMucTimeMPKIMax = [decoder decodeObjectForKey:KEY_HAN_MUC_AMOUNT_TIME_MPKI_MAX];
        self.hanMucDayMPKIMax = [decoder decodeObjectForKey:KEY_HAN_MUC_AMOUNT_DAY_MPKI_MAX];
        
        self.maDaiLy = [decoder decodeObjectForKey:KEY_MA_DAI_LY];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.pki3 forKey:KEY_PKI];
    [encoder encodeObject:self.hanMucPki3 forKey:KEY_HAN_MUC_PKI];
    [encoder encodeObject:self.sTenTaiKhoan forKey:KEY_ACCOUNT_TEN_TAI_KHOAN];
    [encoder encodeObject:self.sTenNganHang forKey:KEY_ACCOUNT_TEN_NGAN_HANG];
    [encoder encodeObject:self.sTenCMND forKey:KEY_ACCOUNT_TEN_CMND];
    [encoder encodeObject:self.sThuDienTu forKey:KEY_ACCOUNT_THU_DIEN_TU];
    [encoder encodeObject:self.sNgaySinh forKey:KEY_ACCOUNT_NGAY_SINH];
    [encoder encodeObject:self.sCMND forKey:KEY_ACCOUNT_CMND];
    [encoder encodeObject:self.sNgayCapCMND forKey:KEY_ACCOUNT_NGAY_CAP_CMND];
    [encoder encodeObject:self.sNoiCapCMND forKey:KEY_ACCOUNT_NOI_CAP_CMND];
    [encoder encodeObject:self.sDiaChiNha forKey:KEY_ACCOUNT_DIA_CHI_NHA];
    [encoder encodeObject:self.sLinkAnhTruocCMND forKey:KEY_ACCOUNT_LINK_ANH_TRUOC];
    [encoder encodeObject:self.sLinkAnhSauCMND forKey:KEY_ACCOUNT_LINK_ANH_SAU];
    [encoder encodeObject:self.sLinkAnhChuKy forKey:KEY_ACCOUNT_LINK_CHU_KY];
    [encoder encodeObject:self.sNameAlias forKey:KEY_ACCOUNT_LINK_NAME_ALIAS];
    [encoder encodeObject:self.sPhone forKey:KEY_ACCOUNT_PHONE];
    [encoder encodeObject:self.sLinkAnhDaiDien forKey:KEY_ACCOUNT_LINK_ANH_DAI_DIEN];
    [encoder encodeObject:self.sPhoneAuthenticate forKey:KEY_ACCOUNT_PHONE_AUTHENTICATE];
    [encoder encodeObject:self.sPhoneToken forKey:KEY_ACCOUNT_PHONE_TOKEN];
    [encoder encodeObject:self.sPass forKey:KEY_ACCOUNT_PASS];
    [encoder encodeObject:self.sID forKey:KEY_ACCOUNT_ID];
    [encoder encodeObject:self.nIsToken forKey:KEY_ACCOUNT_IS_TOKEN];
    [encoder encodeObject:self.nAmount forKey:KEY_ACCOUNT_AMOUNT];
    [encoder encodeObject:self.nPromotionStatus forKey:KEY_ACCOUNT_PROMOTION_STATUS];
    [encoder encodeObject:self.nPromotionTotal forKey:KEY_ACCOUNT_PROMOTION_TOTAL];
    
    [encoder encodeObject:self.secssion forKey:KEY_ACCOUNT_SECSSION];
    [encoder encodeObject:self.start forKey:KEY_ACCOUNT_START];
    [encoder encodeObject:self.status forKey:KEY_ACCOUNT_STATUS];
    [encoder encodeObject:self.toTalGift forKey:KEY_ACCOUNT_TOTALGIFT];
    [encoder encodeObject:self.totalCreateGift forKey:KEY_ACCOUNT_TOTALCREATEGIFT];
    [encoder encodeObject:self.uId forKey:KEY_ACCOUNT_UID];
    
    [encoder encodeObject:self.accType forKey:KEY_ACCOUNT_ACC_TYPE];
    [encoder encodeObject:self.companyCode forKey:KEY_ACCOUNT_COMPANY_CODE];

    [encoder encodeObject:self.companyName forKey:KEY_ACCOUNT_COMPANY_NAME];
    [encoder encodeObject:self.imageCompany1 forKey:KEY_ACCOUNT_IMAGE_COMPANY_1];
    [encoder encodeObject:self.imageCompany2 forKey:KEY_ACCOUNT_IMAGE_COMPANY_2];
    [encoder encodeObject:self.nameRepresent forKey:KEY_ACCOUNT_NAME_REPRESENT];
    [encoder encodeObject:self.roles forKey:KEY_ACCOUNT_ROLES];
    [encoder encodeObject:self.walletId forKey:KEY_ACCOUNT_WALLET_ID];
    [encoder encodeObject:self.walletLogin forKey:KEY_ACCOUNT_WALLET_LOGIN];
    
    [encoder encodeObject:self.walletLoginEmail forKey:KEY_ACCOUNT_WALLET_LOGIN_EMAIL];
    [encoder encodeObject:self.walletLoginName forKey:KEY_ACCOUNT_WALLET_LOGIN_NAME];
    [encoder encodeObject:self.dsLap forKey:KEY_DS_LAP];
    [encoder encodeObject:self.dsDuyet forKey:KEY_DS_DUYET];
    [encoder encodeObject:self.sdtNguoiDuyet forKey:KEY_SDT_NGUOI_DUYET];
    [encoder encodeObject:self.sEmail forKey:KEY_EMAIL_NGUOI_DUYET];
    [encoder encodeObject:self.tKRutTien forKey:KEY_ACCOUNT_TK_RUT_TIEN];

    [encoder encodeObject:self.nHanMucDenViKhac forKey:KEY_HAN_MUC_VI_KHAC];
    [encoder encodeObject:self.nHanMucDenVi forKey:KEY_HAN_MUC_VI_VIMASS];
    [encoder encodeObject:self.nHanMucDenTaiKhoan forKey:KEY_HAN_MUC_TAI_KHOAN];
    [encoder encodeObject:self.nHanMucDenThe forKey:KEY_HAN_MUC_THE];
    [encoder encodeObject:self.linkQR forKey:KEY_LINK_QR];
    [encoder encodeObject:self.hienThiNoiDungThanhToanQR forKey:HIEN_NOI_DUNG_QR_CODE];

    [encoder encodeObject:self.idSoftToken forKey:KEY_ID_SOFT_TOKEN];
    [encoder encodeObject:self.hanMucTimeSoftToken forKey:KEY_HAN_MUC_AMOUNT_TIME_SOFT_TOKEN];
    [encoder encodeObject:self.hanMucDaySoftToken forKey:KEY_HAN_MUC_AMOUNT_DAY_SOFT_TOKEN];
    [encoder encodeObject:self.hanMucTimeSoftTokenMax forKey:KEY_HAN_MUC_AMOUNT_TIME_SOFT_TOKEN_MAX];
    [encoder encodeObject:self.hanMucDaySoftTokenMax forKey:KEY_HAN_MUC_AMOUNT_DAY_SOFT_TOKEN_MAX];
    
    [encoder encodeObject:self.idVantay forKey:KEY_ID_VAN_TAY];
    [encoder encodeObject:self.hanMucTimeVanTay forKey:KEY_HAN_MUC_AMOUNT_TIME_VAN_TAY];
    [encoder encodeObject:self.hanMucDayVanTay forKey:KEY_HAN_MUC_AMOUNT_DAY_VAN_TAY];
    [encoder encodeObject:self.hanMucTimeVanTayMax forKey:KEY_HAN_MUC_AMOUNT_TIME_VAN_TAY_MAX];
    [encoder encodeObject:self.hanMucDayVanTayMax forKey:KEY_HAN_MUC_AMOUNT_DAY_VAN_TAY_MAX];
    
    [encoder encodeObject:self.idMPKI forKey:KEY_ID_MPKI];
    [encoder encodeObject:self.hanMucTimeMPKI forKey:KEY_HAN_MUC_AMOUNT_TIME_MPKI];
    [encoder encodeObject:self.hanMucDayMPKI forKey:KEY_HAN_MUC_AMOUNT_DAY_MPKI];
    [encoder encodeObject:self.hanMucTimeMPKIMax forKey:KEY_HAN_MUC_AMOUNT_TIME_MPKI_MAX];
    [encoder encodeObject:self.hanMucDayMPKIMax forKey:KEY_HAN_MUC_AMOUNT_DAY_MPKI_MAX];
    
    [encoder encodeObject:self.maDaiLy forKey:KEY_MA_DAI_LY];
}

- (id)initWithDict:(NSDictionary *)dict
{
//    NSLog(@"%s - %s : dict : %@", __FILE__, __FUNCTION__, dict);
    self = [super init];
    if(self)
    {
        NSString *acc_name = [dict objectForKey:@"acc_name"];
        if(acc_name)
        {
            self.sTenCMND = acc_name;
            self.sTenTaiKhoan = acc_name;
        }
        else
        {
            self.sTenCMND = @"";
            self.sTenTaiKhoan = @"";
        }
        
        NSString *accBank = [dict objectForKey:@"accBank"];
        if(accBank)
            self.sTenNganHang = accBank;
        else
            self.sTenNganHang = @"";
        
        NSString *emailTemp = [dict objectForKey:@"email"];
        if (emailTemp) {
            self.sEmail = emailTemp;
        }
        else
            self.sEmail = @"";
        
        NSString *idCard = [dict objectForKey:@"idCard"];
        if(idCard)
            self.sCMND = idCard;
        else
            self.sCMND = @"";
        
        NSString *dateIdCard = [dict objectForKey:@"dateIdCard"];
        if(dateIdCard)
            self.sNgayCapCMND = dateIdCard;
        else
            self.sNgayCapCMND = @"";
        
        NSString *placeIdCard = [dict objectForKey:@"placeIdCard"];
        if(placeIdCard)
        {
            self.sNoiCapCMND = placeIdCard;
        }
        else
            self.sNoiCapCMND = @"";
        
        NSString *birthday = [dict objectForKey:@"birthday"];
        if(birthday)
            self.sNgaySinh = birthday;
        else
            self.sNgaySinh = @"";
        
        NSString *linkFrontIdCard = [dict objectForKey:@"linkFrontIdCard"];
        if(linkFrontIdCard)
            self.sLinkAnhTruocCMND = linkFrontIdCard;
        else
            self.sLinkAnhTruocCMND = @"";
        
        NSString *linkBackIdCard = [dict objectForKey:@"linkBackIdCard"];
        if(linkBackIdCard)
            self.sLinkAnhSauCMND = linkBackIdCard;
        else
            self.sLinkAnhSauCMND = @"";
        
        NSString *linkSignature = [dict objectForKey:@"linkSignature"];
        if(linkSignature)
            self.sLinkAnhChuKy = linkSignature;
        else
            self.sLinkAnhChuKy = @"";
        
        NSString *avatar = [dict objectForKey:@"avatar"];
        if(avatar)
            self.sLinkAnhDaiDien = avatar;
        else
            self.sLinkAnhDaiDien = @"";
        
        NSString *home = [dict objectForKey:@"home"];
        if(home)
            self.sDiaChiNha = home;
        else
            self.sDiaChiNha = @"";
        

        NSNumber *isToken = [dict objectForKey:@"isToken"];
        if(isToken)
        {
            self.nIsToken = isToken;
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_TRANG_THAI_CO_TOKEN value:[NSString stringWithFormat:@"%@", isToken]];
        }
        else
            self.nIsToken = [NSNumber numberWithInt:0];
        
        NSString *sID = [dict objectForKey:@"id"];
        if(sID)
        {
            self.sID = sID;
        }
        else
            self.sID = @"";
        
        NSString *sNameAlias = [dict objectForKey:@"nameAlias"];
        if(sNameAlias)
        {
            self.sNameAlias = sNameAlias;
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_NAME_ALIAS value:sNameAlias];
        }
        else
        {
            self.sNameAlias = @"";
        }
        
        NSString *sPhone = [dict objectForKey:@"phone"];
        if(sPhone)
        {
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_ID_ACC value:sPhone];
            self.sPhone = sPhone;
        }
        else
        {
            self.sPhone = @"";
        }
        
        NSString *sPhoneAuthenticate = [dict objectForKey:@"phoneAuthenticate"];
        if (sPhoneAuthenticate)
        {
            self.sPhoneAuthenticate = sPhoneAuthenticate;
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_PHONE_AUTHENTICATE value:sPhoneAuthenticate];
        }
        else
        {
            self.sPhoneAuthenticate = @"";
        }
        
        NSString *sEmail = [dict objectForKey:@"email"];
        if(sEmail)
        {
            self.sThuDienTu = sEmail;
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_EMAIL_AUTHENTICATE value:sEmail];
        }
        else
        {
            self.sThuDienTu = @"";
        }
        
        NSString *sPhoneToken = [dict objectForKey:@"phoneToken"];
        if(sPhoneToken)
        {
            self.sPhoneToken = sPhoneToken;
            [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_SO_DIEN_THOAI_DANG_KI_TOKEN value:sPhoneToken];
        }
        else
        {
            self.sPhoneToken = @"";
        }
        
        NSNumber *nAmount = [dict objectForKey:@"amount"];
        if(nAmount)
        {
            self.nAmount = nAmount;
        }
        else
        {
            self.nAmount = [NSNumber numberWithDouble:0.0f];
        }
        
        NSNumber *nPromotionStatus = [dict objectForKey:@"promotionStatus"];
        if(nPromotionStatus)
        {
            self.nPromotionStatus = nPromotionStatus;
        }
        else
        {
            self.nPromotionStatus = [NSNumber numberWithInt:0];
        }
        
        NSNumber *nPromotionTotal = [dict objectForKey:@"promotionTotal"];
        if(nPromotionTotal)
        {
            self.nPromotionTotal = nPromotionTotal;
        }
        else
        {
            self.nPromotionTotal = [NSNumber numberWithInt:0];
        }
        
        NSString *secssion = [dict objectForKey:@"secssion"];
        if(secssion)
        {
            self.secssion = secssion;
        }
        else
            self.secssion = @"";
        
        NSNumber *start = [dict objectForKey:@"start"];
        if(start)
        {
            self.start = start;
        }
        else
        {
            self.start = [NSNumber numberWithInt:0];
        }
        
        NSNumber *status = [dict objectForKey:@"status"];
        if(status)
        {
            self.status = status;
        }
        else
        {
            self.status = [NSNumber numberWithInt:0];
        }
        
        NSNumber *toTalGift = [dict objectForKey:@"toTalGift"];
        if(toTalGift)
        {
            self.toTalGift = toTalGift;
        }
        else
        {
            self.toTalGift = [NSNumber numberWithInt:0];
        }
        
        NSNumber *totalCreateGift = [dict objectForKey:@"totalCreateGift"];
        if(totalCreateGift)
        {
            self.totalCreateGift = totalCreateGift;
        }
        else
        {
            self.totalCreateGift = [NSNumber numberWithInt:0];
        }
        
        NSNumber *uId = [dict objectForKey:@"uId"];
        if(uId)
        {
            self.uId = uId;
        }
        else
        {
            self.uId = [NSNumber numberWithInt:0];
        }

        NSNumber *accType = [dict valueForKey:@"accType"];
        if(accType)
        {
            self.accType = accType;
        }
        else
        {
            self.accType = [NSNumber numberWithInt:-1];
        }
        
        NSString *companyCode = [dict valueForKey:@"companyCode"];
        if(companyCode)
            self.companyCode = companyCode;
        else
            self.companyCode = @"";
        
        NSString *companyName = [dict valueForKey:@"companyName"];
        if(companyName)
            self.companyName = companyName;
        else
            self.companyName = @"";
        
        NSString *imageCompany1 = [dict valueForKey:@"imageCompany1"];
        if(imageCompany1)
            self.imageCompany1 = imageCompany1;
        else
            self.imageCompany1 = @"";
        
        NSString *imageCompany2 = [dict valueForKey:@"imageCompany2"];
        if(imageCompany2)
            self.imageCompany2 = imageCompany2;
        else
            self.imageCompany2 = @"";

        NSString *nameRepresent = [dict valueForKey:@"nameRepresent"];
        if(nameRepresent)
            self.nameRepresent = nameRepresent;
        else
            self.nameRepresent = @"";

        NSString *roles = [dict valueForKey:@"roles"];
        if(roles)
        {
            NSDictionary *dictRoles = [roles objectFromJSONString];
            QuyenCuaTaiKhoan *quyenCuaTaiKhoan = [[QuyenCuaTaiKhoan alloc] initWithDict:dictRoles];
            self.roles = quyenCuaTaiKhoan;
            [quyenCuaTaiKhoan release];
        }
        else
        {
            self.roles = [[QuyenCuaTaiKhoan alloc] init];
        }

        NSDictionary *dictRutTien = [dict valueForKey:@"tKRutTien"];
        if(dictRutTien)
        {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictRutTien options:NSJSONWritingPrettyPrinted error:&error];
            if (! jsonData) {
                self.tKRutTien = @"";
            } else {
                self.tKRutTien = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
        }
        else
        {
            self.tKRutTien = @"";
        }

        NSDictionary *dicHanMuc = [dict objectForKey:@"hanMucGiaoDich"];
        NSArray *arrHanMuc = [dicHanMuc objectForKey:@"transactionLimits"];
        if (arrHanMuc) {
            NSLog(@"%s - arrHanMuc : %ld", __FUNCTION__, (unsigned long)arrHanMuc.count);
            self.nHanMucDenVi = [NSNumber numberWithDouble:0.0];
            self.nHanMucDenThe = [NSNumber numberWithDouble:0.0];
            self.nHanMucDenTaiKhoan = [NSNumber numberWithDouble:0.0];
            self.nHanMucDenViKhac = [NSNumber numberWithDouble:0.0];
            for (NSDictionary *temp in arrHanMuc) {
                NSNumber *typeTranfer = [temp objectForKey:@"typeTransfer"];
                NSNumber *oneTime = [temp objectForKey:@"oneTime"];
                if ([typeTranfer intValue] == TRANSACTION_LIMIT_TO_ACCOUNT) {
                    self.nHanMucDenTaiKhoan = oneTime;
                }
                else if ([typeTranfer intValue] == TRANSACTION_LIMIT_TO_CARD) {
                    self.nHanMucDenThe = oneTime;
                }
                else if ([typeTranfer intValue] == TRANSACTION_LIMIT_TO_WALLET) {
                    self.nHanMucDenVi = oneTime;
                }
                else if ([typeTranfer intValue] == TRANSACTION_LIMIT_TO_VI_KHAC) {
                    self.nHanMucDenViKhac = oneTime;
                }
            }
        }
        
        NSDictionary *dicHanMucVimass = [dict objectForKey:@"hanMucViDienTuVimass"];
        NSArray *arrHanMucVimass = [dicHanMucVimass objectForKey:@"dsHanMuc"];
        if (arrHanMucVimass) {
            self.hanMucTimeSoftToken = [NSNumber numberWithDouble:0.0];
            self.hanMucDaySoftToken = [NSNumber numberWithDouble:0.0];
            self.hanMucTimeSoftTokenMax = [NSNumber numberWithDouble:0.0];
            self.hanMucDaySoftTokenMax = [NSNumber numberWithDouble:0.0];
            //
            self.hanMucTimeVanTay = [NSNumber numberWithDouble:0.0];
            self.hanMucDayVanTay = [NSNumber numberWithDouble:0.0];
            self.hanMucTimeVanTayMax = [NSNumber numberWithDouble:0.0];
            self.hanMucDayVanTayMax = [NSNumber numberWithDouble:0.0];
            //
            self.hanMucTimeMPKI = [NSNumber numberWithDouble:0.0];
            self.hanMucDayMPKI = [NSNumber numberWithDouble:0.0];
            self.hanMucTimeMPKIMax = [NSNumber numberWithDouble:0.0];
            self.hanMucDayMPKIMax = [NSNumber numberWithDouble:0.0];
            for (NSDictionary *temp in arrHanMucVimass) {
                NSNumber *level = [temp objectForKey:@"level"];
                NSNumber *amountDay = [temp objectForKey:@"amountDay"];
                NSNumber *amountTime = [temp objectForKey:@"amountTime"];
                NSNumber *maxAmountDay = [temp objectForKey:@"maxAmountDay"];
                NSNumber *maxAmountTime = [temp objectForKey:@"maxAmountTime"];
                NSString *sIDHanMucTemp = [temp valueForKey:@"id"];
                if ([level intValue] == 1) {
                    self.idSoftToken = sIDHanMucTemp;
                    self.hanMucTimeSoftToken = amountTime;
                    self.hanMucDaySoftToken = amountDay;
                    self.hanMucTimeSoftTokenMax = maxAmountTime;
                    self.hanMucDaySoftTokenMax = maxAmountDay;
                }
                else if ([level intValue] == 3){
                    self.idVantay = sIDHanMucTemp;
                    self.hanMucTimeVanTay = amountTime;
                    self.hanMucDayVanTay = amountDay;
                    self.hanMucTimeVanTayMax = maxAmountTime;
                    self.hanMucDayVanTayMax = maxAmountDay;
                }
                else if ([level intValue] == 5){
                    self.idMPKI = sIDHanMucTemp;
                    self.hanMucTimeMPKI = amountTime;
                    self.hanMucDayMPKI = amountDay;
                    self.hanMucTimeMPKIMax = maxAmountTime;
                    self.hanMucDayMPKIMax = maxAmountDay;
                }
            }
        }
        
        NSString *walletId = [dict valueForKey:@"walletId"];
        if(walletId)
            self.walletId = walletId;
        else
            self.walletId = @"";
        
        NSString *walletLogin = [dict valueForKey:@"walletLogin"];
        if(walletLogin)
            self.walletLogin = walletLogin;
        else
            self.walletLogin = @"";
        
        NSString *walletLoginEmail = [dict valueForKey:@"walletLoginEmail"];
        if(walletLoginEmail)
            self.walletLoginEmail = walletLoginEmail;
        else
            self.walletLoginEmail = @"";
        NSString *walletLoginName = [dict valueForKey:@"walletLoginName"];
        if(walletLoginName)
            self.walletLoginName = walletLoginName;
        else
            self.walletLoginName = @"";
        
        NSString *dsLapTemp = [dict valueForKey:@"dsLap"];
//        NSLog(@"%s - %s : dsLapTemp : %@", __FILE__, __FUNCTION__, dsLapTemp);
        if(dsLapTemp)
            self.dsLap = dsLapTemp;
        else
            self.dsLap = @"";
        
        NSString *dsDuyetTemp = [dict valueForKey:@"dsDuyet"];
        if(dsDuyetTemp)
            self.dsDuyet = dsDuyetTemp;
        else
            self.dsDuyet = @"";
        
        NSString *sdtDuyet = [dict valueForKey:@"nguoiDuyet"];
//        NSLog(@"%s - %s : sdtDuyet : %@", __FILE__, __FUNCTION__, sdtDuyet);
        if(sdtDuyet)
            self.sdtNguoiDuyet = sdtDuyet;
        else
            self.sdtNguoiDuyet = @"";

        NSString *linkQRTemp = [dict valueForKey:@"linkQR"];
        NSLog(@"%s - %s : linkQRTemp : %@", __FILE__, __FUNCTION__, linkQRTemp);
        if (linkQRTemp) {
            self.linkQR = linkQRTemp;
        }
        else
            self.linkQR = @"";
        NSNumber *hienThiNoiDung = [dict objectForKey:@"hienThiNoiDungThanhToanQR"];
        NSLog(@"%s - hienThiNoiDung : %@", __FUNCTION__, hienThiNoiDung);
        if(hienThiNoiDung)
        {
            self.hienThiNoiDungThanhToanQR = hienThiNoiDung;
        }
        else
        {
            self.hienThiNoiDungThanhToanQR = [NSNumber numberWithInt:0];
        }
        NSLog(@"%s - hienThiNoiDungThanhToanQR : %@", __FUNCTION__, self.hienThiNoiDungThanhToanQR);
        NSNumber *hanmucPKI = [dict objectForKey:@"hanMucPki3"];
        NSString *pki3 = [dict objectForKey:@"pki3"];
        self.pki3 = pki3;
        self.hanMucPki3 = hanmucPKI;
        
        NSDictionary *objectPhanQuyenBenhVien = [dict objectForKey:@"objectPhanQuyenBenhVien"];
        self.maDaiLy = [objectPhanQuyenBenhVien objectForKey:@"maDaiLy"];
    }
    return self;
}

- (BOOL)layQuyenDuocDuyetGiaoDichTrongChucNang:(int)nFuncID
{
    NSLog(@"%s - nFuncID : %d - _roles.list.count : %d", __FUNCTION__, nFuncID, (int)_roles.list.count);
    NSLog(@"======================");
    for(Quyen *quyen in _roles.list)
    {
        NSLog(@"%s - [quyen.funcId intValue] : %d", __FUNCTION__, [quyen.funcId intValue]);
        if([quyen.funcId intValue] == nFuncID)
        {
            NSLog(@"%s - [quyen.nguoiDuyetGiaoDich intValue] : %d", __FUNCTION__, [quyen.nguoiDuyetGiaoDich intValue]);
            if([quyen.nguoiDuyetGiaoDich intValue] > 0)
                return YES;
        }
    }
    return NO;
}

- (BOOL)layQuyenDuocLapGiaoDichTrongChucNang:(int)nFuncID
{
    for(Quyen *quyen in _roles.list)
    {
        if([quyen.funcId intValue] == nFuncID)
        {
            if([quyen.nguoiLapGiaoDich intValue] > 0)
                return YES;
        }
    }
    return NO;
}

- (BOOL)kiemTraCoThuDienTu
{
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    NSString *sThuDienTu = @"";
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sThuDienTu = _walletLoginEmail;
    }
    else if(nKieuDangNhap == KIEU_CA_NHAN)
    {
        sThuDienTu = _sThuDienTu;
    }
    if(sThuDienTu)
        return [Common kiemTraLaMail:sThuDienTu];
    
    return NO;
}


- (NSString*)layThuDienTu
{
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    NSString *sThuDienTu = @"";
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sThuDienTu = _walletLoginEmail;
    }
    else if(nKieuDangNhap == KIEU_CA_NHAN)
    {
        sThuDienTu = _sThuDienTu;
    }
    if(sThuDienTu)
        return sThuDienTu;
    return @"";
}

- (void)dealloc
{
    [_walletLoginEmail release];
    [_walletLoginName release];
    [_accType release];
    [_companyCode release];
    [_companyName release];
    [_imageCompany1 release];
    [_imageCompany2 release];
    [_nameRepresent release];
    [_roles release];
    [_walletId release];
    [_walletLogin release];
    [_sID release];
    [_sTenTaiKhoan release];
    [_sTenNganHang release];
    [_sTenCMND release];
    [_sNgaySinh release];
    [_sThuDienTu release];
    [_sCMND release];
    [_sNoiCapCMND release];
    [_sNgayCapCMND release];
    [_sDiaChiNha release];
    [_sLinkAnhTruocCMND release];
    [_sLinkAnhSauCMND release];
    [_sLinkAnhChuKy release];
    [_sLinkAnhDaiDien release];
    [_sNameAlias release];
    [_sPhone release];
    [_sPhoneAuthenticate release];
    [_sPass release];
    [_sPhoneToken release];
    [_nIsToken release];
    [_nAmount release];
    [_nHanMucDenVi release];
    [_nHanMucDenThe release];
    [_nHanMucDenViKhac release];
    [_nHanMucDenTaiKhoan release];
    [_nPromotionStatus release];
    [_nPromotionTotal release];
    [_secssion release];
    [_start release];
    [_status release];
    [_toTalGift release];
    [_totalCreateGift release];
    [_uId release];
    [_dsDuyet release];
    [_dsLap release];
    [_sEmail release];
    [_tKRutTien release];
    [_linkQR release];
    [self.hanMucTimeSoftToken release];
    [self.hanMucDaySoftToken release];
    [self.hanMucTimeSoftTokenMax release];
    [self.hanMucDaySoftTokenMax release];
    //
    [self.hanMucTimeVanTay release];
    [self.hanMucDayVanTay release];
    [self.hanMucTimeVanTayMax release];
    [self.hanMucDayVanTayMax release];
    //
    [self.hanMucTimeMPKI release];
    [self.hanMucDayMPKI release];
    [self.hanMucTimeMPKIMax release];
    [self.hanMucDayMPKIMax release];
    
    [self.maDaiLy release];
    [super dealloc];
}

@end
