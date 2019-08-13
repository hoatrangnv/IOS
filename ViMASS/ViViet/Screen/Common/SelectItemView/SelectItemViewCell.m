//
//  SelectItemViewCell.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/4/12.
//
//

#import "SelectItemViewCell.h"
#import "Common.h"

@implementation SelectItemViewCell
{
    UIImageView *_rowDiv;
}


+(NSString *)identify
{
    return @"Select Item View Cell";
}
+ (CGFloat)height
{
    return 44.0f;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect r = self.bounds;
    r.origin.y = r.size.height - 2;
    r.size.height = 2;
    _rowDiv.frame = r;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    background.image = [Common stretchImage:@"selectItem_cell_bg"];
}

- (void) initViews
{
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont boldSystemFontOfSize:14];
    
    _rowDiv = [[[UIImageView alloc] initWithImage:[Common stretchImage:@"RowDivider"]] autorelease];
    [self addSubview:_rowDiv];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [super setSelected:NO animated:animated];
}

- (void)dealloc {
    [background release];
    [_lblText release];
    [super dealloc];
}
@end
