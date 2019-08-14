//
//  GiaoDienDiemThanhToanVNPAY.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 5/6/19.
//

#import "GiaoDichViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GiaoDienDiemThanhToanVNPAY : GiaoDichViewController

@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UITextField *tfKhoangCach;
- (IBAction)suKienChonTimDiaDiem:(id)sender;

@end

NS_ASSUME_NONNULL_END
