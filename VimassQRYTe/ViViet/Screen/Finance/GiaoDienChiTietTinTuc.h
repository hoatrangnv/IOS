//
//  GiaoDienChiTietTinTuc.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/11/19.
//

#import "GiaoDichViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GiaoDienChiTietTinTuc : GiaoDichViewController
@property (retain, nonatomic) IBOutlet UIWebView *webChiTiet;

@property (nonatomic, assign) int langID;
@property (nonatomic, retain) NSString *sIDTinTuc;

@end

NS_ASSUME_NONNULL_END
