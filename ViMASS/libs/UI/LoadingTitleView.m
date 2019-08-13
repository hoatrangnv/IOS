//
//  LoadingTitleView.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 1/12/14.
//
//

#import "LoadingTitleView.h"

@implementation LoadingTitleView
{
    IBOutlet UIActivityIndicatorView *v_loading;
    IBOutlet UILabel *v_title;
    
    NSString *_title, *_loading_title;
    
    BOOL _loading;
}

- (IBAction)did_select_title_view:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectBackButton)])
    {
        [self.delegate didSelectBackButton];
    }
}

- (UILabel *)title_view
{
    return v_title;
}

- (void)start_loading
{
    _loading = YES;
    v_title.text = _loading_title;
    
    v_loading.hidden = NO;
    [v_loading startAnimating];
    [self layout];
}

- (void)stop_loading
{
    _loading = NO;
    v_title.text = _title;
    
    v_loading.hidden = YES;
    [v_loading stopAnimating];
    [self layout];
}


+ (LoadingTitleView *)create;
{
    LoadingTitleView *v = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    [v init_LoadingTitleView];
    return v;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layout];
}

- (void)layout
{
    if (v_loading.hidden == NO)
    {
        const CGFloat margin = 7;
        
        CGSize sz_title = [v_title.text sizeWithFont:v_title.font];
        sz_title = CGSizeMake(roundf(sz_title.width), roundf(sz_title.height));
        
        CGRect r = v_loading.frame;
        r.origin.x = roundf((self.bounds.size.width - sz_title.width - v_loading.bounds.size.width - margin)/2.f);
        v_loading.frame = r;
        
        r = v_title.frame;
        r.origin.x = v_loading.frame.origin.x + v_loading.frame.size.width + margin;
        r.size = sz_title;
        r.origin.y = roundf(self.bounds.size.height/2.f - sz_title.height/2);
        v_title.frame = r;
    }
    else
    {
        v_title.frame = self.bounds;
    }
}

- (void)init_LoadingTitleView
{
    [self stop_loading];
}

- (void)dealloc
{
    NSLog(@"~ DEALLOCATED %@ ~", NSStringFromClass([self class]).uppercaseString);
        self.title = nil;
        self.loading_title = nil;
    if(v_loading)
        [v_loading release];
    if(v_title)
        [v_title release];
    [super dealloc];
}
@synthesize title = _title;
@synthesize loading_title = _loading_title;

@end
