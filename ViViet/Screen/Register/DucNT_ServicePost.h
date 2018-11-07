//
//  DucNT_ServicePost.h
//  ViMASS
//
//  Created by MacBookPro on 7/3/14.
//
//

#import <Foundation/Foundation.h>
#import <Foundation/NSURLConnection.h>
#import <Foundation/NSURLRequest.h>
#import <Foundation/NSURLResponse.h>

#define LINK_ADD_ACC_USED @"https://vimass.vn/vmbank/services/account/addAccUsed"
#define LINK_KIEM_TRA_ACC_DA_THUOC_DANH_BA @"https://vimass.vn/vmbank/services/account/checkAccount"


extern NSString *const LINK_BASE;
extern NSString *const LINK_DANG_NHAP;
extern NSString *const LINK_DANG_NHAP_TAI_KHOAN_KHAC;
extern NSString *const LINK_DANG_KY_TAI_KHOAN;
extern NSString *const LINK_DANG_KY_TOKEN;
extern NSString *const LINK_DANG_KY_TOKEN_TAI_KHOAN_KHAC;
extern NSString *const LINK_XAC_THUC_DANG_KY_TAI_KHOAN;
extern NSString *const LINK_XAC_THUC_DANG_KY_TOKEN;
extern NSString *const LINK_XAC_THUC_QUEN_MAT_KHAU_TOKEN;
extern NSString *const LINK_QUEN_MAT_KHAU_TOKEN;
extern NSString *const LINK_DOI_MAT_KHAU_TOKEN;
extern NSString *const LINK_LAY_THONG_TIN_SAO_KE;

@protocol DucNT_ServicePostDelegate<NSObject>
@required
-(void)ketNoiThanhCong:(NSString *)sKetQua;
@optional
-(void)ketNoiThanhCong:(NSString*)sDinhDanh ketQua:(NSString *)sKetQua;
//-(void)ketNoiBatThanh;
@end

@interface DucNT_ServicePost : NSObject<NSURLConnectionDataDelegate>
{
    NSString *mDinhDanh;
    NSMutableData *receiveData;
    int mShowAlert;
}

- (id)initWithDinhDanh:(NSString*)sDinhDanh;

- (void)connect:(NSString *)sUrl withContent:(NSString *) sContent;

- (void)connectDiaDiem:(NSString *)sUrl withContent:(NSString *) sContent;
- (void)connectPost:(NSString *)sUrl withContent:(NSString *)sContent timeOut:(double)fTimeOut;
- (void)connectGetWithTimeout:(int)timeOut sUrl:(NSString *)sUrl withContent:(NSString *)sContent;
- (void)connectGet:(NSString *)sUrl withContent:(NSString *) sContent;
-(void)connectGet:(int)timeOut sUrl:(NSString *)sUrl withContent:(NSString *)sContent;
- (void)connectGet:(NSString *)sUrl withContent:(NSString *) sContent showAlert:(BOOL)isShow;

+ (NSData*)connectGet:(NSString *)sUrl withContent:(NSString *) sContent showAlert:(BOOL)isShow;

@property (nonatomic, assign) id <DucNT_ServicePostDelegate> ducnt_connectDelegate;
//@property (nonatomic, retain) NSMutableData *receiveData;

@property (nonatomic, assign) bool bEncryptData;

@end
