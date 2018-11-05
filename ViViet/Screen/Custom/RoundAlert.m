//
//  RoundAlert.m
//
//  Created by Ngo Ba Thuong on 7/2/12.
//  Copyright (c) 2012 Kamikaze. All rights reserved.
//

#import "RoundAlert.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#define CORNER_RAD 10

static UIWindow *window = nil;

@implementation RoundAlert
{
    UIView *_iconView, *backgroundView;
    UILabel *lbMessage;
    UIButton *btnCancel;
    
    CGFloat _opacity;
    UIColor *_fillColor;
    
    NSString *_cancelText;
    
    // Delegate
    id _target;
    SEL method;
}

#pragma mark - Properties
-(void)setMessage:(NSString *)msg
{
    if (_message != msg)
    {
        [_message release];
        _message = [msg copy];
        lbMessage.text = _message;
    }
}
-(void)setIconView:(UIView *)iconView
{
    if (_iconView != iconView)
    {
        [_iconView removeFromSuperview];
        [_iconView release];
        _iconView = [iconView retain];
        [self addSubview:_iconView];
    }
}
-(NSString *)cancelText
{
    return [btnCancel titleForState:UIControlStateNormal];
}
-(void)setCancelText:(NSString *)text
{
    if (btnCancel == nil)
    {
        btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
        btnCancel.frame = CGRectMake(0, self.bounds.size.height - 30,  100, 30);
        [self addSubview:btnCancel];
    }
    
    [btnCancel setTitle:text forState:UIControlStateNormal];
    [self update];
}
# pragma mark - Creating views

-(void)constructor
{
    self.backgroundColor = nil;
    self.opaque = NO;
    
    // Default values
    _opacity = 0.7;
    _fillColor = [[[UIColor blackColor] colorWithAlphaComponent:_opacity] retain];

    
    UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    indicator.hidesWhenStopped = NO;
    [indicator startAnimating];
    [self addSubview:indicator];
    self.iconView = indicator;

    lbMessage = [[[UILabel alloc] initWithFrame: CGRectMake(0, indicator.frame.origin.y + indicator.frame.size.height, self.frame.size.width, 30)] autorelease];
    lbMessage.textColor = [UIColor whiteColor];
    lbMessage.font = [UIFont boldSystemFontOfSize:15];    
    lbMessage.text = @"Doing...";
    lbMessage.opaque = NO;
    lbMessage.textAlignment = NSTextAlignmentCenter;
    lbMessage.backgroundColor = nil;
    lbMessage.contentScaleFactor = 1;
//    lbMessage.minimumFontSize = 1;
    lbMessage.adjustsFontSizeToFitWidth = YES;
    [self addSubview:lbMessage];
    [self bringSubviewToFront:lbMessage];

    [self update];
}
/**
 *
 *   If you set a delegate for cancel action, you have to dimiss the dialog by your self.
 *
 **/
-(void)onCancel:(id)sender;
{
    if (_target != nil && method != nil)
    {
        [_target performSelector:method];
    }
    else
    {
        [self hide];
    }
}

-(void)notifing:(SEL)sel ofTarget:(id)delegate
{
    self.target = delegate;
    method = sel;
}
-(CGSize)sizeThatFits:(CGSize)size
{
    CGFloat h = 0;
    h = CORNER_RAD * 2 + _iconView.frame.size.height + lbMessage.frame.size.height + 10;
    if (btnCancel && btnCancel.hidden == NO)
    {
        h += btnCancel.frame.size.height;
    }
    return CGSizeMake(size.width, h);
}
-(void)layoutSubviews
{
    CGRect lbFrame = CGRectMake(floorf (self.bounds.size.width/2 - (self.bounds.size.width - 2 * CORNER_RAD)/2), 
                                0, 
                                self.bounds.size.width - 2 * CORNER_RAD, 
                                20);

    _iconView.frame = CGRectMake(
                                 floorf (self.bounds.size.width/2 - _iconView.frame.size.width/2),
                                 CORNER_RAD,
                                 _iconView.frame.size.width,
                                 _iconView.frame.size.height);
    
    lbFrame.origin.y = _iconView.frame.origin.y + _iconView.frame.size.height;
    lbFrame.size.height = self.bounds.size.height - CORNER_RAD - lbFrame.origin.y;
    
    if (btnCancel && btnCancel.hidden == NO)
    {
        CGFloat x = floorf(CORNER_RAD * (0.618));
        btnCancel.frame = CGRectMake(
                                     x, 
                                     self.bounds.size.height - CORNER_RAD - btnCancel.frame.size.height,
                                     self.bounds.size.width - 2*x,
                                     btnCancel.frame.size.height);
        lbFrame.size.height -= btnCancel.frame.size.height;
    }
    
    lbMessage.frame = lbFrame;
}
-(void)update
{
    [self setNeedsLayout];
}

