//
//  SaoKe_QuaTang.m
//  ViViMASS
//
//  Created by DucBT on 3/31/15.
//
//

#import "SaoKe_QuaTang.h"
#import "Common.h"
#import "UIImageView+WebCache.h"
#import "ViewQuaTang.h"
#import "DucNT_LuuRMS.h"

@implementation SaoKe_QuaTang

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75]];
    [_mViewChua.layer setCornerRadius:4];
    [_mViewChua.layer setMasksToBounds:YES];
}

- (void)updateView:(DucNT_SaoKeObject*)saoKeObject itemQuaTang:(ItemQuaTang *)item
{
//    self.mViewQuaTang.mItemQuaTang = item;
//    [self.mViewQuaTang reloadData];
    item.mName.content = [saoKeObject layNoiDung];
    item.mAmount.content = [NSString stringWithFormat:@"%@", saoKeObject.amount];
    item.mMessage.content = [saoKeObject layGiftName];
    ViewQuaTang *viewQuaTang = [[[NSBundle mainBundle] loadNibNamed:@"ViewQuaTang" owner:self options:nil] objectAtIndex:0];
    viewQuaTang.mItemQuaTang = item;
    viewQuaTang.frame = self.mViewQuaTang.bounds;
    [viewQuaTang reloadData];
    [self.mViewQuaTang addSubview:viewQuaTang];
    self.mlblThoiDiemTang.text = [NSString stringWithFormat:@"%@: %@", [@"thoi_diem_giao_dich" localizableString],  [saoKeObject layThoiGianChuyenTien]];
    BOOL flag = [saoKeObject.fromAcc isEqualToString:[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP]];
    if(flag)
    {
        self.mlblViTang.text = [NSString stringWithFormat:@"%@: %@", [@"tang_qua_vi_nhan" localizableString],  [saoKeObject toAcc]];
    }
    else
    {
        self.mlblViTang.text = [NSString stringWithFormat:@"%@: %@", [@"tang_qua_vi_tang" localizableString],  [saoKeObject fromAcc]];
    }
    
    [self.mlblThoiGianTang setText:[NSString stringWithFormat:@"%@: %@", [@"thoi_gian_tang" localizableString],  [saoKeObject layTimeAction]]];
    [self hienThiViewChiTietQuaTang:flag];
    [self setNeedsDisplay];
}

- (void)hienThiViewChiTietQuaTang:(BOOL)bNhanQua
{
    CGRect rViewChua = self.mViewChua.frame;
    CGRect rlblTenVi = self.mlblViTang.frame;
    CGRect rlblThoiDiemTang = self.mlblThoiDiemTang.frame;
    CGRect rlblThoiGianTang = self.mlblThoiGianTang.frame;
    CGRect rViewChiTietQuaTang = self.mViewChiTietQuaTang.frame;
    if(bNhanQua)
    {
        [self.mlblThoiGianTang setHidden:NO];
        rlblThoiGianTang.origin.y = rlblTenVi.origin.y + rlblTenVi.size.height;
        rlblThoiDiemTang.origin.y = rlblThoiGianTang.origin.y + rlblThoiGianTang.size.height;
        rViewChiTietQuaTang.size.height = rlblThoiDiemTang.origin.y + rlblThoiDiemTang.size.height;
    }
    else
    {
        [self.mlblThoiGianTang setHidden:YES];
        rlblThoiDiemTang.origin.y = rlblTenVi.origin.y + rlblTenVi.size.height;
        rViewChiTietQuaTang.size.height = rlblThoiDiemTang.origin.y + rlblThoiDiemTang.size.height;
    }
    rViewChua.size.height = rViewChiTietQuaTang.size.height + rViewChiTietQuaTang.origin.y;
    self.mViewChua.frame = rViewChua;
    self.mlblThoiDiemTang.frame = rlblThoiDiemTang;
    self.mlblThoiGianTang.frame = rlblThoiGianTang;
    self.mViewChiTietQuaTang.frame = rViewChiTietQuaTang;
}

#pragma mark - touch event
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = [touches anyObject];
//    if([touch view] != self.tvDescrip)
//    {
        [self removeFromSuperview];
//    }
}

- (void)dealloc {
    [_mViewChua release];
    [_mViewQuaTang release];
    [_mViewChiTietQuaTang release];
    [_mlblViTang release];
    [_mlblThoiDiemTang release];

    [_mlblThoiGianTang release];
    [super dealloc];
}
@end
