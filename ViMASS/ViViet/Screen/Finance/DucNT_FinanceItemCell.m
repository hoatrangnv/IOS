//
//  DucNT_FinanceItemCellTableViewCell.m
//  ViMASS
//
//  Created by MacBookPro on 7/14/14.
//
//

#import "DucNT_FinanceItemCell.h"

@implementation DucNT_FinanceItemCell

- (void)awakeFromNib
{
    // Initialization code
//    [self setBackgroundColor:[UIColor colorWithRed:0.0f green:56.0f blue:84.0f alpha:0.5f]];
//    _lbItem.textColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    if(_lbItem)
        [_lbItem release];
    [super dealloc];
}
@end
