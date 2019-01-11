

#import <UIKit/UIKit.h>
#import "GiaoDichViewController.h"
@class MoneyContact;
@protocol DanhsachsotayViewControllerDelegate<NSObject>
- (void)didSeletedContact:(NSArray*)phoneContact andNoiDung:(NSString*)noidung;
@end
@interface DanhsachsotayViewController : GiaoDichViewController
@property(strong,nonatomic) id<DanhsachsotayViewControllerDelegate> delegate;
@end
