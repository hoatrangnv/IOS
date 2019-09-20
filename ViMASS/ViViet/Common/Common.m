//
//  Common.m
//  ViMASSApp
//
//  Created by QUANGHIEP on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Common.h"
#import "RNCryptor.h"
#import "Static.h"
#import "LocalizationSystem.h"
#import "quicklz.h"
#import "UIDevice+IdentifierAddition.h"
#import "JSONKit.h"
#import <objc/runtime.h>
#import "Base64.h"

#define kJOB_WODK_LOCATION_JSON @"[{\"title\":\"TP.Hồ Chí Minh\",\"value\":5},{\"title\":\"Hà Nội\",\"value\":3},{\"title\":\"An Giang\",\"value\":6},{\"title\":\"Bạc Liêu\",\"value\":10},{\"title\":\"Bà Rịa-Vũng Tàu\",\"value\":7},{\"title\":\"Bắc Cạn\",\"value\":64},{\"title\":\"Bắc Giang\",\"value\":8},{\"title\":\"Bắc Ninh\",\"value\":11},{\"title\":\"Bến Tre\",\"value\":12},{\"title\":\"Bình Dương\",\"value\":14},{\"title\":\"Bình Định\",\"value\":13},{\"title\":\"Bình Phước\",\"value\":15},{\"title\":\"Bình Thuận\",\"value\":16},{\"title\":\"Cao Bằng\",\"value\":18},{\"title\":\"Cà Mau\",\"value\":17},{\"title\":\"Cần Thơ\",\"value\":1},{\"title\":\"Đà Nẵng\",\"value\":2},{\"title\":\"Đắk Lắk\",\"value\":19},{\"title\":\"Đắk Nông\",\"value\":20},{\"title\":\"Điện Biên\",\"value\":21},{\"title\":\"Đồng Nai\",\"value\":22},{\"title\":\"Đồng Tháp\",\"value\":23},{\"title\":\"Gia Lai\",\"value\":24},{\"title\":\"Hà Giang\",\"value\":25},{\"title\":\"Hà Nam\",\"value\":26},{\"title\":\"Hà Tây\",\"value\":3},{\"title\":\"Hà Tĩnh\",\"value\":27},{\"title\":\"Hải Dương\",\"value\":28},{\"title\":\"Hải Phòng\",\"value\":4},{\"title\":\"Hậu Giang\",\"value\":29},{\"title\":\"Hòa Bình\",\"value\":30},{\"title\":\"Hưng Yên\",\"value\":31},{\"title\":\"Khánh Hòa\",\"value\":32},{\"title\":\"Kiên Giang\",\"value\":33},{\"title\":\"Kon Tum\",\"value\":34},{\"title\":\"Lai Châu\",\"value\":35},{\"title\":\"Lạng Sơn\",\"value\":37},{\"title\":\"Lào Cai\",\"value\":38},{\"title\":\"Lâm Đồng\",\"value\":36},{\"title\":\"Long An\",\"value\":39},{\"title\":\"Nam Định\",\"value\":40},{\"title\":\"Nghệ An\",\"value\":41},{\"title\":\"Ninh Bình\",\"value\":42},{\"title\":\"Ninh Thuận\",\"value\":43},{\"title\":\"Phú Thọ\",\"value\":44},{\"title\":\"Phú Yên\",\"value\":45},{\"title\":\"Quảng Bình\",\"value\":46},{\"title\":\"Quảng Nam\",\"value\":47},{\"title\":\"Quảng Ngãi\",\"value\":48},{\"title\":\"Quảng Ninh\",\"value\":49},{\"title\":\"Quảng Trị\",\"value\":50},{\"title\":\"Sóc Trăng\",\"value\":51},{\"title\":\"Sơn La\",\"value\":52},{\"title\":\"Tây Ninh\",\"value\":53},{\"title\":\"Thái Bình\",\"value\":54},{\"title\":\"Thái Nguyên\",\"value\":55},{\"title\":\"Thanh Hóa\",\"value\":56},{\"title\":\"Thừa Thiên-Huế\",\"value\":57},{\"title\":\"Tiền Giang\",\"value\":58},{\"title\":\"Trà Vinh\",\"value\":59},{\"title\":\"Tuyên Quang\",\"value\":60},{\"title\":\"Vĩnh Long\",\"value\":61},{\"title\":\"Vĩnh Phúc\",\"value\":62},{\"title\":\"Yên Bái\",\"value\":63},{\"title\":\"Toàn quốc\",\"value\":64},{\"title\":\"Nước ngoài\",\"value\":65}]"

#define DANH_SACH_DAU_SO_THE_NGAN_HANG_CHUYEN_TIEN_HOP_LE @"[{\"binMaThe\":\"686868\",\"doDaiThe\":16},{\"binMaThe\":\"97043668\",\"doDaiThe\":19},{\"binMaThe\":\"97043666\",\"doDaiThe\":19},{\"binMaThe\":\"97043628\",\"doDaiThe\":19},{\"binMaThe\":\"97043688\",\"doDaiThe\":19},{\"binMaThe\":\"526418\",\"doDaiThe\":16},{\"binMaThe\":\"428310\",\"doDaiThe\":16},{\"binMaThe\":\"377160\",\"doDaiThe\":15},{\"binMaThe\":\"469173\",\"doDaiThe\":16},{\"binMaThe\":\"621295\",\"doDaiThe\":16},{\"binMaThe\":\"970416\",\"doDaiThe\":16},{\"binMaThe\":\"422151\",\"doDaiThe\":16},{\"binMaThe\":\"429418\",\"doDaiThe\":16},{\"binMaThe\":\"436361\",\"doDaiThe\":16},{\"binMaThe\":\"436438\",\"doDaiThe\":16},{\"binMaThe\":\"436445\",\"doDaiThe\":16},{\"binMaThe\":\"462881\",\"doDaiThe\":16},{\"binMaThe\":\"464932\",\"doDaiThe\":16},{\"binMaThe\":\"467964\",\"doDaiThe\":16},{\"binMaThe\":\"469654\",\"doDaiThe\":16},{\"binMaThe\":\"472074\",\"doDaiThe\":16},{\"binMaThe\":\"472075\",\"doDaiThe\":16},{\"binMaThe\":\"486265\",\"doDaiThe\":16},{\"binMaThe\":\"512341\",\"doDaiThe\":16},{\"binMaThe\":\"526830\",\"doDaiThe\":16},{\"binMaThe\":\"620009\",\"doDaiThe\":16},{\"binMaThe\":\"621055\",\"doDaiThe\":16},{\"binMaThe\":\"625002\",\"doDaiThe\":16},{\"binMaThe\":\"970403\",\"doDaiThe\":16},{\"binMaThe\":\"970431\",\"doDaiThe\":16},{\"binMaThe\":\"707070\",\"doDaiThe\":16},{\"binMaThe\":\"970423\",\"doDaiThe\":16},{\"binMaThe\":\"970443\",\"doDaiThe\":16},{\"binMaThe\":\"126688\",\"doDaiThe\":16},{\"binMaThe\":\"970437\",\"doDaiThe\":16},{\"binMaThe\":\"193939\",\"doDaiThe\":16},{\"binMaThe\":\"472674\",\"doDaiThe\":16},{\"binMaThe\":\"484804\",\"doDaiThe\":16},{\"binMaThe\":\"484803\",\"doDaiThe\":16},{\"binMaThe\":\"548566\",\"doDaiThe\":16},{\"binMaThe\":\"97042292\",\"doDaiThe\":16},{\"binMaThe\":\"97042291\",\"doDaiThe\":16},{\"binMaThe\":\"970422\",\"doDaiThe\":16},{\"binMaThe\":\"970408\",\"doDaiThe\":16},{\"binMaThe\":\"970432\",\"doDaiThe\":16},{\"binMaThe\":\"981957\",\"doDaiThe\":16},{\"binMaThe\":\"520395\",\"doDaiThe\":16},{\"binMaThe\":\"520399\",\"doDaiThe\":16},{\"binMaThe\":\"521377\",\"doDaiThe\":16},{\"binMaThe\":\"524394\",\"doDaiThe\":16},{\"binMaThe\":\"528626\",\"doDaiThe\":16},{\"binMaThe\":\"97044168\",\"doDaiThe\":16},{\"binMaThe\":\"180906\",\"doDaiThe\":16},{\"binMaThe\":\"970414\",\"doDaiThe\":16},{\"binMaThe\":\"970427\",\"doDaiThe\":16},{\"binMaThe\":\"166888\",\"doDaiThe\":16},{\"binMaThe\":\"970407\",\"doDaiThe\":16},{\"binMaThe\":\"889988\",\"doDaiThe\":16},{\"binMaThe\":\"970448\",\"doDaiThe\":16},{\"binMaThe\":\"177777\",\"doDaiThe\":16},{\"binMaThe\":\"970419\",\"doDaiThe\":16},{\"binMaThe\":\"818188\",\"doDaiThe\":16},{\"binMaThe\":\"970442\",\"doDaiThe\":16},{\"binMaThe\":\"970449\",\"doDaiThe\":19},{\"binMaThe\":\"620160\",\"doDaiThe\":16},{\"binMaThe\":\"620162\",\"doDaiThe\":16},{\"binMaThe\":\"620163\",\"doDaiThe\":16},{\"binMaThe\":\"620164\",\"doDaiThe\":16},{\"binMaThe\":\"620165\",\"doDaiThe\":16},{\"binMaThe\":\"620166\",\"doDaiThe\":16},{\"binMaThe\":\"620168\",\"doDaiThe\":16},{\"binMaThe\":\"620169\",\"doDaiThe\":16},{\"binMaThe\":\"201010\",\"doDaiThe\":16},{\"binMaThe\":\"970415\",\"doDaiThe\":16},{\"binMaThe\":\"970425\",\"doDaiThe\":16},{\"binMaThe\":\"191919\",\"doDaiThe\":16},{\"binMaThe\":\"970401\",\"doDaiThe\":16},{\"binMaThe\":\"970409\",\"doDaiThe\":16},{\"binMaThe\":\"970438\",\"doDaiThe\":16},{\"binMaThe\":\"476636\",\"doDaiThe\":16},{\"binMaThe\":\"436546\",\"doDaiThe\":16},{\"binMaThe\":\"436545\",\"doDaiThe\":16},{\"binMaThe\":\"437421\",\"doDaiThe\":16},{\"binMaThe\":\"437420\",\"doDaiThe\":16},{\"binMaThe\":\"537158\",\"doDaiThe\":16},{\"binMaThe\":\"540392\",\"doDaiThe\":16},{\"binMaThe\":\"970440\",\"doDaiThe\":19},{\"binMaThe\":\"970429\",\"doDaiThe\":16},{\"binMaThe\":\"970439\",\"doDaiThe\":16},{\"binMaThe\":\"668868\",\"doDaiThe\":16},{\"binMaThe\":\"188188\",\"doDaiThe\":16},{\"binMaThe\":\"000002\",\"doDaiThe\":16},{\"binMaThe\":\"469674\",\"doDaiThe\":16},{\"binMaThe\":\"469673\",\"doDaiThe\":16},{\"binMaThe\":\"469672\",\"doDaiThe\":16},{\"binMaThe\":\"970424\",\"doDaiThe\":16},{\"binMaThe\":\"272727\",\"doDaiThe\":16},{\"binMaThe\":\"272728\",\"doDaiThe\":16},{\"binMaThe\":\"272729\",\"doDaiThe\":16},{\"binMaThe\":\"970405\",\"doDaiThe\":16}]"


