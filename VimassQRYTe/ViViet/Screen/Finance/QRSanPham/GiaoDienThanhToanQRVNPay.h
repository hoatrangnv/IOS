//
//  GiaoDienThanhToanQRVNPay.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/26/19.
//

#import "GiaoDichViewController.h"
#import "ItemVNPayQR.h"
NS_ASSUME_NONNULL_BEGIN

@interface GiaoDienThanhToanQRVNPay : GiaoDichViewController
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) ItemVNPayQR *itemQR;
@property (nonatomic, retain) NSString *sMaGiaoDich;
@property (nonatomic, retain) NSDictionary *dictChiTiet;
@property (nonatomic, assign) int maDonViCapQR;
- (IBAction)suKienChonLangViet:(id)sender;
- (IBAction)suKienChonLangEng:(id)sender;
- (IBAction)suKienChonLangChina:(id)sender;
- (IBAction)suKienChonLangRussia:(id)sender;
- (IBAction)suKienChonLangKorea:(id)sender;
- (IBAction)suKienChonLangJapan:(id)sender;
- (IBAction)suKienChonLangGerman:(id)sender;




@end

NS_ASSUME_NONNULL_END
