//
//  KazeCheckBox.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 11/23/12.
//
//

#import "KazeCheckBox.h"

@implementation KazeCheckBox

- (void)didSelectButton
{
    self.selected = !self.selected;
}

-(void) initViews
{
    [self setImage:[UIImage imageNamed:@"checked_sexy_checkbox"] forState:UIControlStateSelected];
    
    [self setImage:[UIImage imageNamed:@"sexy_checkbox"] forState:UIControlStateNormal];
    
    self.contentMode = UIViewContentModeCenter;
    [self addTarget:self action:@selector(didSelectButton) forControlEvents:UIControlEventTouchUpInside];
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initViews];
    }
    return self;
}

@end
