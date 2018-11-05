//
//  QRDonViViewController.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/1/17.
//

#import <UIKit/UIKit.h>
#import "GiaoDichViewController.h"
@interface QRDonViViewController : GiaoDichViewController
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *viewQRPhongTo;
@property (retain, nonatomic) IBOutlet UIImageView *imgvQRPhongTo;

- (IBAction)suKienDongQRPhongTo:(id)sender;
@end
