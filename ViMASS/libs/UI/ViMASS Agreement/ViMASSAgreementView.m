//
//  ViMASSAgreementView.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 10/15/13.
//
//

#import "ViMASSAgreementView.h"

@implementation ViMASSAgreementView

- (BOOL)agree
{
    return v_agree.selected;
}

- (void)setAgreement:(NSString *)str
{
    if (agreement != str)
    {
        [agreement release];
        agreement = [str copy];
    }
    
    [v_agreement loadHTMLString:LocalizedString(str) baseURL:nil];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    if (url != nil && [url rangeOfString:@"http"].location == 0)
    {
        [self performSelector:@selector(show_agreement) withObject:nil afterDelay:0.5];
        return NO;
    }
    return YES;
}

- (void)show_agreement
{
    return;
    [self.controller alert:@"agreement" withTitle:nil block:nil];
}

- (void)init_ViMASSAgreementView
{
    v_agreement.delegate = self;
    [self disableScrollWebView:v_agreement];
}

-(void) disableScrollWebView:(UIWebView *) _web
{
    _web.backgroundColor = [UIColor clearColor];
    _web.opaque = NO;
    
    for (UIView* subView in [_web subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scr = (UIScrollView*)subView;
            
            scr.scrollEnabled = NO;
            scr.showsHorizontalScrollIndicator = NO;
            scr.backgroundColor = [UIColor clearColor];
            break;
        }
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleBottomMargin;
        
        NSArray *obj = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
        UIView *v = [obj objectAtIndex:0];
        v.frame = self.bounds;
        [self addSubview:v];
        
        [self init_ViMASSAgreementView];
    }
    
    return self;
}

@synthesize agreement = agreement;

- (void)dealloc {
    [v_agree release];
    [v_agreement release];
    [super dealloc];
}
@end
