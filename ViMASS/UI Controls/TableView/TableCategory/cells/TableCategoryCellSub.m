//
//  TableCategoryCellSub.m
//  ViMASS
//
//  Created by Chung NV on 7/4/13.
//
//

#import "TableCategoryCellSub.h"

@interface TableCategoryCellSub ()

@end

@implementation TableCategoryCellSub

-(void)setCategory:(SVCategory *)cate
{
    if (cate != _category)
    {
        [_category release];
        _category = [cate retain];
        
        NSString *name = cate.name;
        lblName.text = name;
    }
    [self setTick];
    
}
-(void)setTick
{
//    UIImage *img_tick;
    UIColor *color = [UIColor whiteColor];
    if (_category.selected)
    {
        color = [UIColor colorWithRed:12.0/255 green:251.0/255 blue:181.0/255 alpha:1];
//        img_tick = [UIImage imageNamed:@"table_cate_tick"];
    }else
    {
//        img_tick = [UIImage imageNamed:@"table_cate_untick"];
    }
//    [btTick setImage:img_tick forState:UIControlStateNormal];
    lblName.textColor = color;
}
- (void)dealloc
{
    [lblName release];
    [_category release];
    [btTick release];
    [super dealloc];
}
@end
