

#import <UIKit/UIKit.h>
@class MoneyContact;
@protocol DanhsachsotayViewControllerDelegate<NSObject>
- (void)didSeletedContact:(NSArray*)phoneContact;
@end
@interface DanhsachsotayViewController : UIViewController
@property(strong,nonatomic) id<DanhsachsotayViewControllerDelegate> delegate;
@end
