//
//  GiaoDienDatVeXemPhim.h
//  ViViMASS
//
//  Created by nguyen tam on 9/17/15.
//
//

#import "GiaoDichViewController.h"
#import "TPKeyboardAvoidAcessory.h"
#import "ItemPhongXemFilm.h"
#import "ItemHangXemFilm.h"
#import "ItemGheXemFilm.h"

@protocol GiaoDienDatChoXemPhimProtocol <NSObject>

-(void)sendLaiRapPhim:(ItemPhongXemFilm *)item gheChon:(NSMutableArray *)arrGhe;

@end

@interface GiaoDienDatChoXemPhim : GiaoDichViewController
@property (nonatomic, assign) id<GiaoDienDatChoXemPhimProtocol> delegate;
@property (nonatomic, retain) ItemPhongXemFilm *phongHienTai;
@property (retain, nonatomic) IBOutlet UIView *viewGheCGV;
@property (retain, nonatomic) IBOutlet UIView *viewGhePlatium;
@property (nonatomic, assign) BOOL isSau17h;
@property (nonatomic, retain) NSString *sTenFilm;
@property (nonatomic, retain) NSString *sHeaderRap;
@property (nonatomic, retain) NSArray *arrGheCGV;
@property (retain, nonatomic) IBOutlet UIWebView *webPhongChieu;
@property (retain, nonatomic) IBOutlet UILabel *lblSoGhe;
@property (retain, nonatomic) IBOutlet UILabel *lblSoTien;
- (IBAction)suKienChonTiepTuc:(id)sender;


@end
