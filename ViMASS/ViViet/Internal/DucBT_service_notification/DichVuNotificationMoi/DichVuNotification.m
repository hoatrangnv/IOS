//
//  DichVuNotification.m
//  ViMASS
//
//  Created by DucBT on 10/14/14.
//
//

#import "DichVuNotification.h"
#import "DucNT_LuuRMS.h"
#import "JSONKit.h"
#import "Common.h"

@implementation DichVuNotification

+ (id)shareService
{
    static DichVuNotification *sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[self alloc] init];
    });
    return sharedService;
}

- (void)dichVuDangKyThietBi:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sDeviceToken = [DucNT_LuuRMS layThongTinDangNhap:KEY_DEVICE_TOKEN];
    NSLog(@"%s - sDeviceToken : %@", __FUNCTION__, sDeviceToken);
    if(sDeviceToken.length > 0)
    {
        NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
        if(sTaiKhoan.length == 0)
            sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_ID_LOGIN];

        if(sTaiKhoan.length > 0)
        {
            NSDictionary *dicPost = @{
                                      @"deviceId":sDeviceToken,
                                      @"id":@"",
                                      @"deviceOS":@"2",
                                      @"phone":sTaiKhoan,
                                      @"appId":[NSString stringWithFormat:@"%d", APP_ID]
                                      };
            NSLog(@"%s - [dicPost JSONString] : %@", __FUNCTION__, [dicPost JSONString]);
            DucNT_ServicePost *connectUpDeviceToken = [[DucNT_ServicePost alloc] init];
            NSString *sUrl = [NSString stringWithFormat:@"%@/%@", BASE_URL_SERVICE_NOTIFICATION, @"addDevice"];
            [connectUpDeviceToken connect:sUrl
                              withContent:[dicPost JSONString]];
            connectUpDeviceToken.ducnt_connectDelegate = noiNhanKetQua;
            [connectUpDeviceToken release];
        }
    }
}


- (void)dichVuLayDanhSachTinNhanTrongChucNang: (int)nFuncID
                                     thoiGian: (long long)time
                                  viTriBatDau: (int)nViTri
                                   soLuongTin: (int)nSoLuong
                                    nguoiNhan: (NSString*)sNguoiNhan
                                  kieuTimKiem: (int)nKieuTimKiem
                              phanLoaiTinNhan: (NSString*)phanLoaiTinNhan
                                noiNhanKetQua: (id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
//    if(sTaiKhoan.length == 0)
//        sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_ID_LOGIN];
    
    if(sTaiKhoan.length > 0)
    {
        NSMutableString *mess = [[NSMutableString alloc] init];
        [mess appendFormat:@"funcId=%d&",nFuncID];
        [mess appendFormat:@"appId=%d&",APP_ID];
        [mess appendFormat:@"id=%@&",sTaiKhoan];
        [mess appendFormat:@"time=%lld&",time];
        [mess appendFormat:@"offset=%d&",nViTri];
        [mess appendFormat:@"limit=%d&", nSoLuong];
        [mess appendFormat:@"typeSearch=%d&", nKieuTimKiem];
        [mess appendFormat:@"session=%@", [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION]];
        if(sNguoiNhan.length > 0)
            [mess appendFormat:@"&send_to=%@", sNguoiNhan];
        [mess appendFormat:@"&phanLoaiTinNhan=%@", phanLoaiTinNhan];
        
        
        NSString *sUrl = [NSString stringWithFormat:@"%@/%@", BASE_URL_SERVICE_NOTIFICATION, @"getMess?"];
        DucNT_ServicePost *connectUpDeviceToken = [[DucNT_ServicePost alloc] init];
        [connectUpDeviceToken setDucnt_connectDelegate:noiNhanKetQua];
        [connectUpDeviceToken connectGet:[sUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] withContent:mess showAlert:YES];
        [connectUpDeviceToken release];
        [mess release];
    }
}

