//
//  
//  ViMASS
//
//  Created by Ngo Ba Thuong on 8/17/13.
//
//

#import "UmiCheckBox.h"

@implementation UmiCheckBox

- (void)setImages:(UIImage *)unselected_image :(UIImage *) selected_image;
{
    [self setImage:unselected_image forState:UIControlStateNormal];
    [self setImage:selected_image forState:UIControlStateSelected];
}

- (void)on_touchup_inside
{
    self.selected = !self.selected;
}

- (void)init_UmiCheckBox
{
    [self addTarget:self action:@selector(on_touchup_inside) forControlEvents:UIControlEventTouchUpInside];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self init_UmiCheckBox];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self init_UmiCheckBox];
    }
    return self;
}


@end
