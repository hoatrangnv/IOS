//
//  GiaoDienThanhToanTruyenHinh.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/3/16.
//
//

#import "GiaoDichViewController.h"

@interface GiaoDienThanhToanTruyenHinh : GiaoDichViewController
@property (retain, nonatomic) IBOutlet ExTextField *edMaThueBao;
@property (retain, nonatomic) IBOutlet ExTextField *edNhaCungCap;
@property (retain, nonatomic) IBOutlet ExTextField *edSoTien;

@property (nonatomic, retain) NSString *sIdTraCuu;
@property (nonatomic, retain) NSString *sMaThueBao;
@property (nonatomic, assign) int nNhaCungCap;

@end
