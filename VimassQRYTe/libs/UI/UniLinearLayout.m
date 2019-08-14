//
//  UniLinearLayout.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 3/3/14.
//
//

#import "UniLinearLayout.h"

@implementation UniLinearLayout
{
    BOOL _initialized;
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    [super insertSubview:view atIndex:index];
    
    CGFloat t = 0;
    for (UIView *v in self.subviews)
    {
        CGRect r = v.frame;
        t += r.size.height;
    }
    
    CGRect r = self.frame;
    r.size.height = t;
    self.frame = r;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat t = 0;
    for (UIView *v in self.subviews)
    {
        CGRect r = v.frame;
        r.origin.y = t;
        v.frame = r;
        
        t += r.size.height;
    }
}

- (void)initUniLinearLayout
{
    if (_initialized)
        return;
    _initialized = YES;
    
    self.orientation = UniLinearLayoutOrientation_Vertical;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initUniLinearLayout];
    }
    return  self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initUniLinearLayout];
    }
    return self;
}

@end