#define SO_TIEN_MOT_LAN_CHUYEN 330
#define SO_TIEN_MOC 20000000
#define PHI_DUOI_20tr 1100
#define PHI_TREN_20tr 2200
#define PHI_DUOI_50tr 3300
#define PHI_TREN_50tr 3300

#define PHI_CHUYEN_TIEN_DEN_VI_MOMO 3300
#define PHI_CHUYEN_TIEN_DEN_THE 3300
#define PHI_CHUYEN_TIEN_DEN_TAI_KHOAN 3300

//vietpd
#define PHI_CHUYEN_TIEN_TAN_NHA_1 75600 //100.000->1.000.000
#define PHI_CHUYEN_TIEN_TAN_NHA_2 81600 //1.000.001 -> 2.000.000
#define PHI_CHUYEN_TIEN_TAN_NHA_3 92200 //2.000.001 -> 3.000.000
#define PHI_CHUYEN_TIEN_TAN_NHA_4 116600 //3.000.001 -> 4.000.000
#define PHI_CHUYEN_TIEN_TAN_NHA_5 206600 //4.000.001 -> 5.000.000

@interface DeallocParasite : NSObject
@property (nonatomic, assign) SEL       selector;
@property (nonatomic, retain) id        target;
@end
@implementation DeallocParasite
- (void)dealloc
{
    [self.target performSelector:self.selector withObject:nil];
    self.target = nil;
    [super dealloc];
}
@end

@interface UmiLocationTimer : NSObject
@property (nonatomic, assign) SEL       selector;
@property (nonatomic, assign) id        target;
@property (nonatomic, retain) NSTimer * timer;

+ (UmiLocationTimer *)timeout:(NSTimeInterval)timeout
                       target:(id)target
                     selector:(SEL)selector;


- (void)stop;

@end

@implementation UmiLocationTimer

- (void)dealloc
{
    self.timer = nil;
    [super dealloc];
}

- (void)stop
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)on_timer:(NSTimer *)tm
{
    if (self.selector && self.target)
    {
        [self.target performSelectorOnMainThread:self.selector withObject:nil waitUntilDone:NO];
    }
    
    [self.timer invalidate];
}

+ (UmiLocationTimer *)timeout:(NSTimeInterval)timeout target:(id)target selector:(SEL)selector;
{
    UmiLocationTimer *tm = [[UmiLocationTimer new] autorelease];
    tm.target = target;
    tm.selector = selector;
    
    tm.timer = [NSTimer scheduledTimerWithTimeInterval:timeout target:tm selector:@selector(on_timer:) userInfo:nil repeats:NO];
    
    return tm;
}

@end

@implementation MFMailComposeViewController (Umi)

+ (MFMailComposeViewController *)mail:(NSString *)receiver
                              subject:(NSString *)subject
                                 body:(NSString *)body
                             callback:(void(^)(MFMailComposeViewController *controller, MFMailComposeResult* result, NSError *error))mail_callback;
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    if (controller)
    {
        objc_setAssociatedObject(controller, "mail_callback", [mail_callback copy], OBJC_ASSOCIATION_RETAIN);
    }
    controller.mailComposeDelegate = (id<MFMailComposeViewControllerDelegate>)controller;
    [controller setToRecipients:@[receiver]];
    [controller setSubject:subject];
    [controller setMessageBody:body isHTML:NO];
    
    return [controller autorelease];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    void(^mail_callback)(MFMailComposeViewController *controller, MFMailComposeResult* result, NSError *error);
    mail_callback = objc_getAssociatedObject(controller, "mail_callback");
    if (mail_callback)
    {
        mail_callback (controller, result, error);
        objc_setAssociatedObject(controller, "mail_callback", nil, OBJC_ASSOCIATION_RETAIN);
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end

#pragma mark - Location helper

CLLocationManager *shared_location_manager = nil;

@implementation CLLocationManager (Umi)

- (void)setCallback:(void (^)(CLLocationCoordinate2D))callback
{
    void (^cb)(CLLocationCoordinate2D) = [callback copy];
    objc_setAssociatedObject(self, "umi_callback", [cb autorelease], OBJC_ASSOCIATION_RETAIN);
}

- (void (^)(CLLocationCoordinate2D))callback
{
    return objc_getAssociatedObject(self, "umi_callback");
}

- (void)setTimer:(NSTimer *)timer
{
    NSTimer *old = [self timer];
    if (old)
    {
        [old invalidate];
    }
    
    objc_setAssociatedObject(self, "umi_callback_timer", timer, OBJC_ASSOCIATION_RETAIN);
}

- (NSTimer *)timer
{
    return objc_getAssociatedObject(self, "umi_callback_timer");
}

+ (CLLocationManager *)update_user_location:(void (^)(CLLocationCoordinate2D))callback
                                    timeout:(NSTimeInterval)timeout;
{
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        // em sửa 1 chút cho dễ so sánh
        //        callback (CLLocationCoordinate2DMake(FLT_MAX, FLT_MAX));
        callback (kCLLocationCoordinate2DInvalid);
        return nil;
    }
    
    CLLocationManager *man = [[CLLocationManager alloc] init];
    man.delegate = man;
    man.desiredAccuracy = kCLLocationAccuracyBest;
    man.distanceFilter = kCLDistanceFilterNone;
    
    CLLocation *loc = [man location];
    if (loc && [loc.timestamp timeIntervalSinceNow] < 1 * 60)
    {
        callback (loc.coordinate);
        return [man autorelease];
    }
    
    [man setCallback:callback];
    [man startUpdatingLocation];
    
    UmiLocationTimer *tm = [UmiLocationTimer timeout:timeout target:man selector:@selector(on_timer:)];
    [man setTimer:tm.timer];
    
    DeallocParasite *obj = [[DeallocParasite new] autorelease];
    obj.target = tm;
    obj.selector = @selector(stop);
    objc_setAssociatedObject(man, "dealloc_attachment", obj, OBJC_ASSOCIATION_RETAIN);
    
    return [man autorelease];
}

