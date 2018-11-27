//
//  DialogXoaTKLienketViewController.h
//  ViViMASS
//
//  Created by Dao Minh Nha on 11/27/18.
//

#import <UIKit/UIKit.h>
#import "GiaoDichViewController.h"
@protocol DialogXoaTKLienketViewControllerDelegate <NSObject>

- (void)xuLySuKienXacThucVoiKieu:(NSInteger)nKieuXacThuc token:(NSString*)sToken otp:(NSString*)sOtp;

@end
@interface DialogXoaTKLienketViewController : GiaoDichViewController
@property (assign, nonatomic) id<DialogXoaTKLienketViewControllerDelegate> mDelegate;
-(void)setitleLable:(NSString*)title;
@end
