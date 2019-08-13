//
//  ExWebviewArticle.m
//  ViMASS
//
//  Created by Chung NV on 8/20/13.
//
//

#import "ExWebviewArticle.h"

@implementation ExWebviewArticle

-(void)setArticleURL:(NSString *)articleURL
{
    if (articleURL != _articleURL)
    {
        [_articleURL release];
        _articleURL = [articleURL copy];
        NSString *url = [NSString stringWithFormat:@"http://www.readability.com/m?url=%@",_articleURL];
        NSURLRequest *req = [[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
        [self loadRequest:req];
        self.hidden = YES;
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"here %s",__FUNCTION__);
    [self stringByEvaluatingJavaScriptFromString:@"var content = document.getElementById('rdb-application');document.getElementsByTagName('body')[0].innerHTML = content.innerHTML;"];
    self.hidden = NO;
}

-(void) _init
{
    self.delegate = self;
   
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self _init];
    }
    return self;
}

@end
