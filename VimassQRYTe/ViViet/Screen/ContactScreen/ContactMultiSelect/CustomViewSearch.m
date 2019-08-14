//
//  CustomViewSearch.m
//  ViViMASS
//
//  Created by Nguyen Van Hoanh on 11/4/18.
//

#import "CustomViewSearch.h"

@implementation CustomViewSearch

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initXib];
        [self setupLeftTextField];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initXib];
        [self setupLeftTextField];
    }
    return self;
}
- (void)initXib {
    [[NSBundle mainBundle] loadNibNamed:@"CustomViewSearch" owner:self options:nil];
    _contentView.frame = self.bounds;
    [self addSubview:_contentView];
}
- (void)setupLeftTextField {
    UIImageView * iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_search"]];
    iconImageView.frame = CGRectMake(10, 0, 16, 16);
    _txtSearch.leftView = iconImageView;
    _txtSearch.leftViewMode = UITextFieldViewModeAlways;
    [_txtSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)setupRightTextFiled {
    UIButton * buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonClose.frame = CGRectMake(0, 0, 24, 24);
    [buttonClose setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [buttonClose addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];
    _txtSearch.rightView = buttonClose;
    _txtSearch.rightViewMode = UITextFieldViewModeAlways;
}
- (void)dealloc {
    [_contentView release];
    [_btnRefresh release];
    [_txtSearch release];
    [super dealloc];
}
- (IBAction)actionRefresh:(id)sender {
    if (_delegate) {
        [_delegate refresh];
    }
}
-(void)textFieldDidChange:(UITextField*)textField {
    if (_delegate) {
        NSString * strSearch = textField.text;
        if (strSearch.length > 0) {
            [self setupRightTextFiled];
        } else {
            [self onClose];
        }
        [_delegate searchContact:strSearch];
    }

}
-(void)onClose {
    if (_delegate) {
        _txtSearch.text = @"";
        [_delegate searchContact:@""];
        _txtSearch.rightView = nil;
        _txtSearch.rightViewMode = UITextFieldViewModeNever;
    }
}
@end
