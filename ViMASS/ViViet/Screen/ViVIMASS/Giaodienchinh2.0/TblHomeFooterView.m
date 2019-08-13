//
//  TblHomeFooterView.m
//  ViViMASS
//
//  Created by Mac Mini on 10/2/18.
//

#import "TblHomeFooterView.h"

@implementation TblHomeFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"TblHomeFooterView"
                                                          owner:self
                                                        options:nil];
        
        UIView* mainView = (UIView*)[nibViews objectAtIndex:0];
        
        [self addSubview:mainView];
    }
    return self;
}
@end
