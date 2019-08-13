//
//  GiaoDienTinTuc.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/8/19.
//

#import "GiaoDichViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol GiaoDienTinTucProtocol <NSObject>
- (void)suKienChonBackTinTuc;
@end

@interface GiaoDienTinTuc : GiaoDichViewController

@property (nonatomic, assign) id<GiaoDienTinTucProtocol> delegate;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)suKienChonBack:(id)sender;
- (IBAction)suKienChonVietNam:(id)sender;
- (IBAction)suKienChonEnglish:(id)sender;

@end

NS_ASSUME_NONNULL_END
