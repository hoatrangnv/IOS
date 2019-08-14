//
//  GiaoDienChonGheCGV.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 6/23/16.
//
//

#import <UIKit/UIKit.h>

@interface GiaoDienChonGheCGV : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (retain, nonatomic) NSMutableArray *arrGiaTien;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end