- (void)on_timer:(NSTimer *)timer
{
    [self stopUpdatingLocation];
    
    void (^cb)(CLLocationCoordinate2D) = [self callback];
    
    if (cb)
    {
        cb (kCLLocationCoordinate2DInvalid);
        [self setCallback:nil];
        [self setTimer:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [self stopUpdatingLocation];
    [self setTimer:nil];
    
    void (^cb)(CLLocationCoordinate2D) = [self callback];
    if (cb)
    {
        cb (location.coordinate);
        [self setCallback:nil];
    }
}

@end


@interface Common ()
@end
@implementation Common

+(NSString *)date:(NSDate *)date toStringWithFormat:(NSString *)format
{
    if (date == nil)
    {
        return @"";
    }
    if (format == nil || format.length < 3)
    {
        format = @"dd/MM/yyyy";
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:format];
    
    NSString *result = [fmt stringFromDate:date];
    [fmt release];
    
    return result;
}
+(NSDate *)dateFromString:(NSString *)dateStr withFormat:(NSString *)format
{
    if (dateStr == nil || dateStr.length < 2)
    {
        return nil;
    }
    if (format == nil || format.length < 3)
    {
        format = @"dd/MM/yyyy";
    }
    NSDateFormatter *fmt = [[[NSDateFormatter alloc] init] autorelease];
    [fmt setDateFormat:format];
    
    NSDate *result = [fmt dateFromString:dateStr];
    
    return result;
}

+ (NSString*)milisecondsToMonAndDayString:(NSNumber*)miliseconds
{
    NSString *nDate = [NSString stringWithFormat:@"%@", miliseconds];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([nDate doubleValue] / 1000)];
    NSDateFormatter *dtfrm = [[[NSDateFormatter alloc] init] autorelease];
    [dtfrm setDateFormat:@"dd/MM"];
    nDate = [dtfrm stringFromDate:date];
    return nDate;
}

+ (BOOL)isRetina;
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0))
    {
        return YES;
    }
    
    return NO;
}

+ (NSString*)giauSoTaiKhoanDienThoai:(NSString*)sTaiKhoan
{
    if([Common kiemTraLaSoDienThoai:sTaiKhoan])
    {
        NSInteger nSoHienThi = 5;
        
        NSInteger nOffset = 3;
        NSInteger nLength = sTaiKhoan.length - nSoHienThi;
        
        NSRange range = NSMakeRange(nOffset, nLength);
        NSMutableString *sXauThayThe = [[NSMutableString alloc] init];
        for(int i = 0; i < nLength; i++)
        {
            [sXauThayThe appendString:@"*"];
        }
        NSString *sXauMoi = [sTaiKhoan stringByReplacingCharactersInRange:range withString:sXauThayThe];
        return sXauMoi;
    }
    return sTaiKhoan;
}

+ (BOOL)kiemTraLaSoDienThoai:(NSString*)sXau
{
    NSError *error = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:PATTERN_PHONE
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:&error];
    NSString *s = sXau;
    NSArray *arr = [regex matchesInString:s
                                  options:0
                                    range:NSMakeRange(0,s.length)];
    [regex release];
    if (arr != nil && error == nil && arr.count == 1)
    {

        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)kiemTraSoDienThoaiThuocVietNam:(NSString *)sXau {
    if ([self kiemTraLaSoDienThoai:sXau]) {
        NSArray *danhSachDauSo = @[
                                   @"096",
                                   @"097",
                                   @"098",
                                   @"0163",
                                   @"0164",
                                   @"0165",
                                   @"0166",
                                   @"0167",
                                   @"0168",
                                   @"0169",
                                   @"086",
                                   @"091",
                                   @"094",
                                   @"0123",
                                   @"0124",
                                   @"0125",
                                   @"0127",
                                   @"0129",
                                   @"088",
                                   @"090",
                                   @"093",
                                   @"0120",
                                   @"0121",
                                   @"0122",
                                   @"0126",
                                   @"0128",
                                   @"089",
                                   @"092",
                                   @"018",
                                   @"0993",
                                   @"0994",
                                   @"0995",
                                   @"0996",
                                   @"0199"
                                   ];
        for(NSString *sDauSo in danhSachDauSo)
        {
            if([sXau hasPrefix:sDauSo])
            {
                return YES;
            }
        }

    }
    return NO;
}

