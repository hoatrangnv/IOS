//
//  ChuyenTienDienThoaiVC.h
//  ViViMASS
//
//  Created by Mac Mini on 10/10/18.
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
#import "GiaoDichViewController.h"
@interface ChuyenTienDienThoaiVC : GiaoDichViewController
@property (retain, nonatomic) IBOutlet UITableView *tblContatcs;
- (IBAction)onAddNewPhone:(id)sender;

@end
