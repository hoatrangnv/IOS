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
@property (nonatomic, retain) NSString *sDataQR;
@end

NS_ASSUME_NONNULL_END