- (void)dichVuLayChiTietMotTin:(NSString*)sIDTin noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    if(sIDTin.length > 0)
    {
        NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
//        if(sTaiKhoan.length == 0)
//            sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_ID_LOGIN];
        if(sTaiKhoan.length > 0)
        {
            NSString *sUrl = [NSString stringWithFormat:@"%@/%@", BASE_URL_SERVICE_NOTIFICATION, @"getDetailMess?"];
            NSMutableString *mess = [[NSMutableString alloc] init];
            [mess appendFormat:@"messId=%@&", sIDTin];
            [mess appendFormat:@"id=%@&", sTaiKhoan];
            [mess appendFormat:@"session=%@", [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_SECSSION]];
            DucNT_ServicePost *connectGetDetailNotification = [[DucNT_ServicePost alloc] init];
            [connectGetDetailNotification setDucnt_connectDelegate:noiNhanKetQua];
            [connectGetDetailNotification connectGet:sUrl withContent:mess];
            [connectGetDetailNotification release];
            [mess release];
        }
    }
}

- (void)dichVuChatVoi: (NSString*)sNguoiNhan
              tinNhan: (NSString*)sTinNhan
               tieuDe: (NSString*)sTieuDe
             chucNang: (int)nFuncID
        noiNhanKetQua: (id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
//    if(sTaiKhoan.length == 0)
//        sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_ID_LOGIN];
    if(sTaiKhoan.length > 0)
    {
        NSDictionary *dicPost = @{
                                  @"phone":sTaiKhoan,
                                  @"send_to":sNguoiNhan,
                                  @"mess":sTinNhan,
                                  @"title":sTieuDe,
                                  @"appId":[NSString stringWithFormat:@"%d", APP_ID],
                                  @"funcId":[NSString stringWithFormat:@"%d", nFuncID]
                                  };
        
        DucNT_ServicePost *connectUpDeviceToken = [[DucNT_ServicePost alloc] init];
        NSString *sUrl = [NSString stringWithFormat:@"%@/%@", BASE_URL_SERVICE_NOTIFICATION, @"chat"];
        [connectUpDeviceToken connect:sUrl
                          withContent:[dicPost JSONString]];
        connectUpDeviceToken.ducnt_connectDelegate = noiNhanKetQua;
        [connectUpDeviceToken release];
    }

}

- (void)dichVuLayDanhSachNguoiChatTrongChucNang:(int)nFuncID noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
//    if(sTaiKhoan.length == 0)
//        sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_ID_LOGIN];
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_DINH_DANH_DOANH_NGHIEP];
    }
//    else if(nKieuDangNhap == KIEU_CA_NHAN)
//    {
//        sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
//    }
    if(sTaiKhoan.length > 0)
    {
        NSDictionary *dicPost = @{
                                  @"phone":sTaiKhoan,
                                  @"appId":[NSString stringWithFormat:@"%d", APP_ID],
                                  @"funcId":[NSString stringWithFormat:@"%d", nFuncID]
                                  };
        
        DucNT_ServicePost *connectUpDeviceToken = [[DucNT_ServicePost alloc] init];
        NSString *sUrl = [NSString stringWithFormat:@"%@/%@", BASE_URL_SERVICE_NOTIFICATION, @"getContactChat1"];
        [connectUpDeviceToken connect:sUrl
                          withContent:[dicPost JSONString]];
        connectUpDeviceToken.ducnt_connectDelegate = noiNhanKetQua;
        [connectUpDeviceToken release];
    }
}

- (void)dichVuXoaTinNhan:(NSArray*)mDanhSachIDTinCanXoa noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
//    if(sTaiKhoan.length == 0)
//        sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_ID_LOGIN];
    if(sTaiKhoan.length > 0)
    {
        NSDictionary *dicPost = @{
                                  @"phone" : sTaiKhoan,
                                  @"id" : mDanhSachIDTinCanXoa
                                  };
        DucNT_ServicePost *connectUpDeviceToken = [[DucNT_ServicePost alloc] init];
        NSString *sUrl = [NSString stringWithFormat:@"%@/%@", BASE_URL_SERVICE_NOTIFICATION, @"deleteMess"];
        [connectUpDeviceToken connect:sUrl
                          withContent:[dicPost JSONString]];
        connectUpDeviceToken.ducnt_connectDelegate = noiNhanKetQua;
        [connectUpDeviceToken release];
    }
}

