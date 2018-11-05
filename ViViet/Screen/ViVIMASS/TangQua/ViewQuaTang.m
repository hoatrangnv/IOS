//
//  ViewQuaTang.m
//  ViViMASS
//
//  Created by DucBT on 2/27/15.
//
//

#import "UIImageView+WebCache.h"
#import "ViewQuaTang.h"
#import "Common.h"


@implementation ViewQuaTang

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setMItemQuaTang:(ItemQuaTang *)mItemQuaTang
{
    if(_mItemQuaTang)
        [_mItemQuaTang release];
    _mItemQuaTang = [mItemQuaTang retain];
    NSLog(@"%s - _mItemQuaTang.mAmount.content : %@", __FUNCTION__, _mItemQuaTang.mAmount.content);
    NSString *urlImage = [NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", _mItemQuaTang.mImage];
    [self.mimgvHienThi setImageWithURL:[NSURL URLWithString:urlImage]];
    
    //set view qua tang
    self.mlblTieuDe.text = _mItemQuaTang.mName.content;
    self.mlblTieuDe.textColor = [UIColor colorWithHexString:_mItemQuaTang.mName.color];
    self.mlblTieuDe.font = [UIFont fontWithName:_mItemQuaTang.mName.font size:[_mItemQuaTang.mName.size floatValue]];
    
    if(_mItemQuaTang.mName.font.length > 0)
        self.mlblTieuDe.font = [UIFont fontWithName:_mItemQuaTang.mName.font size:[_mItemQuaTang.mName.size floatValue]];
    else
        self.mlblTieuDe.font =[UIFont systemFontOfSize:[_mItemQuaTang.mName.size floatValue]];
    
    if([_mItemQuaTang.mName.css rangeOfString:@"text-align: right;"].location != NSNotFound)
    {
        self.mlblTieuDe.textAlignment = NSTextAlignmentRight;
    }
    else if([_mItemQuaTang.mName.css rangeOfString:@"text-align: center;"].location != NSNotFound)
    {
        self.mlblTieuDe.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        self.mlblTieuDe.textAlignment = NSTextAlignmentLeft;
    }
    
    
    self.mlblNoiDung.text = _mItemQuaTang.mMessage.content;
    self.mlblNoiDung.textColor = [UIColor colorWithHexString:_mItemQuaTang.mMessage.color];
    
    if(_mItemQuaTang.mMessage.font.length > 0)
        self.mlblNoiDung.font = [UIFont fontWithName:_mItemQuaTang.mMessage.font size:[_mItemQuaTang.mMessage.size floatValue]];
    else
        self.mlblNoiDung.font =[UIFont systemFontOfSize:[_mItemQuaTang.mMessage.size floatValue]];
    
    if([_mItemQuaTang.mMessage.css rangeOfString:@"text-align: right;"].location != NSNotFound)
    {
        self.mlblNoiDung.textAlignment = NSTextAlignmentRight;
    }
    else if([_mItemQuaTang.mMessage.css rangeOfString:@"text-align: center;"].location != NSNotFound)
    {
        self.mlblNoiDung.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        self.mlblNoiDung.textAlignment = NSTextAlignmentLeft;
    }

    self.mlblSoTien.text = _mItemQuaTang.mAmount.content;
    self.mlblSoTien.textColor = [UIColor colorWithHexString:_mItemQuaTang.mAmount.color];
    self.mlblSoTien.font = [UIFont fontWithName:_mItemQuaTang.mAmount.font size:[_mItemQuaTang.mAmount.size floatValue]];
    if([_mItemQuaTang.mAmount.css rangeOfString:@"text-align: right;"].location != NSNotFound)
    {
        self.mlblSoTien.textAlignment = NSTextAlignmentRight;
    }
    else if([_mItemQuaTang.mAmount.css rangeOfString:@"text-align: center;"].location != NSNotFound)
    {
        self.mlblSoTien.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        self.mlblSoTien.textAlignment = NSTextAlignmentLeft;
    }
    
    CGRect rlbSoTien = self.mlblSoTien.frame;
    CGRect rlbNoiDung = self.mlblNoiDung.frame;
    
//    if([_mItemQuaTang.mAmount.content doubleValue] == 0)
//    {
        rlbNoiDung.origin.y = rlbSoTien.origin.y;
        [self.mlblSoTien setHidden:YES];
//    }
//    else
//    {
//        [self.mlblSoTien setHidden:NO];
//        rlbNoiDung.origin.y = rlbSoTien.origin.y + rlbSoTien.size.height;
//    }
    
    self.mlblNoiDung.frame = rlbNoiDung;
    self.mlblSoTien.frame = rlbSoTien;
}

- (void)reloadData
{
    NSString *urlImage = [NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", _mItemQuaTang.mImage];
    [self.mimgvHienThi setImageWithURL:[NSURL URLWithString:urlImage]];
    
    //set view qua tang
    self.mlblTieuDe.text = _mItemQuaTang.mName.content;
    self.mlblTieuDe.textColor = [UIColor colorWithHexString:_mItemQuaTang.mName.color];
    self.mlblTieuDe.font = [UIFont fontWithName:_mItemQuaTang.mName.font size:[_mItemQuaTang.mName.size floatValue]];
    
    if(_mItemQuaTang.mName.font.length > 0)
        self.mlblTieuDe.font = [UIFont fontWithName:_mItemQuaTang.mName.font size:[_mItemQuaTang.mName.size floatValue]];
    else
        self.mlblTieuDe.font =[UIFont systemFontOfSize:[_mItemQuaTang.mName.size floatValue]];
    
    if([_mItemQuaTang.mName.css rangeOfString:@"text-align: right;"].location != NSNotFound)
    {
        self.mlblTieuDe.textAlignment = NSTextAlignmentRight;
    }
    else if([_mItemQuaTang.mName.css rangeOfString:@"text-align: center;"].location != NSNotFound)
    {
        self.mlblTieuDe.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        self.mlblTieuDe.textAlignment = NSTextAlignmentLeft;
    }
    
    
    self.mlblNoiDung.text = _mItemQuaTang.mMessage.content;
    self.mlblNoiDung.textColor = [UIColor colorWithHexString:_mItemQuaTang.mMessage.color];
    
    if(_mItemQuaTang.mMessage.font.length > 0)
        self.mlblNoiDung.font = [UIFont fontWithName:_mItemQuaTang.mMessage.font size:[_mItemQuaTang.mMessage.size floatValue]];
    else
        self.mlblNoiDung.font =[UIFont systemFontOfSize:[_mItemQuaTang.mMessage.size floatValue]];
    
    if([_mItemQuaTang.mMessage.css rangeOfString:@"text-align: right;"].location != NSNotFound)
    {
        self.mlblNoiDung.textAlignment = NSTextAlignmentRight;
    }
    else if([_mItemQuaTang.mMessage.css rangeOfString:@"text-align: center;"].location != NSNotFound)
    {
        self.mlblNoiDung.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        self.mlblNoiDung.textAlignment = NSTextAlignmentLeft;
    }
    
    self.mlblSoTien.text = [Common hienThiTienTe:[_mItemQuaTang.mAmount.content doubleValue]];
    self.mlblSoTien.textColor = [UIColor colorWithHexString:_mItemQuaTang.mAmount.color];
    self.mlblSoTien.font = [UIFont fontWithName:_mItemQuaTang.mAmount.font size:[_mItemQuaTang.mAmount.size floatValue]];
    if([_mItemQuaTang.mAmount.css rangeOfString:@"text-align: right;"].location != NSNotFound)
    {
        self.mlblSoTien.textAlignment = NSTextAlignmentRight;
    }
    else if([_mItemQuaTang.mAmount.css rangeOfString:@"text-align: center;"].location != NSNotFound)
    {
        self.mlblSoTien.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        self.mlblSoTien.textAlignment = NSTextAlignmentLeft;
    }
    
    CGRect rlbSoTien = self.mlblSoTien.frame;
    CGRect rlbNoiDung = self.mlblNoiDung.frame;
    
    if([_mItemQuaTang.mAmount.content doubleValue] == 0)
    {
        rlbNoiDung.origin.y = rlbSoTien.origin.y;
        [self.mlblSoTien setHidden:YES];
    }
    else
    {
        [self.mlblSoTien setHidden:NO];
        rlbNoiDung.origin.y = rlbSoTien.origin.y + rlbSoTien.size.height;
    }

    self.mlblNoiDung.frame = rlbNoiDung;
    self.mlblSoTien.frame = rlbSoTien;
}

- (void)dealloc {
    if(_mItemQuaTang)
        [_mItemQuaTang release];
    [_mlblTieuDe release];
    [_mlblSoTien release];
    [_mlblNoiDung release];
    [_mimgvHienThi release];
    [super dealloc];
}
@end