+ (BOOL)kiemTraLaMail:(NSString*)sXau
{
    NSError *error = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:PATTERN_MAIL
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:&error];
    NSString *s = sXau;
    NSArray *arr = [regex matchesInString:s
                                  options:0
                                    range:NSMakeRange(0,s.length)];
    [regex release];
    if (arr != nil && error == nil && arr.count == 1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)kiemTraLaDN:(NSString*)sXau
{
    NSError *error = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:PATTERN_DN
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:&error];
    NSString *s = sXau;
    NSArray *arr = [regex matchesInString:s
                                  options:0
                                    range:NSMakeRange(0,s.length)];
    [regex release];
    if (arr != nil && error == nil && arr.count == 1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString *)URLDecode:(NSString *)sTring
{
    NSString *result = [sTring stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

+ (double)layPhiRutTienCuaSoTien:(double)fSoTien
{
    double fSoTienPhi = 0;
    if(fSoTien > 0)
    {
        if(fSoTien >= SO_TIEN_MOC)
        {
            fSoTienPhi = PHI_TREN_20tr;
        }
        else if(fSoTien < SO_TIEN_MOC && fSoTien > 0)
        {
            fSoTienPhi = PHI_DUOI_20tr;
        }
        NSInteger vat = (fSoTienPhi * 10) / 100;
        fSoTienPhi += vat;
//        if(![sMaNganHang isEqualToString:@"VCB"])
//        {
//            double fPhiChuyenTienLienNganHang = PHI_CHUYEN_TIEN_LIEN_NGAN_HANG;
//            fSoTienPhi += fPhiChuyenTienLienNganHang;
//        }
    }
    return fSoTienPhi;
}

+ (double)layPhiChuyenTienTanNha:(double)fSoTien nKhuVuc:(int)nKhuVuc{
//    NSLog(@"%s - fSoTien : %f - nKhuVuc : %d", __FUNCTION__, fSoTien, nKhuVuc);
    double fSoTienPhi = 0;
    int nPhanTramPhi = 0;
    int nSoTien = (int)fSoTien;
    if (nKhuVuc == 0) {
        nPhanTramPhi = nSoTien * 0.01;
        if (nPhanTramPhi < 50000) {
            nPhanTramPhi = 50000;
        }
    }
    else{
        nPhanTramPhi = nSoTien * 0.003;
        if (nPhanTramPhi < 20000) {
            nPhanTramPhi = 20000;
        }
    }
    if(nSoTien >= 50000 && nSoTien <= 1000000)
    {
        fSoTienPhi = 19000 + nPhanTramPhi + 6600;
    }
    else if(nSoTien >= 1000001 && nSoTien <= 2000000)
    {
        fSoTienPhi = 25000 + nPhanTramPhi  + 6600;
    }
    else if(nSoTien >= 2000001 && nSoTien <= 3000000)
    {
        fSoTienPhi = 36000 + nPhanTramPhi  + 6600;
    }
    else if(nSoTien >= 3000001 && nSoTien <= 5000000)
    {
        fSoTienPhi = 55000 + nPhanTramPhi  + 6600;
    }
    else if(nSoTien >= 5000001 && nSoTien <= 10000000)
    {
        fSoTienPhi = 60000 + nPhanTramPhi  + 6600;
    }
    else if(nSoTien >= 10000001 && nSoTien <= 15000000)
    {
        fSoTienPhi = 68000 + nPhanTramPhi  + 6600;
    }
    else if(nSoTien >= 15000001 && nSoTien <= 20000000)
    {
        fSoTienPhi = 75000 + nPhanTramPhi  + 6600;
    }
    else if (nSoTien > 20000000){
        int sl = nSoTien / 20000000;
        for (int i = 0; i < sl; i++) {
            fSoTienPhi += [self layPhiChuyenTienCuaSoTien:20000000 kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAN_NHA maNganHang:@""];
        }
        int soTienThua = nSoTien % 20000000;
        if (soTienThua != 0) {
            if (soTienThua <= 50000) {
                fSoTienPhi -= [self layPhiChuyenTienCuaSoTien:20000000 kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAN_NHA maNganHang:@""];
                fSoTienPhi += [self layPhiChuyenTienCuaSoTien:10000000 kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAN_NHA maNganHang:@""];
                fSoTienPhi += [self layPhiChuyenTienCuaSoTien:(10000000 + soTienThua) kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAN_NHA maNganHang:@""];
            }
            else{
                fSoTienPhi += [self layPhiChuyenTienCuaSoTien:soTienThua kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAN_NHA maNganHang:@""];
            }
        }
    }
    return fSoTienPhi;
}

+ (double)layPhiChuyenTienCuaSoTien:(double)fSoTien kieuChuyenTien:(int)nKieuChuyenTien maNganHang:(NSString*)sMaNganHang
{
    NSLog(@"%s - fSoTien : %f", __FUNCTION__, fSoTien);
    double fSoTienPhi = 0;
    if(nKieuChuyenTien == KIEU_CHUYEN_TIEN_DEN_VI)
    {
        fSoTienPhi = SO_TIEN_MOT_LAN_CHUYEN;
        if (fSoTien >= 1000000) {
            fSoTienPhi = PHI_DUOI_20tr;
        }
        if(fSoTien >= SO_TIEN_MOC)
        {
            fSoTienPhi = PHI_TREN_20tr;
        }
//        if (fSoTien >= 50000000) {
//            fSoTienPhi = PHI_TREN_50tr;
//        }
    }
    
    //vietpd
    /*=============================================*/
    else if (nKieuChuyenTien == KIEU_CHUYEN_TIEN_DEN_TAN_NHA){
        int nSoTien = (int)fSoTien;
        int nPhanTramPhi = nSoTien / 100;
        if (nPhanTramPhi < 50000) {
            nPhanTramPhi = 50000;
        }
        if(nSoTien >= 50000 && nSoTien <= 1000000)
        {
            fSoTienPhi = 19000 + nPhanTramPhi + 6600;
        }
        else if(nSoTien >= 1000001 && nSoTien <= 2000000)
        {
            fSoTienPhi = 25000 + nPhanTramPhi  + 6600;
        }
        else if(nSoTien >= 2000001 && nSoTien <= 3000000)
        {
            fSoTienPhi = 36000 + nPhanTramPhi  + 6600;
        }
        else if(nSoTien >= 3000001 && nSoTien <= 5000000)
        {
            fSoTienPhi = 55000 + nPhanTramPhi  + 6600;
        }
        else if(nSoTien >= 5000001 && nSoTien <= 10000000)
        {
            fSoTienPhi = 60000 + nPhanTramPhi  + 6600;
        }
        else if(nSoTien >= 10000001 && nSoTien <= 15000000)
        {
            fSoTienPhi = 68000 + nPhanTramPhi  + 6600;
        }
        else if(nSoTien >= 15000001 && nSoTien <= 20000000)
        {
            fSoTienPhi = 75000 + nPhanTramPhi  + 6600;
        }
        else if (nSoTien > 20000000){
            int sl = nSoTien / 20000000;
            for (int i = 0; i < sl; i++) {
                fSoTienPhi += [self layPhiChuyenTienCuaSoTien:20000000 kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAN_NHA maNganHang:@""];
            }
            int soTienThua = nSoTien % 20000000;
            if (soTienThua != 0) {
                if (soTienThua <= 50000) {
                    fSoTienPhi -= [self layPhiChuyenTienCuaSoTien:20000000 kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAN_NHA maNganHang:@""];
                    fSoTienPhi += [self layPhiChuyenTienCuaSoTien:10000000 kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAN_NHA maNganHang:@""];
                    fSoTienPhi += [self layPhiChuyenTienCuaSoTien:(10000000 + soTienThua) kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAN_NHA maNganHang:@""];
                }
                else{
                    fSoTienPhi += [self layPhiChuyenTienCuaSoTien:soTienThua kieuChuyenTien:KIEU_CHUYEN_TIEN_DEN_TAN_NHA maNganHang:@""];
                }
            }
        }
        NSLog(@"%s - fSoTienPhi : %f", __FUNCTION__, fSoTienPhi);
    }
    /*=============================================*/
    else if (nKieuChuyenTien == KIEU_CHUYEN_TIEN_DEN_TAI_KHOAN_NGAN_HANG)
    {
        fSoTienPhi = PHI_DUOI_50tr;
        if (fSoTien >= 50000000) {
//            fSoTienPhi = PHI_TREN_50tr + ((int)(fSoTien / 50000000) * PHI_TREN_50tr);
            fSoTienPhi = ceil(fSoTien / 50000000.0f) * PHI_TREN_50tr;
        }
//        if(![sMaNganHang isEqualToString:@"LPB"] && ![sMaNganHang isEqualToString:@"NAB"] && ![sMaNganHang isEqualToString:@"NCB"])
//        {
//            fSoTienPhi = PHI_CHUYEN_TIEN_DEN_TAI_KHOAN;
//        }
//        else{
//            fSoTienPhi = 3300;
//        }
    }
    else if(nKieuChuyenTien == KIEU_CHUYEN_TIEN_DEN_THE)
    {
        fSoTienPhi = PHI_CHUYEN_TIEN_DEN_THE;
    }
    else if ( nKieuChuyenTien == KIEU_CHUYEN_TIEN_NAP_THE_DIEN_THOAI)
    {
        fSoTienPhi = 1100;
//        fSoTienPhi = SO_TIEN_MOT_LAN_CHUYEN;
//        if (fSoTien > 1000000) {
//            fSoTienPhi = PHI_DUOI_20tr;
//        }
//        if(fSoTien >= SO_TIEN_MOC)
//        {
//            fSoTienPhi = PHI_TREN_20tr;
//        }
    }
    else if ( nKieuChuyenTien == KIEU_NAP_VI_TU_THE_NGAN_HANG)
    {
        fSoTienPhi = 1100 + round((float)((0.011*fSoTien + 12.1)/0.989));
    }
    else if ( nKieuChuyenTien == KIEU_CHUYEN_TIEN_DEN_VI_MOMO)
    {
        fSoTienPhi = PHI_CHUYEN_TIEN_DEN_VI_MOMO;
    }
    else
    {
        fSoTienPhi = 3300;
//        if(fSoTien >= SO_TIEN_MOC)
//        {
//            fSoTienPhi = PHI_TREN_20tr;
//        }
    }
    return fSoTienPhi;
}

+ (BOOL)kiemTraSoTienMotLanChuyenHopLe:(double)fSoTien
{
    if(fSoTien >= SO_TIEN_MOT_LAN_CHUYEN)
        return YES;
    return NO;
}

+ (int)layKieuTraCuuHoaDonDienTheoMaKhachHang:(NSString*)sMaKhachHang
{
    int nMaKhuVuc = -1;
    if([sMaKhachHang hasPrefix:@"PA25"])
    {
        nMaKhuVuc = THANH_TOAN_TRA_CUU_DIEN_LUC_VINH_PHUC;
    }
    else if ([sMaKhachHang hasPrefix:@"PD"])
    {
        nMaKhuVuc = THANH_TOAN_TRA_CUU_DIEN_LUC_HN;
    }
    else if ([sMaKhachHang hasPrefix:@"PE"])
    {
        nMaKhuVuc = THANH_TOAN_TRA_CUU_DIEN_LUC_HCM;
    }
    else if ([sMaKhachHang hasPrefix:@"PC01"] ||
             [sMaKhachHang hasPrefix:@"PC02"] ||
             [sMaKhachHang hasPrefix:@"PC03"] ||
             [sMaKhachHang hasPrefix:@"PC05"] ||
             [sMaKhachHang hasPrefix:@"PC06"] ||
             [sMaKhachHang hasPrefix:@"PC07"] ||
             [sMaKhachHang hasPrefix:@"PC08"] ||
             [sMaKhachHang hasPrefix:@"PC10"] ||
             [sMaKhachHang hasPrefix:@"PC11"] ||
             [sMaKhachHang hasPrefix:@"PC12"] ||
             [sMaKhachHang hasPrefix:@"PC13"] ||
             [sMaKhachHang hasPrefix:@"PP"]   ||
             [sMaKhachHang hasPrefix:@"PQ"])
    {
        nMaKhuVuc = THANH_TOAN_TRA_CUU_DIEN_LUC_MIEN_TRUNG;
    }
    else
    {
        nMaKhuVuc = THANH_TOAN_TRA_CUU_DIEN_LUC_TINH_KHAC;
    }
    
    return nMaKhuVuc;
}

+ (int)layKieuThanhToanHoaDonDienTheoMaKhachHang:(NSString*)sMaKhachHang
{
    int nMaKhuVuc = -1;
    if([sMaKhachHang hasPrefix:@"PA25"])
    {
        nMaKhuVuc = THANH_TOAN_DIEN_LUC_VINH_PHUC;
    }
    else if ([sMaKhachHang hasPrefix:@"PD"])
    {
        nMaKhuVuc = THANH_TOAN_DIEN_LUC_HA_NOI;
    }
    else if ([sMaKhachHang hasPrefix:@"PE"])
    {
        nMaKhuVuc = THANH_TOAN_DIEN_LUC_HCM;
    }
    else if ([sMaKhachHang hasPrefix:@"PC01"] ||
             [sMaKhachHang hasPrefix:@"PC02"] ||
             [sMaKhachHang hasPrefix:@"PC03"] ||
             [sMaKhachHang hasPrefix:@"PC05"] ||
             [sMaKhachHang hasPrefix:@"PC06"] ||
             [sMaKhachHang hasPrefix:@"PC07"] ||
             [sMaKhachHang hasPrefix:@"PC08"] ||
             [sMaKhachHang hasPrefix:@"PC10"] ||
             [sMaKhachHang hasPrefix:@"PC11"] ||
             [sMaKhachHang hasPrefix:@"PC12"] ||
             [sMaKhachHang hasPrefix:@"PC13"] ||
             [sMaKhachHang hasPrefix:@"PP"]   ||
             [sMaKhachHang hasPrefix:@"PQ"])
    {
        nMaKhuVuc = THANH_TOAN_DIEN_LUC_MIEN_TRUNG;
    }
    else
    {
//        nMaKhuVuc = THANH_TOAN_TRA_CUU_DIEN_LUC_TINH_KHAC;
    }
    
    return nMaKhuVuc;
}

+ (BOOL)kiemTralaSoDienThoaiViettel:(NSString*)sSoDienThoaiCanKiemTra
{
    NSArray *danhSachDauSo = @[
                               @"096",
                               @"097",
                               @"098",
                               @"0163",
                               @"0164",
                               @"0165",
                               @"0166",
                               @"0167",
                               @"0168",
                               @"0169",
                               @"086"
                               ];
    for(NSString *sDauSo in danhSachDauSo)
    {
        if([sSoDienThoaiCanKiemTra hasPrefix:sDauSo])
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)kiemTralaSoDienThoaiVina:(NSString*)sSoDienThoaiCanKiemTra
{
    NSArray *danhSachDauSo = @[
                               @"091",
                               @"094",
                               @"0123",
                               @"0124",
                               @"0125",
                               @"0127",
                               @"0129",
                               @"088"
                               ];
    for(NSString *sDauSo in danhSachDauSo)
    {
        if([sSoDienThoaiCanKiemTra hasPrefix:sDauSo])
        {
            return YES;
        }
    }
    return NO;

}

+ (BOOL)kiemTralaSoDienThoaiMobiphone:(NSString*)sSoDienThoaiCanKiemTra
{
    NSArray *danhSachDauSo = @[
                               @"090",
                               @"093",
                               @"0120",
                               @"0121",
                               @"0122",
                               @"0126",
                               @"0128",
                               @"089"
                               ];
    for(NSString *sDauSo in danhSachDauSo)
    {
        if([sSoDienThoaiCanKiemTra hasPrefix:sDauSo])
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)kiemTralaSoDienThoaiVietNamobile:(NSString*)sSoDienThoaiCanKiemTra
{
    NSArray *danhSachDauSo = @[
                               @"092",
                               @"018"
                               ];
    for(NSString *sDauSo in danhSachDauSo)
    {
        if([sSoDienThoaiCanKiemTra hasPrefix:sDauSo])
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)kiemTralaSoDienThoaiGMobile:(NSString*)sSoDienThoaiCanKiemTra
{
    NSArray *danhSachDauSo = @[
                               @"0993",
                               @"0994",
                               @"0995",
                               @"0996",
                               @"0199"
                               ];
    for(NSString *sDauSo in danhSachDauSo)
    {
        if([sSoDienThoaiCanKiemTra hasPrefix:sDauSo])
        {
            return YES;
        }
    }
    return NO;
}

+ (NSArray*)job_work_locations
{
    NSArray *arr = [kJOB_WODK_LOCATION_JSON objectFromJSONString];
    return arr;
}



+(NSString *)mkGetFlagID:(int)flagId
{
    NSString *str_cateId = [NSString stringWithFormat:@"%d",flagId];
    if (str_cateId.length == 1 || str_cateId.length == 3)
    {
        str_cateId = [NSString stringWithFormat:@"0%@",str_cateId];
    }
    NSString *dir = [[NSBundle mainBundle] bundlePath];
    NSString *img_path = [NSString stringWithFormat:@"%@/%@_selected@2x.png",dir,str_cateId];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:img_path];
    if (fileExists)
    {
        return str_cateId;
    }else
    {
        if (str_cateId.length == 4)
        {
            NSString *parent_id = [str_cateId substringToIndex:2];
            return parent_id;
        }
    }
    return @"dich_vu_khac";
}

+ (UIViewController *)top_view_controller;
{
    UIViewController * root = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self top_view_controller_from:root];
}

+ (UIViewController *)top_view_controller_from:(UIViewController *)vc
{
    UIViewController *top = nil;
    
    if ([vc isKindOfClass:[UINavigationController class]])
    {
        top = [(UINavigationController *)vc topViewController];
    }
    else if ([vc isKindOfClass:[UITabBarController class]])
    {
        top = [(UITabBarController *)vc selectedViewController];
    }
    else if ([vc presentedViewController])
    {
        top = [vc presentedViewController];
    }
    if (top == nil)
        return vc;
    
    UIViewController *top2 = [self top_view_controller_from:top];
    if (top2 == nil)
        return top;
    
    return top2;
}

+(int)getAppLanguage
{
    int language = 0;
    NSNumber *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:kOptionLanguage];
    if (tmp && [tmp isKindOfClass:[NSNumber class]])
        language = [tmp intValue];
    return language % 2;
}

+(NSString *)getUniqueDeviceIdentifier
{
    NSString *identify = [UIDevice uniqueDeviceIdentifier];
    return identify;
}
+(NSDate *)unixTimeToDate:(NSTimeInterval)unixTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTime];
    return date;
}

