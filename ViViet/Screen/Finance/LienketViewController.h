//
//  LienketViewController.h
//  ViViMASS
//
//  Created by Dao Minh Nha on 11/23/18.
//

#import <UIKit/UIKit.h>
#import "GiaoDichViewController.h"
#import "RadioButton.h"
@interface LienketViewController : GiaoDichViewController
@property (retain, nonatomic) IBOutlet ExTextField *edBank;
@property (retain, nonatomic) IBOutlet ExTextField *edChuTK;
@property (retain, nonatomic) IBOutlet UIButton *btnVanTay;
@property (retain, nonatomic) IBOutlet UIButton *btnToken;
@property (retain, nonatomic) IBOutlet UITextField *txtOtp;
@property (retain, nonatomic) IBOutlet UIButton *btnThucHien;
@property (retain, nonatomic) IBOutlet RadioButton *btnSelect;
- (IBAction)doToken:(id)sender;
- (IBAction)doThucHien:(id)sender;
- (IBAction)doVantay:(id)sender;
- (IBAction)onMacding:(id)sender;
@end
