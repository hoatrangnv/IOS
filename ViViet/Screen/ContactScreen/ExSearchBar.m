//
//  ExSearchBar.m
//  ViMASS
//
//  Created by Chung NV on 4/24/13.
//
//

#import "ExSearchBar.h"
#import "Common.h"

@implementation ExSearchBar

-(void)layoutSubviews
{
    return [super layoutSubviews];
    
    UITextField *tf;
    UIButton * btCancel;
    UIImageView *bg = nil;
    
    for (UIView *v in [self subviews])
    {
        if ([v isKindOfClass:[UITextField class]])
        {
            tf = (UITextField *)v;
            tf.background = [Common stretchImage:@"search_bar_tf_bg"];
        }
        if ([v isKindOfClass:[UIButton class]])
        {
            btCancel = (UIButton *)v;
            [btCancel titleLabel].font = [UIFont fontWithName:@"Arial" size:12];
            
            UIColor *color = [UIColor blackColor];
            [btCancel setTitleColor:color forState:UIControlStateNormal];
            [btCancel setTitleColor:color forState:UIControlStateHighlighted];
            [btCancel setBackgroundImage:[Common stretchImage:@"search_bar_cancel_bg"] forState:UIControlStateNormal];
        }
        if (bg == nil && [v isKindOfClass:[UIImageView class]])
        {
            bg = (UIImageView *) v;
            bg.image = [Common stretchImage:@"search_bar_bg"];
        }
    }
//    [self setShowsCancelButton:YES animated:YES];
}

@end
