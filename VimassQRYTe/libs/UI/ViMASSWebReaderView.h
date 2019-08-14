//
//  ViMASSWebReaderView.h
//  test_web_reader
//
//  Created by Ngo Ba Thuong on 8/20/13.
//  Copyright (c) 2013 ViMASS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPButton.h"


@interface ViMASSWebReaderView : UIView <UIWebViewDelegate, UIGestureRecognizerDelegate>
{
    IBOutlet UIActivityIndicatorView *v_loading;
    IBOutlet UINavigationBar *v_bar;
    @public
    IBOutlet UIWebView *v_web;
    void (^callback)(ViMASSWebReaderView* reader);
    IBOutlet BPButton *bt_close;
}
+(id) create;
+ (ViMASSWebReaderView *)load:(NSString *)url callback:(void (^)(ViMASSWebReaderView* reader))callback;

@property (nonatomic, assign) BOOL showAnimate;
- (void)load:(NSString *)url;
- (void)load:(NSString *)url
  doneAction:(void(^)(ViMASSWebReaderView *)) doneAction;

-(void) loadHTML:(NSString *)url;
- (void)loadHTML:(NSString *)url
      doneAction:(void(^)(ViMASSWebReaderView *)) doneAction;

- (IBAction)did_select_finish;

- (IBAction)did_select_goto_webpage:(UIBarButtonItem *)sender;
- (IBAction)didSelectClose;

+(NSString *)getFullHTMLArticle:(NSString *)body
                       realLink:(NSString *) realLink;


@end
