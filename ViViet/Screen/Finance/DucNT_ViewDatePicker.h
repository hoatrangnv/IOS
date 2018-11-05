//
//  DucNT_ViewDatePicker.h
//  ViMASS
//
//  Created by MacBookPro on 7/16/14.
//
//

#import <UIKit/UIKit.h>

typedef void(^GiaTriThoiGian)(NSString *);

@interface DucNT_ViewDatePicker : UIView
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (retain, nonatomic) IBOutlet UIButton *btnConfirm;
@property (retain, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)suKienConfirm:(id)sender;
- (IBAction)suKienCancel:(id)sender;

-(id)initWithNib;
-(void) truyenThongSoThoiGian:(GiaTriThoiGian) sThoiGian;

@end