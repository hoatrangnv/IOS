//
//  TreeTableCategoryCell.m
//  ViMASS
//
//  Created by Chung NV on 5/30/13.
//
//



#import "TreeTableCategoryCell.h"
#import "Common.h"

@interface TreeTableCategoryCell ()

@end

@implementation TreeTableCategoryCell

- (IBAction)btTick_Clicked
{
    _category.selected = !_category.selected;
    [self setTick];
}

-(void)setTick
{
    UIImage *img_tick;
    if (_category.selected)
        img_tick = [UIImage imageNamed:@"left_tick"];
    else
        img_tick = [UIImage imageNamed:@"left_untick"];
    
    [btTick setImage:img_tick forState:UIControlStateNormal];
}

-(void)setCategory:(SVCategory *)cate
{
    if (cate != _category)
    {
        [_category release];
        _category = [cate retain];
        
        NSString *name = cate.name;
        lblName.text = name;
        
        [self setTick];
    }
    
}
-(void)didMoveToSuperview
{
    bg.image = [Common stretchImage:@"cell_left_bg"];
}

- (void)dealloc
{
    [_category release];
    
    [lblName release];
    [bg release];
    [btTick release];
    [super dealloc];
}
@end
