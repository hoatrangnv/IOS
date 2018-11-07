//
//  FooterTable.h
//  ViViMASS
//
//  Created by Mac Mini on 11/2/18.
//

#import <UIKit/UIKit.h>
#import "UmiTextView.h"
#import "ExTextField.h"
@protocol FooterTableDelegate
- (void)doVanTay;
- (void)doThucHien;
- (void)doSMS;
- (void)doToken;
@end
@interface FooterTable : UITableViewCell
@property(assign) id<FooterTableDelegate> delegate;
@property (retain, nonatomic) IBOutlet UmiTextView *txtNoiDung;
@property (retain, nonatomic) IBOutlet ExTextField *tfNoiDung;

@property (retain, nonatomic) IBOutlet UILabel *lbTongTien;
@property (retain, nonatomic) IBOutlet UILabel *lbTongPhi;
@property (retain, nonatomic) IBOutlet UIButton *btnSMS;
@property (retain, nonatomic) IBOutlet UIButton *btnVanTay;
@property (retain, nonatomic) IBOutlet UIButton *btnToken;
@property (retain, nonatomic) IBOutlet UILabel *lbCountTime;
@property (retain, nonatomic) IBOutlet UITextField *txtOtp;
@property (retain, nonatomic) IBOutlet UIButton *btnThucHien;
@property (retain, nonatomic) IBOutlet UILabel *lbTime;
- (IBAction)onGiauVi:(id)sender;
- (IBAction)doToken:(id)sender;
- (IBAction)doThucHien:(id)sender;
- (IBAction)doSMS:(id)sender;
- (IBAction)doVantay:(id)sender;

-(void)setupView;
@end
