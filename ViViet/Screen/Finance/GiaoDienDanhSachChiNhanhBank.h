//
//  GiaoDienDanhSachChiNhanhBank.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/15/16.
//
//

#import "GiaoDichViewController.h"

@interface GiaoDienDanhSachChiNhanhBank : GiaoDichViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) NSString *sKeyword;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, assign) int nKc;

@property (retain, nonatomic) IBOutlet UITableView *tableDanhSach;
@end
