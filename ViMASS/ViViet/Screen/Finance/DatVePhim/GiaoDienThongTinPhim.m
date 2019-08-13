//
//  GiaoDienThongTinPhim.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/22/15.
//
//

#import "GiaoDienThongTinPhim.h"
#import "HuongDanNapTienViewController.h"
#import "NapViTuTheNganHangViewController.h"

@interface GiaoDienThongTinPhim () <UIWebViewDelegate>

@end

@implementation GiaoDienThongTinPhim

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addButtonBack];
    self.webThongTin.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.itemFilmHienTai) {
//        self.navigationItem.title = self.itemFilmHienTai.tenPhim;
        [self addTitleView:[self.itemFilmHienTai.tenPhim stringByReplacingOccurrencesOfString:@"&#8805;" withString:@"≥"]];
        NSString *html = @"<img src=\"%@\" align=\"center\"><p><strong>Khởi chiếu:</strong>%@</p><p><strong>Thời lượng:</strong>%@ phút</p><p><strong>Đạo diễn:</strong>%@</p><p><strong>Diễn viên:</strong>%@</p><p><strong>Ngôn ngữ:</strong>%@</p><p><strong>Quốc gia:</strong>%@</p><p><strong>Thể loại:</strong>%@</p><p style=\"line-height: 23px;\"><strong>Nội dung:</strong>%@</p><p style=\"clear:both\"></p>";
        html = [NSString stringWithFormat:html, self.itemFilmHienTai.anhDaiDien, self.itemFilmHienTai.ngayKhoiChieu, self.itemFilmHienTai.thoiLuong, self.itemFilmHienTai.daoDien, self.itemFilmHienTai.dienVien, self.itemFilmHienTai.ngonNgu, self.itemFilmHienTai.quocGia, self.itemFilmHienTai.theLoai, self.itemFilmHienTai.noiDung];
        [self.webThongTin loadHTMLString:html baseURL:nil];
    }
    else{
//        self.navigationItem.title = @"Hướng dẫn";
        [self addTitleView:@"Hướng dẫn"];
        NSURL *url;
        NSString *html = @"";
        if (self.nOption == HUONG_DAN_XEM_FILM) {
            url = [[NSBundle mainBundle] URLForResource:@"huongdandatvephim" withExtension:@"html"];
        }
        else if (self.nOption == 2) {
            url = [[NSBundle mainBundle] URLForResource:@"huongdandatvemaybay" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_SACOMBANK) {
            url = [[NSBundle mainBundle] URLForResource:@"huongdan_chuyentien_atm_sacombank" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_TECHCOMBANK) {
            url = [[NSBundle mainBundle] URLForResource:@"huongdan_chuyentien_atm_techcombank" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_VIETINBANK) {
            url = [[NSBundle mainBundle] URLForResource:@"huongdan_chuyentien_atm_vietinbank" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_NAP_RUT_TIEN) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_rut_tien" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_NAP_TIEN_BANG_THE) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_nap_vi_tu_the_noi_dia" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_NAP_TIEN_BANG_QUOC_TE) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_nap_vi_tu_the_quoc_te" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_NAP_TIEN_BANG_THE_CAO) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_nap_vi_tu_the_cao" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_NAP_TIEN_HOC_PHI) {
             url = [[NSBundle mainBundle] URLForResource:@"hd_tt_hoc_phi" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_CHUYEN_TIEN_VI_VIMASS) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_chuyen_tien_vi_vimass" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_CHUYEN_TIEN_TAI_KHOAN) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_chuyen_tien_den_tai_khoan" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_CHUYEN_TIEN_THE) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_chuyen_tien_den_the_ngan_hang" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_CHUYEN_TIEN_VI_KHAC) {
            url = [[NSBundle mainBundle] URLForResource:@"gioi_thieu_chuyen_tien_den_vi_khac" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_CHUYEN_TIEN_CMND) {
            url = [[NSBundle mainBundle] URLForResource:@"gioi_thieu_chuyen_tien_den_cmnd" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_CHUYEN_TIEN_TAN_NHA) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_chuyen_tien_tan_nha" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_GUI_TIET_KIEM) {
            url = [[NSBundle mainBundle] URLForResource:@"gioi_thieu_gui_tiet_kiem" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_XEM_PHIM) {
            url = [[NSBundle mainBundle] URLForResource:@"gioi_thieu_gui_tiet_kiem" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_THANH_TOAN_DIEN_THOAI_VINA) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_dt_vinaphone" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_THANH_TOAN_DIEN_THOAI_VIETNAMOBILE) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_dt_vietnammobile" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_THANH_TOAN_DIEN_THOAI_VIETEL) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_dt_viettel" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_THANH_TOAN_DIEN_THOAI_MOBI) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_dt_mobiphone" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_THANH_TOAN_DIEN_THOAI_GMOBILE) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_dt_gmobile" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_THANH_TOAN_DIEN_THOAI_CO_DINH) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_dt_dtcd" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_THANH_TOAN_MUA_MA_THE) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_mua_ma_the" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_THANH_TOAN_DIEN) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_thanh_toan_dien" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_THANH_TOAN_NUOC) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_tt_nuoc" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_THANH_TOAN_INTERNET) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_tt_internet" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_THANH_TOAN_TRUYEN_HINH) {
            url = [[NSBundle mainBundle] URLForResource:@"huongthanhtoantruyenhinh" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_CHUNG_KHOAN) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_tt_chung_khoan" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_HOC_PHI) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_tt_hoc_phi" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_TRA_TIEN_VAY) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_tt_tra_tien_vay" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_TANG_QUA) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_tang_qua" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_PHONE_TOKEN) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_phone_token" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_MUON_TIEN) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_muon_tien" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_THAY_DOI_THONG_TIN_VI) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_thay_doi_tt_vi" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_THAY_DOI_THONG_TIN_VI) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_thay_doi_tt_vi" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_SAO_KE) {
            url = [[NSBundle mainBundle] URLForResource:@"huong_dan_sao_ke" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_DOI_HAN_MUC) {
            url = [[NSBundle mainBundle] URLForResource:@"huong_dan_thay_doi_han_muc" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_THANH_TOAN_TIEN_DIEN_TU) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_nap_tien_dien_tu" withExtension:@"html"];
        }
        else if (self.nOption == HUONG_DAN_CAP_LA_YEU_THUONG) {
            url = [[NSBundle mainBundle] URLForResource:@"cap_la_yeu_thuong" withExtension:@"html"];
//            HUONG_DAN_NHA_CHONG_LU = 42,
//            HUONG_DAN_CHAT_DOC_DA_CAM = 43,
//            HUONG_DAN_LANG_SOS = 44,
//            HUONG_DAN_BAO_TRO_TRE_EM = 45,
//            HUONG_DAN_HIEU_VE_TRAI_TIM = 46,
//            HUONG_DAN_NHAN_AI = 47,
//            HUONG_DAN_TRO_NGHEO_VUNG_CAO = 48,
//            HUONG_DAN_BAO_PHU_NU = 49,
//            HUONG_DAN_TU_THIEN_VIETNAMNET = 50,
//            HUONG_DAN_TRE_EM_KHUYET_TAT = 51,
//            HUONG_DAN_TAM_LONG_VANG = 52,
//            HUONG_DAN_OPERATION_SMILE = 53,
        }
        else if (self.nOption == HUONG_DAN_NHA_CHONG_LU) {
            url = [[NSBundle mainBundle] URLForResource:@"nha_chong_lu" withExtension:@"html"];

        }
        else if (self.nOption == HUONG_DAN_CHAT_DOC_DA_CAM) {
            url = [[NSBundle mainBundle] URLForResource:@"chat_doc_da_cam" withExtension:@"html"];

        }
        else if (self.nOption == HUONG_DAN_LANG_SOS) {
            url = [[NSBundle mainBundle] URLForResource:@"lang_tre_em_sos" withExtension:@"html"];

        }
        else if (self.nOption == HUONG_DAN_BAO_TRO_TRE_EM) {
            url = [[NSBundle mainBundle] URLForResource:@"quy_bao_tro_tre_em" withExtension:@"html"];

        }
        else if (self.nOption == HUONG_DAN_HIEU_VE_TRAI_TIM) {
            url = [[NSBundle mainBundle] URLForResource:@"quy_tim_hieu_trai_tim" withExtension:@"html"];

        }
        else if (self.nOption == HUONG_DAN_NHAN_AI) {
            url = [[NSBundle mainBundle] URLForResource:@"quy_nhan_ai_dantri" withExtension:@"html"];

        }
        else if (self.nOption == HUONG_DAN_TRO_NGHEO_VUNG_CAO) {
            url = [[NSBundle mainBundle] URLForResource:@"quy_tro_ngheo_vung_cao" withExtension:@"html"];

        }
        else if (self.nOption == HUONG_DAN_BAO_PHU_NU) {
            url = [[NSBundle mainBundle] URLForResource:@"quy_pn_tphcm" withExtension:@"html"];

        }
        else if (self.nOption == HUONG_DAN_TU_THIEN_VIETNAMNET) {
            url = [[NSBundle mainBundle] URLForResource:@"quy_tu_thien_vietnamnet" withExtension:@"html"];

        }
        else if (self.nOption == HUONG_DAN_TRE_EM_KHUYET_TAT) {
            url = [[NSBundle mainBundle] URLForResource:@"quy_vi_tre_em_khuyet_tat" withExtension:@"html"];

        }
        else if (self.nOption == HUONG_DAN_TAM_LONG_VANG) {
            url = [[NSBundle mainBundle] URLForResource:@"quy_tam_long_vang" withExtension:@"html"];

        }
        else if (self.nOption == HUONG_DAN_OPERATION_SMILE) {
            url = [[NSBundle mainBundle] URLForResource:@"operation_smile_vietnam" withExtension:@"html"];

        }
        else if (self.nOption == HUONG_DAN_SU_DUNG) {
            url = [[NSBundle mainBundle] URLForResource:@"hd_dang_nhap_vi" withExtension:@"html"];
        }
        else {
            url = nil;
        }

        NSError *error;
        html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (self.nOption == HUONG_DAN_SAO_KE) {
            html = [html stringByReplacingOccurrencesOfString:@"change_user" withString:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP]];
            html = [html stringByReplacingOccurrencesOfString:@"change_email" withString:self.mThongTinTaiKhoanVi.sEmail];
        }
