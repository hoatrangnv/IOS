//
//  GiaoDienHoTroThanhToan.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 9/8/19.
//

#import "GiaoDichViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GiaoDienHoTroThanhToan : GiaoDichViewController
@property (retain, nonatomic) IBOutlet UIButton *btnTraCuu;
@property (retain, nonatomic) IBOutlet UIButton *btnHuongDan;
@property (retain, nonatomic) IBOutlet UIButton *btnHuongDanTraCuu;
@property (retain, nonatomic) IBOutlet UIStackView *stackTop;

@property (retain, nonatomic) IBOutlet UIView *viewShowMain;
- (IBAction)suKienChonBack:(id)sender;
- (IBAction)suKienChonTraCuu:(id)sender;
- (IBAction)suKienChonHuongDan:(id)sender;
- (IBAction)suKienChonHuongDanTraCuu:(id)sender;

@end

NS_ASSUME_NONNULL_END
