//
//  ContactScreen.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 8/7/19.
//

#import "GiaoDichViewController.h"
#import "AppDelegate.h"
#import "Contact.h"

NS_ASSUME_NONNULL_BEGIN
#define KIEU_HIEN_THI_LIEN_HE_THUONG 1100
#define KIEU_HIEN_THI_LIEN_HE_MUON_TIEN 1101
@interface ContactScreen : GiaoDichViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, assign) NSInteger mKieuHienThiLienHe;
@property (nonatomic, assign) BOOL isShowTitle;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

- (void)selectContact: (void (^)(NSString *phone, Contact *contact)) onSelect_;
@end

NS_ASSUME_NONNULL_END
