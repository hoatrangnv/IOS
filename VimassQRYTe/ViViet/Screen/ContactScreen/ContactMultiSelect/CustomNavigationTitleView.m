//
//  CustomNavigationTitleView.m
//  ViViMASS
//
//  Created by Nguyen Van Hoanh on 11/4/18.
//

#import "CustomNavigationTitleView.h"

@implementation CustomNavigationTitleView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initXib];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initXib];
    }
    return self;
}
- (void)initXib {
    [[NSBundle mainBundle] loadNibNamed:@"CustomNavigationTitleView" owner:self options:nil];
    _contentView.frame = self.bounds;
    NSLog(@"%@",NSStringFromCGRect(self.bounds));
    [self addSubview:_contentView];
}
- (BOOL)isHasText {
    return !_txtAddNumber.text.isEmpty;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_delegate) {
        [_delegate textFieldDidBeginEditing];
    }
}
- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}
- (void)dealloc {
    [_contentView release];
    [_txtAddNumber release];
    [super dealloc];
}
@end
