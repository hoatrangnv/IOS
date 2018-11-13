

#import "ChonAnSauDtTableViewCell.h"

@implementation ChonAnSauDtTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnSelect setBackgroundImage:[UIImage imageNamed:@"radio-unselected"] forState:UIControlStateNormal];
    [self.btnSelect setBackgroundImage:[UIImage imageNamed:@"radio-selected"] forState:UIControlStateSelected];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)doSelect:(id)sender {
    if (_delegate) {
        [_delegate actionSelect:self];
    }
}

- (void)dealloc {
    [_lblTitle release];
    [_lblLogo release];
    [_btnSelect release];
    [super dealloc];
}
@end
