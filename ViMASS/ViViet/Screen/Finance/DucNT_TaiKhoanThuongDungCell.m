//
//  DucNT_TaiKhoanThuongDungCell.m
//  ViMASS
//
//  Created by MacBookPro on 7/25/14.
//
//

#import "DucNT_TaiKhoanThuongDungCell.h"

@implementation DucNT_TaiKhoanThuongDungCell

@synthesize lbTenTaoKhoan;
@synthesize imvLoaiTaiKhoan;
@synthesize btnDelete;
@synthesize btnEdit;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    if(lbTenTaoKhoan)
        [lbTenTaoKhoan release];
    if(imvLoaiTaiKhoan)
        [imvLoaiTaiKhoan release];
    if(btnDelete)
        [btnDelete release];
    if(btnEdit)
        [btnEdit release];
    [_btnCheckThongBao release];
    [super dealloc];
}
- (IBAction)suKienEditTKTD:(id)sender {
    if(self.delegate)
       [self.delegate editCell:self];
}

- (IBAction)suKienDeleteTKTD:(id)sender {
    if(self.delegate)
        [self.delegate deleteCell:self];
}
@end