//        NSLog(@"%s - html : %@", __FUNCTION__, html);
        NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"tamnv_hienthi"];

        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [self.webThongTin loadHTMLString:html baseURL:baseURL];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        NSURL *url = request.URL;
        NSLog(@"%s - url : %@", __FUNCTION__, url);
        if ([url.absoluteString isEqualToString:@"https://vimass.vn/vidientu/huong-dan-nap-tien.html"]) {
            NSLog(@"%s - chuyen sang huong dan nap tien", __FUNCTION__);
            HuongDanNapTienViewController *huongDanNapTienViewController = [[HuongDanNapTienViewController alloc] initWithNibName:@"HuongDanNapTienViewController" bundle:nil];
            [self.navigationController pushViewController:huongDanNapTienViewController animated:YES];
            [huongDanNapTienViewController release];
        }
        else if ([url.absoluteString isEqualToString:@"https://vimass.vn/vidientu/nap-vi.html"]) {
            NapViTuTheNganHangViewController *napViTuTheNganHangViewController = [[NapViTuTheNganHangViewController alloc] initWithNibName:@"NapViTuTheNganHangViewController" bundle:nil];
            [self.navigationController pushViewController:napViTuTheNganHangViewController animated:YES];
            [napViTuTheNganHangViewController release];
        }
        return NO;
    }
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_webThongTin release];
    [super dealloc];
}
@end
