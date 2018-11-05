//
//  TableCategoryCellViewController.m
//  ViMASS
//
//  Created by Chung NV on 6/28/13.
//
//

#import "TableCategoryCell.h"
#define kLABEL_COLOR_SELECTED [UIColor colorWithRed:0.0 green:123.0/255 blue:190.0/255 alpha:1]
#define kLABEL_COLOR_UNSELECTED [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1]

@interface TableCategoryCell ()

@end

@implementation TableCategoryCell

- (void)dealloc {
    [wrapper release];
    [lblName release];
    [btTick release];
    [btRemove release];
    [btCount release];
    [super dealloc];
    
}
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
    NSArray *selecteds = [_category getSubsSelected];
    if (selecteds && selecteds.count > 0)
    {
        btTick.enabled = NO;
        btRemove.enabled = NO;
        btCount.enabled = NO;
//        [UIView animateWithDuration:0.3 animations:^{
            lblName.textColor = kLABEL_COLOR_SELECTED;
            btTick.hidden = YES;
            btRemove.hidden = NO;
            btCount.hidden = NO;
            NSInteger count = selecteds.count;
            [btCount setTitle:[NSString stringWithFormat:@"%@%ld",count>9?@"" : @"0",(long)count]
                     forState:UIControlStateNormal];
//        } completion:^(BOOL finished) {
            btTick.enabled = YES;
            btRemove.enabled = YES;
            btCount.enabled = YES;
//        }];
    }else
    {
        btTick.enabled = NO;
        btRemove.enabled = NO;
        btCount.enabled = NO;
//        [UIView animateWithDuration:0.3 animations:^{
            lblName.textColor = kLABEL_COLOR_UNSELECTED;
            btTick.hidden = NO;
            btRemove.hidden = YES;
            btCount.hidden = YES;
//        } completion:^(BOOL finished) {
            btTick.enabled = YES;
            btRemove.enabled = YES;
            btCount.enabled = YES;
//        }];
        
        btTick.hidden = NO;
        btRemove.hidden = YES;
        btCount.hidden = YES;
    }
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected)
    {
        wrapper.backgroundColor = [UIColor colorWithRed:87.0/255.0f green:216.0/255.0f blue:113.0/255.0f alpha:1];
    }else
    {
        wrapper.backgroundColor = [UIColor whiteColor];
    }
}
- (IBAction)btTickClicked:(id)sender
{
    
}
@end
