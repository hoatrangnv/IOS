//
//  SaoKe_QuaTang.h
//  ViViMASS
//
//  Created by DucBT on 3/31/15.
//
//

#import <UIKit/UIKit.h>
#import "DucNT_SaoKeObject.h"
#import "ViewQuaTang.h"

@interface SaoKe_QuaTang : UIView

@property (retain, nonatomic) IBOutlet UIView *mViewChua;
@property (retain, nonatomic) IBOutlet UIView *mViewQuaTang;

@property (retain, nonatomic) IBOutlet UIView *mViewChiTietQuaTang;
@property (retain, nonatomic) IBOutlet UILabel *mlblViTang;
@property (retain, nonatomic) IBOutlet UILabel *mlblThoiDiemTang;
@property (retain, nonatomic) IBOutlet UILabel *mlblThoiGianTang;

- (void)updateView:(DucNT_SaoKeObject*)saoKeObject itemQuaTang:(ItemQuaTang*)item;

@end