+(NSString *)unixGetTimeRemaining:(NSTimeInterval)unixTime
{
    NSString * result = @"";
    int second,minute,hour,day;
    second = ((int)unixTime) % 60;
    
    // num min
    int numMins = (int)(unixTime / 60);
    minute = numMins % 60;
    
    //hour
    int numHours = (int)(numMins / 60);
    hour = numHours % 24;
    
    //day
    day = (int)(numHours / 24);
    
    if (day > 0)
    {
        result = [NSString stringWithFormat:@"%d ngày",day];
    }
    if (hour > 0)
    {
        result = [NSString stringWithFormat:@"%@ %d giờ",result,hour];
    }
    if (minute > 0)
    {
        result = [NSString stringWithFormat:@"%@ %d phút",result,minute];
    }
    
    if (second > 0)
    {
        result = [NSString stringWithFormat:@"%@ %d giây",result,second];
    }
    
    return result.trim;
}

+(UIColor *)colorWithHex:(NSString *)hexColor
{
    if (hexColor == nil)
        return nil;
    
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:@"^[0-9a-fA-F]{6}$"
                                                                    options:NSRegularExpressionCaseInsensitive
                                                                      error:nil];
    NSTextCheckingResult *found = [reg firstMatchInString:hexColor
                                                  options:0
                                                    range:NSMakeRange(0, hexColor.length)];
    BOOL isHexColor = found != nil;
    [reg release];
    if (isHexColor)
    {
        unsigned int red, green, blue;
        sscanf([hexColor UTF8String], "%02X%02X%02X", &red, &green, &blue);
        UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        return color;
    }
    return nil;
}

+ (NSString *)quicklz_decrypt:(NSData *)data;
{
    unsigned int len = (unsigned int)data.length;
    
    char *src = malloc(len);
    memcpy(src, data.bytes, len);
    
    qlz_state_decompress *state_decompress = (qlz_state_decompress *)malloc(sizeof(qlz_state_decompress));
    
    size_t dlen = qlz_size_decompressed(src);
    
    printf("compression ratio: %g%%\n", (float)len/ (float)dlen*100.f);
    
    char *dst = (char*) malloc(dlen + 1);
    dlen = qlz_decompress(src, dst, state_decompress);
    dst[dlen] = 0;
    
    NSString *str = [NSString stringWithCString:dst encoding:NSUTF8StringEncoding];
    
    free(dst);
    free(src);
    
    return str;
}

+(NSString *)getTempDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}
+(NSString *)pathForResource:(NSString *)file
{
    NSString *dir = [[NSBundle mainBundle] bundlePath];
    NSString *path = [dir stringByAppendingPathComponent:file];
    return path;
}
+(NSString *)pathForCachedFile:(NSString *)file
{
    NSString *path = [[Common getTempDirectory] stringByAppendingPathComponent:file];
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        path = [Common pathForResource:file];
        if (NO == [[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            return nil;
        }
    };
    
    return path;
}

#pragma mark - Validation helpers
+(BOOL)isToken:(NSString *)str;
{
    NSString *regex = @"^\\d{6}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:str]) {
        return NO;
    }
    else {
        return YES;
    }
}
+(BOOL)isOTP:(NSString *)str;
{
    NSString *regex = @"^\\d{7}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:str]) {
        return NO;
    }
    else {
        return YES;
    }
}

+(BOOL)isEmptyString:(NSString *)str
{
    if (str == nil)
        return YES;
    
    if (![str isKindOfClass:[NSString class]])
    {
        str = [NSString stringWithFormat:@"%@", str];
    }
    NSString *trimmed = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return trimmed.length == 0;
}

+(UIImage *)stretchImage:(NSString *)image
{
    UIImage *img = [UIImage imageNamed:image];
    
    NSInteger leftcap = floor(img.size.width / 2);
    NSInteger topcap = floor(img.size.height / 2);
    img = [img stretchableImageWithLeftCapWidth:leftcap topCapHeight:topcap];
    
    return img;
}

+(NSString *)trim:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
+(NSString *)reformatBirthday:(NSString*)str
{
    NSArray *a = [[Common trim:str] componentsSeparatedByString:@"/"];
    if (a.count != 3)
        return nil;
    return [a componentsJoinedByString:@"/"];
}
+(BOOL)validateBirthday:(NSString *)str
{
    str = [self reformatBirthday:str];
    if (str)
    {
        NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
        format.dateFormat = @"dd'/'MM'/'yyyy";
        return [format dateFromString:str] != nil;
    }
    return NO;
}

