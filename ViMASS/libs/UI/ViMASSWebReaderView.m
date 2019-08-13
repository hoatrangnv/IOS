//
//  ViMASSWebReaderView.m
//  test_web_reader
//
//  Created by Ngo Ba Thuong on 8/20/13.
//  Copyright (c) 2013 ViMASS. All rights reserved.
//

#import "ViMASSWebReaderView.h"
#import "AppDelegate.h"
#import "NSString+Extended.h"

@implementation ViMASSWebReaderView
{
    BOOL did_load_parser;
    NSString *url;
    void(^_doneAction)(ViMASSWebReaderView *reader);
    BOOL isHTML;
}
+(id)create
{
    ViMASSWebReaderView *v = (ViMASSWebReaderView *)[[[NSBundle mainBundle] loadNibNamed:@"ViMASSWebReaderView" owner:nil options:nil] objectAtIndex:0];
    return v;
}

+ (ViMASSWebReaderView *)load:(NSString *)url_ callback:(void (^)(ViMASSWebReaderView* reader))callback;
{
    AppDelegate *de = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView * wd = de.window;
    CGRect avai_frame = wd.bounds;
    
    ViMASSWebReaderView *v = (ViMASSWebReaderView *)[[[NSBundle mainBundle] loadNibNamed:@"ViMASSWebReaderView" owner:nil options:nil] objectAtIndex:0];
    v->callback = [callback copy];
    [wd addSubview:v];
    
    v->isHTML = NO;
    
    avai_frame.origin.y = [UIApplication sharedApplication].statusBarHidden == YES ? 0 : 20;
    avai_frame.size.height -= [UIApplication sharedApplication].statusBarHidden == YES ? 0 : 20;
    
    v.frame = CGRectOffset(avai_frame, 0, avai_frame.size.height);
    [UIView animateWithDuration:0.35 animations:^
    {
        v.frame = avai_frame;
    } completion:^(BOOL finished){}];
    
    [v load:url_];
    return v;
}
-(void)load:(NSString *)url_ doneAction:(void (^)(ViMASSWebReaderView *))doneAction
{
    [_doneAction release];
    _doneAction = [doneAction copy];
    [self load:url_];
}
-(void)loadHTML:(NSString *)html
     doneAction:(void (^)(ViMASSWebReaderView *))doneAction
{
    [_doneAction release];
    _doneAction = [doneAction copy];
    [self loadHTML:html];
}
-(void) loadHTML:(NSString *)html
{
    isHTML = YES;
    
    v_web.hidden = YES;
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    v_loading.center = center;
    [v_loading startAnimating];
    v_loading.hidden = NO;
    
    [v_web loadHTMLString:html baseURL:nil];
}

- (void)load:(NSString *)link;
{
    NSLog(@"link = %@",link);
    [v_web loadHTMLString:@"" baseURL:nil];
    did_load_parser = NO;
    v_web.hidden = YES;
    v_bar.hidden = YES;
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    v_loading.center = center;
    [v_loading startAnimating];
    v_loading.hidden = NO;
    
    url = [link copy];
    [v_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:link]]];
}

- (IBAction)did_select_finish
{
    if (_doneAction)
    {
        _doneAction(self);
    }else
    {
        [self close];
    }
}

- (IBAction)did_select_goto_webpage:(UIBarButtonItem *)sender
{
    [self close];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self->url]];
}

- (IBAction)didSelectClose
{
    if (_doneAction)
    {
        _doneAction(self);
    }else
    {
        [self close];
    }
}

- (void)close
{
    [UIView animateWithDuration:0.2 animations:^
     {
         self.frame = CGRectOffset(self.frame,  self.bounds.size.width,0);
     } completion:^(BOOL finished)
     {
         if (callback != nil)
             callback(self);
         
         [self removeFromSuperview];
     }];
}

- (NSString *)get_domain
{
    NSURL *u = [NSURL URLWithString:url];
    return u.host;
}

- (NSString *)read_resource_file:(NSString *)filename
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"ViMASSWebReader_scripts" ofType:nil];
    path = [path stringByAppendingPathComponent:filename];
    
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    return content;
}

