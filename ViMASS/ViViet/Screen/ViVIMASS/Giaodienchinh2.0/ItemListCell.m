//
//  ItemListCell.m
//  ViViMASS
//
//  Created by Mac Mini on 10/11/18.
//

#import "ItemListCell.h"

@implementation ItemListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    [_imgTitle release];
    [_lblName release];
    [super dealloc];
}
@end
