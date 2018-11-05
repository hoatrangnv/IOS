//
//  OverViewAlert.m
//  ViMASS
//
//  Created by Chung NV on 7/27/13.
//
//

#import "OverViewAlert.h"
#define kOVER_VIEW_ALERT_TAG 1121
#define kOVER_VIEW_ALERT__BG_TAG 1211

@implementation OverViewAlert
{
    UILabel * lblMessage;
    UIButton * btAction;
    void(^_action)();
}
+(void) showWithMessage:(NSString *) message
             actionText:(NSString *) actionText
                 action:(void(^)()) action
{
    UIWindow * window = (UIWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
    OverViewAlert *overView = (OverViewAlert *)[window viewWithTag:kOVER_VIEW_ALERT_TAG];
    if (overView == nil || [overView isKindOfClass:[OverViewAlert class]] == NO)
    {
        overView = [[OverViewAlert alloc] initWithFrame:CGRectMake(0 , 0, 276, 132)];
        overView.tag = kOVER_VIEW_ALERT_TAG;
        overView.hidden = YES;
        overView.center = window.center;
        
        [window addSubview:overView];
        [overView release];
    }
    [overView showWithMessage:message actionText:actionText action:action];
}

-(void) showWithMessage:(NSString *) message
             actionText:(NSString *) actionText
                 action:(void(^)()) action
{
    if (self.hidden == NO)
        return;
    [_action release];
    _action = [action copy];
    lblMessage.text = message;
    [btAction setTitle:actionText forState:UIControlStateNormal];
    self.alpha = 0.0;
    [self add_button_background];
    [self.superview bringSubviewToFront:self];
    __block OverViewAlert *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.hidden = NO;
        weakSelf.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
-(void) hide
{
    if (self.hidden)
        return;
    
    __block OverViewAlert *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0.0;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
        [weakSelf remove_button_background];
    }];
}

#pragma mark - ACTION(s)
-(void)didClickedAction
{
    if (_action)
    {
        _action();
    }
    [self hide];
}

-(void)didClickedBackground:(UIButton *)bt
{
    [self hide];
}

-(void) add_button_background
{
    UIWindow * window = (UIWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
    UIButton *overView_bg = (UIButton *)[window viewWithTag:kOVER_VIEW_ALERT__BG_TAG];
    if (overView_bg == nil || [overView_bg isKindOfClass:[UIButton class]] == NO)
    {
        CGRect r = window.frame;
        r.origin = CGPointZero;
        
        overView_bg = [[UIButton alloc] initWithFrame:r];
        overView_bg.backgroundColor = [UIColor clearColor];
        overView_bg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [overView_bg addTarget:self action:@selector(didClickedBackground:) forControlEvents:UIControlEventTouchUpInside];
        overView_bg.tag = kOVER_VIEW_ALERT__BG_TAG;
        [window addSubview:overView_bg];
        [overView_bg release];
    }
}
-(void) remove_button_background
{
    UIWindow * window = (UIWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
    UIButton *overView_bg = (UIButton *)[window viewWithTag:kOVER_VIEW_ALERT__BG_TAG];
    if (overView_bg != nil && [overView_bg isKindOfClass:[UIButton class]])
    {
        [overView_bg removeFromSuperview];
    }
}
#pragma mark - init
-(void)layoutSubviews
{
    [super layoutSubviews];
    
}
-(void) _init
{
    CGRect r = self.frame;
    r.origin = CGPointZero;
    UIImageView *bg_imgV = [[UIImageView alloc] initWithFrame:r];
    bg_imgV.image = [UIImage imageNamed:@"over_view_alert_bg"];
    bg_imgV.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:bg_imgV];
    [bg_imgV release];
    
    lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 260, 68)];
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.textColor = [UIColor whiteColor];
    lblMessage.font = [UIFont boldSystemFontOfSize:18];
    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.numberOfLines = 0;
    lblMessage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [self addSubview:lblMessage];
    
    btAction = [[UIButton alloc] initWithFrame:CGRectMake(10, 82, 256, 42)];
    btAction.backgroundColor = [UIColor clearColor];
    [btAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btAction.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    btAction.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [self addSubview:btAction];
    
    [btAction addTarget:self action:@selector(didClickedAction) forControlEvents:UIControlEventTouchUpInside];
}
-(id)init
{
    if (self = [super init])
    {
        [self _init];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self _init];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self _init];
    }
    return self;
}

-(void)dealloc
{
    [_action release];
    [lblMessage release];
    [btAction release];
    [super dealloc];
}

@end