- (BOOL)load_parser
{
    NSString *domain = [self get_domain];
    
    NSString *script = [self read_resource_file:[NSString stringWithFormat:@"%@.js", domain]];
    if (script != nil && script.length > 0)
    {
        [v_web stringByEvaluatingJavaScriptFromString:script];
        return YES;
    }

    return NO;
}

- (void)load_displayer
{
    NSString *script = [self read_resource_file:@"vimass_reader_main.js"];
    
    [v_web stringByEvaluatingJavaScriptFromString:script];
}
-(void)load_js_reader
{
    if ([self load_parser] == YES)
    {
        [self load_displayer];
    }else
    {
        [self display_web];
    }
}

- (void)display_web
{
    [v_loading stopAnimating];
    v_loading.hidden = YES;
    if (_showAnimate == NO)
    {
        v_web.hidden = NO;
    }else
    {
        v_web.hidden = NO;
        v_web.alpha = 0.0f;
        [UIView animateWithDuration:0.3 animations:^{
            v_web.alpha = 1.0f;
        }];
    }
}

- (void)init_ViMASSWebReaderView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureDoubleTapAction)];
    
    tap.numberOfTapsRequired = 2;
    tap.delegate = self;
    
    [v_web addGestureRecognizer:tap];
    
    v_web.scalesPageToFit = YES;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self init_ViMASSWebReaderView];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)gestureDoubleTapAction
{
    [self didSelectClose];
}

#pragma mark - Webview delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    if (isHTML)
    {
        [self display_web];
        /*NSString *js = @"var ps = document.getElementsByTagName('p'); for(var i = 0;i < ps.length;i++){var p = ps[i];p.style.fontSize = '30px';} var strongs = document.getElementsByTagName('strong');for(var i =0;i<strongs.length;i++){var p = strongs[i];p.style.fontSize = '30px';}";
        NSString *js = @"alert(document.body.scrollWidth);";
        [v_web stringByEvaluatingJavaScriptFromString:js];
*/
        return;
    }
    if (did_load_parser == NO)
    {
        [self load_js_reader];
        did_load_parser = YES;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    if ([@"vimass" compare:request.URL.scheme] == NSOrderedSame)
    {
        // Execute script success
        [self display_web];
        return NO;
    }
    
    return YES;
}

#pragma mark -
+(NSString *)getFullHTMLArticle:(NSString *)body
                       realLink:(NSString *) realLink;
{
    NSString *real_link = @"";
    if (realLink && [realLink isHTTP])
    {
        real_link = [NSString stringWithFormat:@"<br/><a href=\"%@\" style=\"color:blue;\">%@</a><br/><br/>",realLink,LocalizedString(@"html - origin source")];
    }
    NSString * css = @"<html xmlns=\"http://www.w3.org/1999/xhtml\"><header><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /><link rel=\"stylesheet\" href=\"http://cdn.readability.com/a67566/css/print.css\" media=\"print\"><style type='text/css'>body{font-family:Arial !important;font-size:56px !important;background-color:#ffffff;}img{width:100%%;}p,strong{padding-left:10px;padding-right:10px;text-align:justify;}h1{text-align:justify;font-weight:bolder;}table,table tr{width:100%%;}</style></header><body>%@<script type='text/javascript'>var wd_width = document.body.clientWidth;var imgs = document.getElementsByTagName('img');for(var i = 0;i< imgs.length;i++){var img = imgs[i];img.removeAttribute('height');img.style.paddingRight = '10px';img.style.width = (wd_width - 20) + 'px';var sup_img = img.parentNode;if(sup_img.nodeName == 'td'){sup_img.style.width = '100%%';}}</script>%@</body></html>";
    NSString * html = [NSString stringWithFormat:css,body,real_link];
    return html;
}

#pragma mark - View hierarchy

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"~~~~~~ DEALLOCATED %@", NSStringFromClass([self class]));
    [_doneAction release];
    [url release];
    [v_web release];
    [v_bar release];
    [v_loading release];
    [callback release];
    [bt_close release];
    [super dealloc];
}
@end