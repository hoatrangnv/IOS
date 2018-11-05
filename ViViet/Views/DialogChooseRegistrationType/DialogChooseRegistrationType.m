//
//  DialogChooseRegistrationType.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 8/6/13.
//
//

#import "DialogChooseRegistrationType.h"
#import "UIView+EntranceElastic.h"
#import "UIView+Localization.h"

@implementation DialogChooseRegistrationType
{
    UIButton *bg;
    void (^callback)(int selected_type);
    int selected_type;
}

+(DialogChooseRegistrationType *)showin:(UIView *)showinview action:(void (^)(int))callback;
{
    NSArray *a = [[NSBundle mainBundle] loadNibNamed:@"DialogChooseRegistrationType" owner:nil options:nil];
    DialogChooseRegistrationType *view = [a objectAtIndex:0];
    view->callback = [callback copy];
    [view initAutoLocalizeView];
    [view localizeViews];
    [view showin:showinview];
    
    return view;
}

- (void)touch_background
{
    [self Cancel];
}

- (void)showin:(UIView *)showinview
{
    UIWindow* wd = showinview.window;
    
    bg = [UIButton buttonWithType:UIButtonTypeCustom];
    bg.frame = wd.bounds;
    
    [bg addTarget:self action:@selector(touch_background) forControlEvents:UIControlEventTouchUpInside];
    
    [wd addSubview:bg];
    
    self.frame = CGRectOffset(self.frame, 0, 60);
    
    [wd addSubview:self];
    
    [self elasticGrowingInDuration:0.35];
}

- (void)clean
{
    if (bg != nil)
    {
        [bg removeFromSuperview];
        bg = nil;
    }
    
}

- (IBAction)OK
{
    callback(selected_type);
    [callback release];
    callback = nil;
    
    [self clean];
    [self removeFromSuperview];
}

- (IBAction)Cancel
{
    callback(-1);
    [callback release];
    callback = nil;
    
    [self clean];
    [self removeFromSuperview];
}
- (IBAction)did_select_wallet:(id)sender;
{
    UIButton *btn = sender;
    selected_type = (int)btn.tag;
    
    for (UIButton *b in btns)
    {
        b.selected = NO;
    }
    
    btn.selected = YES;
    
    CGRect r = v_checkmark.frame;
    r.origin.y = btn.frame.origin.y;
    v_checkmark.frame = r;
}

- (void)dealloc
{
    NSLog(@"~ DEALLOCED ~ DialogChooseRegistrationType");
    self.viewToText = nil;
    [callback release];
    [btns release];
    [v_checkmark release];
    [super dealloc];
}

@synthesize viewToText;

@end
