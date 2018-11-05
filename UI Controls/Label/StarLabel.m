//
//  StarLabel.m
//  ViMASS
//
//  Created by Chung NV on 5/5/13.
//
//

#import "StarLabel.h"
#import "LocalizationSystem.h"

@implementation StarLabel
{
    BOOL isAppearStar;
}

-(CGRect)wrap_star_text
{
    CGRect r = self.frame;
    r.size.width -= 7;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:r];
    lbl.font = self.font;
    lbl.text = self.text;
    r = [lbl wrap_text];
    
    r.size.width += 7;
    self.frame = r;
    return r;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        isAppearStar = self.highlighted;
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    UIView *star = [self viewWithTag:20489];
    if (star == nil || [star isKindOfClass:[UIImageView class]] == NO)
        return;
    CGRect r = CGRectMake(0, 0, 5, 5);
    r.origin.y = roundf((self.frame.size.height - 5) / 2);
    star.frame = r;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    UIView *v = [self viewWithTag:20489];
    if (v!= nil && [v isKindOfClass:[UIImageView class]])
        return;
    
    UIImageView *star = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    star.tag = 20489;
    
    star.image = [UIImage imageNamed:@"label-star"];
    CGRect r = star.frame;
    r.origin.y = roundf((self.frame.size.height - 5) / 2);
    star.frame = r;
    [self addSubview:star];
    [star release];
}

-(void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 7, 0, 0);
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
@end