+ (double)laySoTienLaiTheoNgay:(double)laiSuat soNgayGui:(NSInteger)nSoNgay soTien:(double)fSoTien
{
    return round((fSoTien * (laiSuat / 100) * nSoNgay) / 360);
}

+ (double)laySoTienLaiTheoThang:(double)laiSuat soThangGui:(NSInteger)nSoThang soTien:(double)fSoTien
{
    return round(fSoTien * (laiSuat / 100) * nSoThang) / 12;
}

+(NSString *)hienThiTienTe_1:(double)fAmount
{
    
    NSNumber *nAmount = [NSNumber numberWithDouble:fAmount];
    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
//    [_currencyFormatter setLocale:[NSLocale currentLocale]];
    [_currencyFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
//    [_currencyFormatter setCurrencyCode:@"VND"];
    return [NSString stringWithFormat:@"%@ đ", [_currencyFormatter stringFromNumber:nAmount]];
}

+(NSString *)hienThiTienTe:(double)sAmount
{
    NSString *sDuLieu = [NSString stringWithFormat:@"%.0f", sAmount];
    NSInteger nDoDaiChuoi = sDuLieu.length;
    NSMutableString *sKQ = [NSMutableString stringWithString:sDuLieu];
    int k = 0;
    for(NSInteger i = nDoDaiChuoi ; i > 0; i--)
    {
        k++;
        if(k % 3 == 0)
        {
            if((i -1) > 0)
                [sKQ insertString:@"." atIndex:i-1];
        }
    }
    NSString *sHienThi = [NSString stringWithFormat:@"%@", sKQ];
    return sHienThi;
}


+ (NSString*)hienThiSoThe:(NSString*)sSoThe
{
    NSInteger nDoDaiChuoi = sSoThe.length;
    NSMutableString *sKQ = [NSMutableString stringWithString:sSoThe];
    int k = 0;
    for(int i = 0 ; i < nDoDaiChuoi - 1; i++)
    {
        if((i+1) % 4 == 0 && i != 0)
        {
            k++;
            [sKQ insertString:@" " atIndex:i+k];
        }
    }
    return sKQ;
}

+(NSString *)hienThiTienTeFromString:(NSString *)sAmount
{
    NSInteger nDoDaiChuoi = sAmount.length;
    NSMutableString *sKQ = [NSMutableString stringWithString:sAmount];
    int k = 0;
    for(NSInteger i = nDoDaiChuoi ; i > 0; i--)
    {
        k++;
        if(k % 3 == 0)
        {
            if((i -1) > 0)
                [sKQ insertString:@"." atIndex:i-1];
        }
    }
    NSString *sHienThi = [NSString stringWithFormat:@"%@", sKQ];
    return sHienThi;
}


+ (BOOL)kiemTraTheDaDuocKetNoiDeChuyenTien:(NSString*)sSoThe
{
    
//    NSArray *danhSachDauTheHopLe = @[@"686868",
//                                     @"97043668",
//                                     @"97043666",
//                                     @"526418",
//                                     @"428310",
//                                     @"621295",
//                                     @"970416",
//                                     @"422151",
//                                     @"429418",
//                                     @"436361",
//                                     @"436438",
//                                     @"436445",
//                                     @"462881",
//                                     @"464932",
//                                     @"467964",
//                                     @"469654",
//                                     @"472074",
//                                     @"472075",
//                                     @"486265",
//                                     @"512341",
//                                     @"526830",
//                                     @"620009",
//                                     @"621055",
//                                     @"625002",
//                                     @"970403",
//                                     @"970431",
//                                     @"707070",
//                                     @"970423",
//                                     @"970443",
//                                     @"970437",
//                                     @"970422",
//                                     @"970408",
//                                     @"970432",
//                                     @"981957",
//                                     @"520395",
//                                     @"520399",
//                                     @"521377",
//                                     @"524394",
//                                     @"528626",
//                                     @"97044168",
//                                     @"180906",
//                                     @"970414",
//                                     @"970427",
//                                     @"970407",
//                                     @"889988",
//                                     @"970448",
//                                     @"970419",
//                                     @"970442",
//                                     @"970449",
//                                     @"970420",
//                                     @"620160",
//                                     @"620162",
//                                     @"620163",
//                                     @"620164",
//                                     @"620165",
//                                     @"620166",
//                                     @"620168",
//                                     @"620169",
//                                     @"970425",
//                                     @"970401",
//                                     @"970409",
//                                     @"970438"];
    NSArray *danhSachDauTheHopLe = [DANH_SACH_DAU_SO_THE_NGAN_HANG_CHUYEN_TIEN_HOP_LE objectFromJSONString];

    
    
    if([sSoThe rangeOfString:@"*"].location == NSNotFound)
    {
        for(NSDictionary *dict in danhSachDauTheHopLe)
        {
            NSString *binMaThe = [dict valueForKey:@"binMaThe"];
            NSNumber *doDaiThe = [dict valueForKey:@"doDaiThe"];
            if(binMaThe && [sSoThe hasPrefix:binMaThe])
            {
                if(doDaiThe && sSoThe.length == [doDaiThe intValue])
                    return YES;
            }
        }
        return NO;
    }
    return YES;
}


+ (int) compareDate1:(NSString * )_date1 andDate2:(NSString * ) _date2 withFormat:(NSString *) format
{
    /*
     *  -1 <
     *  0 =
     *  1 >
     */
    NSLog(@"%s >> %s line: %d >> date1: %@ -- date2: %@ ",__FILE__,__FUNCTION__ ,__LINE__, _date1, _date2);
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:format];
    @try {
        NSDate * date1 = [dateFormatter dateFromString:_date1];
        NSDate * date2 = [dateFormatter dateFromString:_date2];
        
        NSTimeInterval ndate1 = [date1 timeIntervalSinceReferenceDate];
        NSTimeInterval ndate2 = [date2 timeIntervalSinceReferenceDate];
        if (ndate1 < ndate2) {
            return SMALLER_THAN;
        }
        else if (ndate1 > ndate2){
            return LARGER_THAN;
        }
        else {
            return EQUAL;
        }
    }
    @catch (NSException *exception) {
        return UNDEFINED;
    }
}

+ (NSString *) getMessContentWithMessCode:(NSString *) messCode
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"MessageCodeContent" ofType:@"plist"];
    NSDictionary *dictionary = [[[NSDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    NSString * messContent = [dictionary objectForKey:messCode];
    return messContent;
}
+ (BOOL) isEmail:(NSString *) email
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![emailTest evaluateWithObject:email]) {
        return NO;
    }
    else {
        return YES;
    }
}
+(NSString *)getDateFromDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    [dateFormatter release];
    return dateString;
    
}
+(NSString *)getUTCFormateFromString:(NSString *)localDate
{
    NSString *dateString = [localDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    return dateString;
}
+(NSString *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    [dateFormatter release];
    return dateString;
}
+ (NSDictionary * ) getLaguages:(NSString *) _lagName
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Vietnamese" ofType:@"plist"];
    NSDictionary *dictionary = [[[NSDictionary alloc] initWithContentsOfFile:plistPath]autorelease];
    return dictionary;
}
+ (NSString *) getKeyMaHoa
{
    NSString *sKey = @"ViVietAPP";
    NSString * md5 = [Common toMD5:sKey];
    NSString *stringToReturn = [md5 substringWithRange:NSMakeRange(3, 9)];
    return stringToReturn;
}
+ (NSString *) giaiMaDataToString:(NSData *) data
{
    NSString * password = [Common getKeyMaHoa];
    //    NSData *encrypted = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *decrypted = [[RNCryptor AES256Cryptor] decryptData:data password:password error:&error];
    NSString * stringToReturn = [NSString stringWithUTF8String:[decrypted bytes]];
    return stringToReturn;
}
+ (NSData *) maHoaStringToData:(NSString *) string
{
    NSString * password = [Common getKeyMaHoa];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *encrypted = [[RNCryptor AES256Cryptor] encryptData:data password:password error:&error];
    //    NSString *stringToreturn  = [NSString stringWithUTF8String:[encrypted bytes]];
    return encrypted;
}
+(NSString *)toMD5:(NSString *)source
{
    const char *src = [[source lowercaseString] UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(src, (unsigned int)strlen(src), result);
    
    NSString *ret = [[[NSString alloc] initWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]
                      ] autorelease];
    
    return ret;
}

