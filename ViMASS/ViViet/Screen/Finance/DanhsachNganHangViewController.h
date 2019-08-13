//
//  DanhsachNganHangViewController.h
//  ViViMASS
//
//  Created by Nguyen Van Hoanh on 11/26/18.
//

#import <UIKit/UIKit.h>
@protocol DanhsachNganHangViewControllerDelegate<NSObject>
-(void)didSeletedBank:(NSInteger)indexSelected;
@end
@interface DanhsachNganHangViewController : UIViewController
@property(nonatomic,retain) id<DanhsachNganHangViewControllerDelegate>delegate;
@end