- (void)dichVuDanhDauAllTin: (long long)nThoiGianDocTin
                      trongChucNang: (int)nFuncID
                      noiNhanKetQua: (id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    //    if(sTaiKhoan.length == 0)
    //        sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_ID_LOGIN];
    if(sTaiKhoan.length > 0)
    {
        NSMutableString *mess = [[NSMutableString alloc] init];
        [mess appendFormat:@"id=%@&",sTaiKhoan];
        [mess appendFormat:@"appId=%d&",APP_ID];
        [mess appendFormat:@"funcId=%d&",nFuncID];
        [mess appendFormat:@"time=%lld",nThoiGianDocTin];
        NSString *sUrl = [NSString stringWithFormat:@"%@/%@", BASE_URL_SERVICE_NOTIFICATION, @"checkReadAll?"];
        DucNT_ServicePost *connectUpDeviceToken = [[DucNT_ServicePost alloc] init];
        [connectUpDeviceToken setDucnt_connectDelegate:noiNhanKetQua];
        [connectUpDeviceToken connectGet:sUrl withContent:mess showAlert:NO];
        [connectUpDeviceToken release];
        [mess release];
    }
}

- (void)dichVuDanhDauThoiGianDocTin: (long long)nThoiGianDocTin
                      trongChucNang: (int)nFuncID
                             doiTac: (NSString*)sDoiTac
                      noiNhanKetQua: (id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
//    if(sTaiKhoan.length == 0)
//        sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_ID_LOGIN];
    if(sTaiKhoan.length > 0)
    {
        NSMutableString *mess = [[NSMutableString alloc] init];
        [mess appendFormat:@"id=%@&",sTaiKhoan];
        [mess appendFormat:@"appId=%d&",APP_ID];
        [mess appendFormat:@"funcId=%d&",nFuncID];
        [mess appendFormat:@"time=%lld",nThoiGianDocTin];
        if(sDoiTac.length > 0)
            [mess appendFormat:@"&idDoiTac=%@",sDoiTac];
        NSString *sUrl = [NSString stringWithFormat:@"%@/%@", BASE_URL_SERVICE_NOTIFICATION, @"checkPoint?"];
        DucNT_ServicePost *connectUpDeviceToken = [[DucNT_ServicePost alloc] init];
        [connectUpDeviceToken setDucnt_connectDelegate:noiNhanKetQua];
        [connectUpDeviceToken connectGet:sUrl withContent:mess showAlert:NO];
        [connectUpDeviceToken release];
        [mess release];
    }
}

- (void)dichVuDanhDauThoiGianDocTin: (long long)nThoiGianDocTin
                      trongChucNang: (int)nFuncID
                             doiTac: (NSString*)sDoiTac
                          showAlert:(BOOL)show
                      noiNhanKetQua: (id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    //    if(sTaiKhoan.length == 0)
    //        sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_ID_LOGIN];
    if(sTaiKhoan.length > 0)
    {
        NSMutableString *mess = [[NSMutableString alloc] init];
        [mess appendFormat:@"id=%@&",sTaiKhoan];
        [mess appendFormat:@"appId=%d&",APP_ID];
        [mess appendFormat:@"funcId=%d&",nFuncID];
        [mess appendFormat:@"time=%lld",nThoiGianDocTin];
        if(sDoiTac.length > 0)
            [mess appendFormat:@"&idDoiTac=%@",sDoiTac];
        NSString *sUrl = [NSString stringWithFormat:@"%@/%@", BASE_URL_SERVICE_NOTIFICATION, @"checkPoint?"];
        DucNT_ServicePost *connectUpDeviceToken = [[DucNT_ServicePost alloc] init];
        [connectUpDeviceToken setDucnt_connectDelegate:noiNhanKetQua];
        [connectUpDeviceToken connectGet:sUrl withContent:mess showAlert:show];
        [connectUpDeviceToken release];
        [mess release];
    }
}

- (void)dichVuLaySoLuongTinChuaDocTrongKieu:(int)nFuncID
                              noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
