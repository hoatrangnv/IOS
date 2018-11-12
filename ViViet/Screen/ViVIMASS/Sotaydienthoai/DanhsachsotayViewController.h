

#import <UIKit/UIKit.h>
@class MoneyContact;
@protocol DanhsachsotayViewControllerDelegate<NSObject>
- (void)didSeletedContact:(NSArray*)phoneContact andNoiDung:(NSString*)noidung;
@end
@interface DanhsachsotayViewController : UIViewController
@property(strong,nonatomic) id<DanhsachsotayViewControllerDelegate> delegate;
@end
