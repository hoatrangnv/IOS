//
//  GiaoDienChonChuyenBay.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/7/16.
//
//

#import "GiaoDichViewController.h"
#import "ItemChuyenBay.h"

@protocol GiaoDienChonChuyenBayProtocol <NSObject>
- (void)chonChuyenBay:(ItemChuyenBay *)itemDi itemDen:(ItemChuyenBay *)itemDen;
@end

@interface GiaoDienChonChuyenBay : GiaoDichViewController

@property (nonatomic, assign) id<GiaoDienChonChuyenBayProtocol> delegate;
@property (nonatomic, retain) NSString *sTimeDi;
@property (nonatomic, retain) NSString *sTimeVe;
@property (nonatomic, retain) NSString *sMaSanBayDi;
@property (nonatomic, retain) NSString *sMaSanBayDen;
@property (nonatomic, retain) NSDictionary *dicKetQua;
@property (nonatomic, retain) NSIndexPath *indexDi;
@property (nonatomic, retain) NSIndexPath *indexVe;
@property (retain, nonatomic) IBOutlet UITableView *tableChonChuyen;
@property (retain, nonatomic) IBOutlet ExTextField *edLuaChon;
- (IBAction)suKienChonTiepTuc:(id)sender;
@end