//    if(sTaiKhoan.length == 0)
//        sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_ID_LOGIN];
    
    if(sTaiKhoan.length > 0)
    {
        NSMutableString *mess = [[NSMutableString alloc] init];
        [mess appendFormat:@"id=%@&",sTaiKhoan];
        [mess appendFormat:@"appId=%d&",APP_ID];
        [mess appendFormat:@"funcId=%d",nFuncID];
        
        NSString *sUrl = [NSString stringWithFormat:@"%@/%@", BASE_URL_SERVICE_NOTIFICATION, @"getBadge?"];
        DucNT_ServicePost *connectUpDeviceToken = [[DucNT_ServicePost alloc] init];
        [connectUpDeviceToken setDucnt_connectDelegate:noiNhanKetQua];
        [connectUpDeviceToken connectGet:sUrl withContent:mess showAlert:NO];
        [connectUpDeviceToken release];
        [mess release];
    }
}

- (void)dichVuCheckVersion:(id<DucNT_ServicePostDelegate>)noiNhanKetQua{
    NSString *sUrl = @"https://vimass.vn/vmbank/services/flag/iosLoginGg";
    DucNT_ServicePost *connectUpDeviceToken = [[DucNT_ServicePost alloc] init];
    [connectUpDeviceToken setDucnt_connectDelegate:noiNhanKetQua];
    [connectUpDeviceToken connectGet:sUrl withContent:@"" showAlert:NO];
    [connectUpDeviceToken release];
}

- (void)dichVuDoiTenGiaoDich:(NSString*)sTenGiaoDichMoi
                     account:(NSString*)sTenAccount
                        pass:(NSString*)sPass
               noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhanKetQua
{
    NSDictionary *dicPost = @{
                              @"user":sTenAccount,
                              @"pass":sPass,
                              @"nameAlias":sTenGiaoDichMoi,
                              };
    
    
    DucNT_ServicePost *connectUpDeviceToken = [[DucNT_ServicePost alloc] init];
    NSString *sUrl = @"https://vimass.vn/vmbank/services/account/changeNameAlias";
    [connectUpDeviceToken connect:sUrl
                      withContent:[dicPost JSONString]];
    connectUpDeviceToken.ducnt_connectDelegate = noiNhanKetQua;
    [connectUpDeviceToken release];
}


- (void)dichVuXacNhanTrangThaiTinNotificationMuonTien:(NSString*)sIdMess
                                            trangThai:(int)nStatusShow
                                        noiNhanKetQua:(id<DucNT_ServicePostDelegate>)noiNhan
{
    NSString *sContent = [NSString stringWithFormat:@"idMess=%@&statusShow=%d", sIdMess, nStatusShow];
    NSString *sUrl = [NSString stringWithFormat:@"%@/%@", BASE_URL_SERVICE_NOTIFICATION, @"confirmLoanMessage?"];
    DucNT_ServicePost *connectUpDeviceToken = [[DucNT_ServicePost alloc] init];
    [connectUpDeviceToken setDucnt_connectDelegate:noiNhan];
    [connectUpDeviceToken connectGet:sUrl withContent:sContent];
    [connectUpDeviceToken release];
}

#pragma mark - client

- (BOOL)kiemTraDaDangKiThietBi
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    if(sTaiKhoan.length == 0)
        sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_ID_LOGIN];
    if(sTaiKhoan.length > 0)
    {
        NSString *sTrangThaiDangKiThietBi = [DucNT_LuuRMS layThongTinDangNhap:KEY_TRANG_THAI_DANG_KI_THIET_BI];
        if (sTrangThaiDangKiThietBi.length > 0)
        {
            NSArray *arr = [sTrangThaiDangKiThietBi componentsSeparatedByString:@"::"];
            NSString *sTaiKhoanTruoc = [arr objectAtIndex:1];
            
            if([sTaiKhoanTruoc isEqualToString:sTaiKhoan])
                return YES;
        }
    }
    return NO;
}

- (void)xacNhanDangKiThietBi
{
    NSString *sDeviceToken = [DucNT_LuuRMS layThongTinDangNhap:KEY_DEVICE_TOKEN];
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    if(sTaiKhoan.length == 0)
        sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_ID_LOGIN];
    
    if(sDeviceToken.length > 0 && sTaiKhoan.length > 0)
    {
        NSString *sTrangThaiDangKiThietBi = [NSString stringWithFormat:@"%@::%@", sDeviceToken, sTaiKhoan];
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_TRANG_THAI_DANG_KI_THIET_BI value:sTrangThaiDangKiThietBi];
    }
}