#pragma mark - + SHOW
#define LOADING_VIEW_TAG 188974
+(void)show
{
    NSLog(@"%s - ===========> START", __FUNCTION__);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        return;
    }
    if (window == nil)
    {
        window = (UIWindow *)[[UIApplication sharedApplication].windows lastObject];
    }
    if (window == nil) {
        NSLog(@"%s - window == nil", __FUNCTION__);
    }
    RoundAlert *loading = (RoundAlert *)[window viewWithTag:LOADING_VIEW_TAG];
    if (loading == nil)
    {
        NSLog(@"%s - loading == nil", __FUNCTION__);
        loading = [[RoundAlert alloc] initWithFrame:CGRectMake(0 , 0, 230, 100)];
        loading.tag = LOADING_VIEW_TAG;
        [window addSubview:loading];
        [loading release];
    }
    [loading setMessage:LocalizedString(@"Please wait...!")];
    [loading show];
}

-(void)show
{
    if (backgroundView != nil)
        return;
    
    if (self.superview == nil)
    {
        [window addSubview:self];
    }
    
    CGRect rect = self.superview.bounds;
    backgroundView = [[UIView alloc] initWithFrame: rect];
    if (backgroundView == nil)
        return;
    backgroundView.backgroundColor = nil;
    backgroundView.opaque = NO;
    [self.superview addSubview:backgroundView];
    [self.superview bringSubviewToFront:backgroundView];
    [self.superview bringSubviewToFront:self];
    
    //set frame && center
    self.center = self.superview.center;
    CGRect rStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect sRect = self.frame;
    sRect.origin.y -= rStatus.size.height/2;
    self.frame = sRect;
    
//    rect = CGRectInset(self.superview.bounds, (self.superview.bounds.size.width - self.bounds.size.width)/2, (self.superview.bounds.size.height - self.bounds.size.height)/2);
//    self.frame = rect;
    
    [self.superview bringSubviewToFront:self];
//    NSLog(@"Round Alert : %@",NSStringFromCGRect(self.frame));
    self.hidden = NO;
}

+(void)hide
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")){
        return;
    }
    if (!window || window.subviews.count == 0) {
        return;
    }
    for (UIView *viewTemp in window.subviews) {
        if ([viewTemp isKindOfClass:[RoundAlert class]]) {
            RoundAlert *loading = (RoundAlert *)viewTemp;
            [loading hide];
//            RoundAlert *loading = (RoundAlert *)[window viewWithTag:LOADING_VIEW_TAG];
//            if (loading == nil || [loading isKindOfClass:[RoundAlert class] == NO])
//            {
//                return;
//            }
//
//            [loading hide];
        }

    }

}

-(void)hide
{
    if (self.hidden == YES)
    {
        return;
    }
    self.hidden = YES;
    
    [backgroundView removeFromSuperview];
    [backgroundView release];
    backgroundView = nil;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0);
    CGContextSetFillColorWithColor(context, _fillColor.CGColor);
    CGRect rrect = self.bounds;
    
   
    CGFloat radius = CORNER_RAD;
    
    
    CGFloat minx = CGRectGetMinX(rrect);
    CGFloat midx = CGRectGetMidX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect);
    CGFloat midy = CGRectGetMidY(rrect);
    CGFloat maxy = CGRectGetMaxY(rrect);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self constructor];
    }
    return self;
}
-(void)dealloc
{
    self.message = nil;
    self.fillColor = nil;
    self.iconView = nil;
    self.target = nil;
    [super dealloc];
}

@synthesize message = _message;
@synthesize fillColor = _fillColor;
@synthesize opacity = _opacity;
@synthesize iconView = _iconView;
@synthesize target = _target;
@end
