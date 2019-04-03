//
//  ViewAuthentication.h
//  ViViMASS
//
//  Created by Nguyen Van Tam on 4/1/19.
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ViewAuthenticationDelegate
- (void)suKienChonXacThucVanTay;
- (void)suKienChonXacThucToken;
- (void)suKienChonXacThucSDSecure;
@end

@interface ViewAuthentication : UIView
@property (assign, nonatomic) id <ViewAuthenticationDelegate> delegate;
@property (nonatomic, assign) BOOL enableFaceID;
@property (retain, nonatomic) IBOutlet UIButton *btnSDSecure;
@property (retain, nonatomic) IBOutlet UIButton *btnToken;
@property (retain, nonatomic) IBOutlet UIButton *btnFinger;
@property (retain, nonatomic) IBOutlet UIView *viewNhapToken;
@property (retain, nonatomic) IBOutlet UIButton *btnThucHien;
@property (retain, nonatomic) IBOutlet ExTextField *tfToken;

- (IBAction)suKienChonSDSecure:(id)sender;
- (IBAction)suKienChonToken:(id)sender;
- (IBAction)suKienChonFinger:(id)sender;
- (IBAction)suKienChonThucHien:(id)sender;
- (void)xuLyKhiChonXacThucKhac;
@end

NS_ASSUME_NONNULL_END