+(BOOL)isNumericString:(NSString *)str
{
    if (str == nil || str.length == 0)
        return NO;
    
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:str];
    return [alphaNums isSupersetOfSet:inStringSet];
}
+(NSDateComponents *) getDateComponentsFromDate:(NSDate *) _date
{
    NSCalendar *gregorian = [[[NSCalendar alloc]
                              initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    //    [gregorian setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:7]];
    NSDateComponents *dateComponents =[gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:_date];
    return dateComponents;
}
+(NSString*) dateToString1:(NSDate*) _date
{
    NSDateComponents *compoments = [self getDateComponentsFromDate:_date];
    NSString *day = compoments.day < 10 ? [NSString stringWithFormat:@"0%d",(int)compoments.day] :[NSString stringWithFormat:@"%d",(int)compoments.day];
    NSString *month = compoments.month < 10 ? [NSString stringWithFormat:@"0%d",(int)compoments.month] :[NSString stringWithFormat:@"%d",(int)compoments.day];
    //    int year = compoments.year > 2000 ? compoments.year - 2000 : compoments.year;
    int year = (int)compoments.year ;//> 2000 ? compoments.year - 2000 : compoments.year;
    
    NSString *result = [NSString stringWithFormat:@"%@/%@/%d",day,month,year];
    return  result;
}
+(NSString*) dateToString:(NSDate*) _date
{
    NSDateComponents *compoments = [self getDateComponentsFromDate:_date];
    NSString *day = compoments.day < 10 ? [NSString stringWithFormat:@"0%d",(int)compoments.day] :[NSString stringWithFormat:@"%d",(int)compoments.day];
    NSString *month = compoments.month < 10 ? [NSString stringWithFormat:@"0%d",(int)compoments.month] :[NSString stringWithFormat:@"%d",(int)compoments.day];
    int year = (int)compoments.year > 2000 ? (int)compoments.year - 2000 : (int)compoments.year;
    
    NSString *result = [NSString stringWithFormat:@"%@/%@/%d",day,month,year];
    return  result;
}
+(NSString*) convertStringToUnsign:(NSString*)_char
{
    NSString *result = [_char uppercaseString];
    NSArray *chars = [NSArray arrayWithObjects:
                      @"A",
                      @"D",
                      @"E",
                      @"I",
                      @"Y",
                      @"O",
                      nil];
    NSArray *str_unichars = [NSArray arrayWithObjects:
                             @"Á|À|Ạ|Ả|Â|Ă",
                             @"Đ",
                             @"É|È|Ẹ|Ẻ|Ê|Ế|Ệ|Ề|Ể",
                             @"Í|Ì|Ị|Ỉ",
                             @"Ý|Ỳ|Ỵ|Ỷ",
                             @"Ó|Ò|Ọ|Ỏ|Ô|Ố|Ồ|Ộ|Ổ",
                             nil];
    for (int i=0; i<[str_unichars count]; i++){
        NSString *str = [str_unichars objectAtIndex:i];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",result];
        if([pre evaluateWithObject:str]){
            result = [chars objectAtIndex:i];
            break;
        }
    }
    return  result;
}


+ (NSString *)chuyenKhongDau:(NSString *)sInput
{
    
    NSString *sOutput = @"";
    NSString *x = @"";
    for(int i = 0; i < sInput.length; i++) {
        x = [NSString stringWithFormat:@"%C", [sInput characterAtIndex:i] ];
        
        if ([x isEqualToString:@"đ"])
            x = @"d";
        else if ([x isEqualToString:@"Đ"])
            x = @"D";
        else if ([x isEqualToString:@"à"] || [x isEqualToString:@"á"] || [x isEqualToString:@"ả"] || [x isEqualToString:@"ã"] || [x isEqualToString:@"ạ"])
            x = @"a";
        else if ([x isEqualToString:@"À"] || [x isEqualToString:@"Á"] || [x isEqualToString:@"Ả"] || [x isEqualToString:@"Ã"] ||[x isEqualToString:@"Ạ"])
            x = @"A";
        else if ([x isEqualToString:@"ă"] || [x isEqualToString:@"ằ"] || [x isEqualToString:@"ắ"] || [x isEqualToString:@"ẳ"] || [x isEqualToString:@"ẵ"] || [x isEqualToString:@"ặ"])
            x = @"a";
        else if ([x isEqualToString:@"Ă"] || [x isEqualToString:@"Ằ"] || [x isEqualToString:@"Ắ"] || [x isEqualToString:@"Ẳ"] || [x isEqualToString:@"Ẵ"] || [x isEqualToString:@"Ặ"])
            x = @"A";
        else if ([x isEqualToString:@"â"] || [x isEqualToString:@"ầ"] || [x isEqualToString:@"ấ"] || [x isEqualToString:@"ẩ"] || [x isEqualToString:@"ẫ"] || [x isEqualToString:@"ậ"])
            x = @"a";
        else if ([x isEqualToString:@"Â"] || [x isEqualToString:@"Ầ"] || [x isEqualToString:@"Ấ"] || [x isEqualToString:@"Ẩ"] || [x isEqualToString:@"Ẫ"] || [x isEqualToString:@"Ậ"])
            x = @"A";
        else if ([x isEqualToString:@"è"] || [x isEqualToString:@"é"] || [x isEqualToString:@"ẻ"] || [x isEqualToString:@"ẽ"] || [x isEqualToString:@"ẹ"])
            x = @"e";
        else if ([x isEqualToString:@"È"] || [x isEqualToString:@"É"] || [x isEqualToString:@"Ẻ"] || [x isEqualToString:@"Ẽ"] || [x isEqualToString:@"Ẹ"])
            x = @"E";
        else if ([x isEqualToString:@"ê"] || [x isEqualToString:@"ề"] || [x isEqualToString:@"ế"] || [x isEqualToString:@"ể"] || [x isEqualToString:@"ễ"] || [x isEqualToString:@"ệ"])
            x = @"e";
        else if ([x isEqualToString:@"Ê"] || [x isEqualToString:@"Ề"] || [x isEqualToString:@"Ế"] || [x isEqualToString:@"Ể"] || [x isEqualToString:@"Ễ"] || [x isEqualToString:@"Ệ"])
            x = @"E";
        else if ([x isEqualToString:@"ì"] || [x isEqualToString:@"í"] || [x isEqualToString:@"ỉ"] || [x isEqualToString:@"ĩ"] || [x isEqualToString:@"ị"])
            x = @"i";
        else if ([x isEqualToString:@"Ì"] || [x isEqualToString:@"Í"] || [x isEqualToString:@"Ỉ"] || [x isEqualToString:@"Ĩ"] || [x isEqualToString:@"Ị"])
            x = @"I";
        else if ([x isEqualToString:@"ò"] || [x isEqualToString:@"ó"] || [x isEqualToString:@"ỏ"] || [x isEqualToString:@"õ"] || [x isEqualToString:@"ọ"])
            x = @"o";
        else if ([x isEqualToString:@"Ò"] || [x isEqualToString:@"Ó"] || [x isEqualToString:@"Ỏ"] || [x isEqualToString:@"Õ"] || [x isEqualToString:@"Ọ"])
            x = @"O";
        else if ([x isEqualToString:@"ô"] || [x isEqualToString:@"ồ"] || [x isEqualToString:@"ố"] || [x isEqualToString:@"ổ"] || [x isEqualToString:@"ỗ"] || [x isEqualToString:@"ộ"])
            x = @"o";
        else if ([x isEqualToString:@"Ô"] || [x isEqualToString:@"Ồ"] || [x isEqualToString:@"Ố"] || [x isEqualToString:@"Ổ"] || [x isEqualToString:@"Ỗ"] || [x isEqualToString:@"Ộ"])
            x = @"O";
        else if ([x isEqualToString:@"ơ"] || [x isEqualToString:@"ờ"] || [x isEqualToString:@"ớ"] || [x isEqualToString:@"ở"] || [x isEqualToString:@"ỡ"] || [x isEqualToString:@"ợ"])
            x = @"o";
        else if ([x isEqualToString:@"Ơ"] || [x isEqualToString:@"Ờ"] || [x isEqualToString:@"Ớ"] || [x isEqualToString:@"Ở"] || [x isEqualToString:@"Ỡ"] || [x isEqualToString:@"Ợ"])
            x = @"O";
        else if ([x isEqualToString:@"ù"] || [x isEqualToString:@"ú"] || [x isEqualToString:@"ủ"] || [x isEqualToString:@"ũ"] || [x isEqualToString:@"ụ"])
            x = @"u";
        else if ([x isEqualToString:@"Ù"] || [x isEqualToString:@"Ú"] || [x isEqualToString:@"Ủ"] || [x isEqualToString:@"Ũ"] || [x isEqualToString:@"Ụ"])
            x = @"U";
        else if ([x isEqualToString:@"ư"] || [x isEqualToString:@"ừ"] || [x isEqualToString:@"ứ"] || [x isEqualToString:@"ử"] || [x isEqualToString:@"ữ"] || [x isEqualToString:@"ự"])
            x = @"u";
        else if ([x isEqualToString:@"Ư"] || [x isEqualToString:@"Ừ"] || [x isEqualToString:@"Ứ"] || [x isEqualToString:@"Ử"] || [x isEqualToString:@"Ữ"] || [x isEqualToString:@"Ự"])
            x = @"U";
        else if ([x isEqualToString:@"ỳ"] || [x isEqualToString:@"ý"] || [x isEqualToString:@"ỷ"] || [x isEqualToString:@"ỹ"] || [x isEqualToString:@"ỵ"])
            x = @"y";
        else if	([x isEqualToString:@"Ỳ"] || [x isEqualToString:@"Ý"] || [x isEqualToString:@"Ỷ"] || [x isEqualToString:@"Ỹ"] || [x isEqualToString:@"Ỵ"])
            x = @"Y";
        
        sOutput = [sOutput stringByAppendingString:x];
    }
    return sOutput;
}


+(NSMutableArray*) contactNames:(NSArray*) names startWith:(NSString*) _alphabet
{
    NSMutableArray* re = [[[NSMutableArray alloc] init] autorelease];
    for (NSString *str in names)
    {
        NSString * c = [str substringWithRange:NSMakeRange(0,1)];
        [c isEqualToString:@""];
        if ([c compare:_alphabet options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch] == NSOrderedSame)
            [re addObject:str];
        
    }
    return re;
}
/**
 *
 *      NSString format has a bug that ignore unused argument in positional arguments.
 *      This method does not allow %@, instead use %s
 *
 **/
+(NSString *) getcErrorDescription:(NSString *) msgCode, ...
{
    va_list va;
    va_start(va, msgCode);
    
    NSString * des = LocalizedString(msgCode);
    
    if ([des isEqualToString:msgCode] == YES)
    {
        NSString *msg_code_common = [msgCode stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"XX"];
        des = LocalizedString(msg_code_common);
        if ([des isEqualToString:msg_code_common] == YES)
        {
            return [NSString stringWithFormat:LocalizedString(@"unkown_msg_code_description"), msgCode];
        }
    }
    
    char *tmp = malloc(10000);
    tmp[0] = 0;
    const char *fmt = [des cStringUsingEncoding:NSUTF8StringEncoding];
    long l = vsnprintf(tmp, 10000, fmt, va);
    
    des = [[NSString alloc] initWithBytes:tmp length:l encoding:NSUTF8StringEncoding];
    free(tmp);
    
    return des;
}

+(NSString *) getErrorDescription:(NSString *) msgCode, ...
{
    if (msgCode == nil || msgCode.length < 2)
    {
        return  @"msg_code_wrong";
    }
    va_list va;
    va_start(va, msgCode);
    
    NSString * des = LocalizedString(msgCode);
    
    if ([des isEqualToString:msgCode] == YES)
    {
        NSString *msg_code_common = [msgCode stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"XX"];
        des = LocalizedString(msg_code_common);
        if ([des isEqualToString:msg_code_common] == YES)
        {
            return [NSString stringWithFormat:LocalizedString(@"unkown_msg_code_description"), msgCode];
        }
    }
    des = [[[NSString alloc] initWithFormat:des arguments:va] autorelease];
    return des;
}

+(NSString *)getVersion
{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    return version;
}

+(long long) convertDateToLong:(NSString *)sDate
{
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"dd-MM-yyyy";
    NSDate *date = [df dateFromString:sDate];
    NSTimeInterval seconds = [date timeIntervalSince1970];
    [df release];
    long long time = [[NSNumber numberWithDouble:(seconds *1000)] longLongValue];
    return time;
}

+(NSString *) convertLongToString:(long long)nLongDate
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(nLongDate/1000)];
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"dd-MM-yyyy";
    NSString *sKQ = [df stringFromDate:date];
    [df release];
    return sKQ;
}

