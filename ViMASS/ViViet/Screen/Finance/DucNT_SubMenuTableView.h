//
//  DucNT_SubMenuTableView.h
//  ViMASS
//
//  Created by DucBT on 10/8/14.
//
//

#import "SubItemTaiChinh.h"

@protocol DucNT_SubMenuTableViewDelegate <NSObject>

- (void)suKienChonSubMenuItemTaiChinh:(SubItemTaiChinh*)subItem;

@end

@interface DucNT_SubMenuTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSArray *mDanhSachSubItem;
@property (nonatomic, assign) id<DucNT_SubMenuTableViewDelegate> mDelegate;

@end
