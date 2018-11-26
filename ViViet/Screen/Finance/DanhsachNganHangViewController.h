//
//  DanhsachNganHangViewController.h
//  ViViMASS
//
//  Created by Dao Minh Nha on 11/26/18.
//

#import <UIKit/UIKit.h>
@protocol DanhsachNganHangViewControllerDelegate<NSObject>
-(void)didSeletedBank:(NSInteger)indexSelected;
@end
@interface DanhsachNganHangViewController : UIViewController
@property(nonatomic,retain) id<DanhsachNganHangViewControllerDelegate>delegate;
@end