- (void)luuSoLuongTinChuaDoc:(NSString *)sJsonSoLuongTinChuaDoc
{
    [DucNT_LuuRMS luuThongTinDangNhap:KEY_LUU_SO_LUONG_TIN_CHUA_DOC value:sJsonSoLuongTinChuaDoc];
}

- (int)laySoLuongTinChuaDocTrongChucNang:(int)nFuncID
{
    int nTongSoLuongTinChuaDoc = 0;
    NSString *sJsonString = [DucNT_LuuRMS layThongTinDangNhap:KEY_LUU_SO_LUONG_TIN_CHUA_DOC];
//    NSLog(@"%s - sJsonString : %@", __FUNCTION__, sJsonString);
    if(sJsonString.length > 0)
    {
        NSArray *arr = [sJsonString objectFromJSONString];

        for (NSDictionary *dict in arr)
        {
            if(nFuncID != 0)
            {
                int _nFuncID = [[dict objectForKey:@"funcId"] intValue];
                if(_nFuncID == nFuncID)
                {
                    int badge = [[dict objectForKey:@"badge"] intValue];
                    return badge;
                }
            }
            else
            {
                int _nFuncID = [[dict objectForKey:@"funcId"] intValue];
                if(_nFuncID == 1 || _nFuncID == 2)
                {
                    int badge = [[dict objectForKey:@"badge"] intValue];
                    nTongSoLuongTinChuaDoc += badge;
                }
            }
        }
    }
    return nTongSoLuongTinChuaDoc;
}

- (void)tangGiaTriBagdeNumberChoChucNang:(int)nFuncID
{
    int nGiaTriBagdeNumberCu = [self laySoLuongTinChuaDocTrongChucNang:nFuncID];
    int nGiaTriBagdeNumberMoi = nGiaTriBagdeNumberCu + 1;

    NSString *sJsonString = [self thayGiaTriBadgeNumberCu:nGiaTriBagdeNumberCu bangGiaTriMoi:nGiaTriBagdeNumberMoi trongChucNang:nFuncID];

    [self luuSoLuongTinChuaDoc:sJsonString];
}

- (void)xacNhanDaDocTinTrongChucNang:(int)nFuncID
{
    NSLog(@"%s ====================> START", __FUNCTION__);
    int nGiaTriBagdeNumberCu = [self laySoLuongTinChuaDocTrongChucNang:nFuncID];
    int nGiaTriBagdeNumberMoi = 0;
    
    NSString *sJsonString = [self thayGiaTriBadgeNumberCu:nGiaTriBagdeNumberCu bangGiaTriMoi:nGiaTriBagdeNumberMoi trongChucNang:nFuncID];
    NSLog(@"%s - sJsonString : %@", __FUNCTION__, sJsonString);
    [self luuSoLuongTinChuaDoc:sJsonString];
}

- (void)dichVuXacNhanDaDocTatCaCacTin
{
    for(int i = 0; i < 20; i ++)
    {
        [self xacNhanDaDocTinTrongChucNang:i];
    }
}

- (NSString*)thayGiaTriBadgeNumberCu:(int)nGiaTriCu bangGiaTriMoi:(int)nGiaTriMoi trongChucNang:(int)nFuncID
{
    NSString *sJsonString = [DucNT_LuuRMS layThongTinDangNhap:KEY_LUU_SO_LUONG_TIN_CHUA_DOC];
    NSString *pattern = [NSString stringWithFormat:@"(\"badge\" : %d),\n( *)(\"funcId\" : %d)", nGiaTriCu, nFuncID];
    NSError  *error  = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern: pattern
                                  options: 0
                                  error: &error];
    
    NSRange range = [regex rangeOfFirstMatchInString: sJsonString
                                             options: 0
                                               range: NSMakeRange(0, [sJsonString length])];
    if(range.location != NSNotFound)
    {
        NSString *sXauCu = [sJsonString substringWithRange:range];
        NSString *sXauMoi = [sXauCu stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"\"badge\" : %d", nGiaTriCu]
                                                              withString:[NSString stringWithFormat:@"\"badge\" : %d", nGiaTriMoi]];
        sJsonString = [sJsonString stringByReplacingOccurrencesOfString:sXauCu withString:sXauMoi];
    }
    return sJsonString;
}

@end