+ (NSString *) convertLongToStringWithFormatter:(long long)nLongDate formatter:(NSString *)formatter{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(nLongDate/1000)];
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = formatter;
    NSString *sKQ = [df stringFromDate:date];
    [df release];
    return sKQ;
}

@end



@implementation UIColor(HexString)

+ (UIColor *) colorWithHexString: (NSString *) str
{
    str = [[str stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([str length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: str start: 0 length: 1];
            green = [self colorComponentFrom: str start: 1 length: 1];
            blue  = [self colorComponentFrom: str start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: str start: 0 length: 1];
            red   = [self colorComponentFrom: str start: 1 length: 1];
            green = [self colorComponentFrom: str start: 2 length: 1];
            blue  = [self colorComponentFrom: str start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: str start: 0 length: 2];
            green = [self colorComponentFrom: str start: 2 length: 2];
            blue  = [self colorComponentFrom: str start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: str start: 0 length: 2];
            red   = [self colorComponentFrom: str start: 2 length: 2];
            green = [self colorComponentFrom: str start: 4 length: 2];
            blue  = [self colorComponentFrom: str start: 6 length: 2];
            break;
            
        default:
            return nil;
    }
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end

#pragma mark - UIImage

@implementation UIImage (Umi)

+ (UIImage *)initWithSize:(CGSize)size drawing:(void (^)(CGContextRef ctx, CGSize size))drawing;
{
    int pixelsWide = size.width;
    int pixelsHigh = size.height;
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    bitmapBytesPerRow   = (pixelsWide * 4); //4
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    bitmapData = malloc( bitmapByteCount );
    memset(bitmapData, 0, bitmapByteCount);  // set memory to black, alpha 0
    if (bitmapData == NULL)
    {
        return NULL;
    }
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate (bitmapData, // instead of bitmapData
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    CGContextSetFillColorSpace(context, colorSpace);
    CGColorSpaceRelease(colorSpace);
    
    
    if (context == NULL)
    {
        free (bitmapData);
        return NULL;
    }
    
    // BEGIN DRAWING
    
    drawing (context, size);
    
    // END DRAWING
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *retImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGContextRelease(context);
    free(bitmapData);
    
    return retImage;
}

@end

#pragma mark - Date

@implementation NSDate (Umi)

- (NSString *)format:(NSString *)pattern;
{
    NSDateFormatter *dfm = [NSDateFormatter new];
    dfm.dateFormat = pattern;
    NSString *str = [dfm stringFromDate:self];
    [dfm release];
    return str;
}

- (NSDateComponents *)default_component
{
    id ret = objc_getAssociatedObject(self, "default_component");
    if (ret == nil)
    {
        NSUInteger flag = kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond;
        ret = [[NSCalendar currentCalendar] components:flag fromDate:self];
        
        [self set_default_component:ret];
    }
    return ret;
}

- (void)set_default_component:(NSDateComponents *)com
{
    objc_setAssociatedObject(self, "default_component", com, OBJC_ASSOCIATION_RETAIN);
}

- (int)year
{
    NSDateComponents *dc = [self default_component];
    
    return (int)dc.year;
}

- (int)month
{
    return (int)[self default_component].month;
}

- (int)day
{
    return (int)[self default_component].day;
}

- (int)hour
{
    return (int)[self default_component].hour;
}

- (int)minute
{
    return (int)[self default_component].minute;
}

- (int)second
{
    return (int)[self default_component].second;
}

@end

#pragma mark - NSMutableArray

@implementation NSMutableArray (Umi)

- (NSMutableArray *)shuffle
{
    NSUInteger loop = [self count] * 3;
    NSUInteger count = [self count];
    
    for (NSUInteger j = 0; j < loop; ++j)
    {
        NSUInteger i = j % count;
        NSInteger n = arc4random() % count;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    return self;
}

@end

#pragma mark - NSString

@implementation NSString (Umi)

- (NSDate *)parseDateWithFormat:(NSString *)format;
{
    NSDateFormatter *dfm = [NSDateFormatter new];
    dfm.dateFormat = format;
    
    return [dfm dateFromString:self];
}

@end

@implementation MFMessageComposeViewController (Umi)

+ (MFMessageComposeViewController *)text:(NSString *)text
                                      to:(NSArray *)guys
                                callback:(void (^)(MFMessageComposeViewController *composer, MessageComposeResult result))callback;
{
    if ([MFMessageComposeViewController canSendText] == NO)
        return nil;
    
    MFMessageComposeViewController *mf = [[[MFMessageComposeViewController alloc] init] autorelease];
    
    if (callback != nil)
    {
        callback = [callback copy];
        objc_setAssociatedObject(mf, "umi_sms_callback", callback, OBJC_ASSOCIATION_RETAIN);
    }
    
    mf.body = text;
    mf.recipients = guys;
    mf.messageComposeDelegate = (id<MFMessageComposeViewControllerDelegate>)mf;
    return mf;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result;
{
    void (^callback)(MFMessageComposeViewController *composer, MessageComposeResult result);
    
    callback = objc_getAssociatedObject(controller, "umi_sms_callback");
    if (callback)
    {
        callback (controller, result);
        objc_setAssociatedObject(controller, "umi_sms_callback", nil, OBJC_ASSOCIATION_RETAIN);
    }
    
    //    [controller dismissModalViewControllerAnimated:YES];
    [controller dismissViewControllerAnimated:YES completion:^{}];
}

+ (NSString *)convertImageToBase64:(UIImage *)viewImage {
    NSData *imageData = UIImagePNGRepresentation(viewImage);
    NSString *b64EncStr = [Base64 encode: imageData];
    return b64EncStr;
}

@end
