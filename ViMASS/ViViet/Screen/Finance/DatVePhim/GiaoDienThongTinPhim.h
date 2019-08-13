//
//  GiaoDienThongTinPhim.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/22/15.
//
//

#import "GiaoDichViewController.h"
#import "ObjectFilm.h"
@interface GiaoDienThongTinPhim : GiaoDichViewController

@property (nonatomic, assign) int nOption;
@property (nonatomic, retain) ObjectFilm *itemFilmHienTai;
@property (retain, nonatomic) IBOutlet UIWebView *webThongTin;
@end
