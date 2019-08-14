//
//  DucBT_ShareViewController.m
//  BigC_VM
//
//  Created by Mac Mini on 9/26/14.
//
//

#import "DucBT_ShareViewController.h"
#import "UIImageView+WebCache.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface DucBT_ShareViewController () <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
{
    
    IBOutlet UITextView *mtvHienThiLoiGioiThieu;
}

@property (retain, nonatomic) NSDictionary *backLinkInfo;
@end

@implementation DucBT_ShareViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addButtonBack];
    [self khoiTaoLoiGioiThieu];
    [self khoiTaoTieuDe];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    if (delegate.refererAppLink) {
    //        self.backLinkInfo = delegate.refererAppLink;
    //        [self _showBackLink];
    //    }
    //    delegate.refererAppLink = nil;
}

#pragma mark - khoi tao

- (void)khoiTaoLoiGioiThieu
{
    [mtvHienThiLoiGioiThieu setText:[@"loi_gioi_thieu" localizableString]];
}

- (void)khoiTaoTieuDe
{
//    [self.navigationItem setTitle:@"Giới thiệu bạn bè"];
    self.title = @"Giới thiệu bạn bè";
}


#pragma mark - handler error
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - su Kien
- (IBAction)suKienBamNutSMS:(UIButton *)sender
{
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:@"Thiết bị của bạn không thể gửi được tin nhắn!" delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSArray *recipients = nil;
    
    //set message text
//    NSString * message = @"Ung dung vi dien tu va rao vat ViMASS. Tai mien phi cho iPhone: \nhttps://itunes.apple.com/vn/app/vimass/id785302070?mt=8.\nCho dien thoai Android: \nhttps://play.google.com/store/apps/details?id=com.vimass.\nCho dien thoai Window Phone: \nhttp://www.windowsphone.com/en-us/store/app/vi-vimass/d232724c-887e-4f03-8403-fb8f76006187.\nXem them tai http://vimass.vn";
    NSString * message = @"Tai ung dung Vi Vimass mien phi cho iPhone: \nhttps://itunes.apple.com/vn/app/vi-vimass/id959341649?mt=8 \nXem them tai https://vimass.vn";
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipients];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [RoundAlert show];
    [self presentViewController:messageController animated:YES completion:^{
        [RoundAlert hide];
    }];
}

- (IBAction)suKienBamNutMail:(UIButton *)sender
{
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:@"Thiết bị của bạn không thể gửi được mail!" delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles:nil];
        [alert show];
        return;
    }
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"Mời sử dụng ứng dụng miễn phí Ví ViMASS"];
    [controller setMessageBody:@"Tải ứng dung Ví Vimass miễn phí cho iPhone: https://itunes.apple.com/vn/app/vi-vimass/id959341649?mt=8 \nXem thêm tại https://vimass.vn" isHTML:NO];
    if (controller)
        [self presentViewController:controller animated:YES completion:^{}];
    [controller release];
}

- (IBAction)suKienBamNutFacebook:(UIButton *)sender
{
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"https://itunes.apple.com/vn/app/vi-vimass/id959341649?mt=8"];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present the share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
    }
    else
    {
        // FALLBACK: publish just a link using the Feed dialog
        // Put together the dialog parameters

        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Ví ViMASS", @"name",
                                       @"Di động hoá tiền và thẻ", @"caption",
                                       @"Ứng dụng tuyệt vời về ví điện tử và thương mại điện tử!", @"description",
                                       @"https://itunes.apple.com/vn/app/vi-vimass/id959341649?mt=8", @"link",
                                       @"http://www.upsieutoc.com/images/2015/12/28/icon_v2_denvivimass.png", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
        
    }
}

//------------------------------------

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (IBAction)suKienBamNutViber:(UIButton *)sender
{
//    NSURL * viberURL = [NSURL URLWithString:[@"viber://send?text=Tải ứng dung Ví Vimass miễn phí cho iPhone: https://itunes.apple.com/vn/app/vi-vimass/id959341649?mt=8 \nXem thêm tại https://vimass.vn" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    if ([[UIApplication sharedApplication] canOpenURL:viberURL])
//    {
//        [[UIApplication sharedApplication] openURL:viberURL];
//    }

}

- (IBAction)suKienBamNutZalo:(UIButton*)sender
{
    [UIAlertView alert:@"Đang phát triển" withTitle:[@"thong_bao" localizableString] block:nil];
}

#pragma mark - MFMessageComposeViewControllerDelegate methods
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:@"Có lỗi trong quá trình gửi tin nhắn!" delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    else if(result == MFMailComposeResultFailed)
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:[@"thong_bao" localizableString] message:@"Có lỗi trong quá trình gửi mail!" delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles:nil];
        [warningAlert show];
    }
    //    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - dealloc
- (void)dealloc {
    [mtvHienThiLoiGioiThieu release];
    [super dealloc];
}
- (void)viewDidUnload {
    [mtvHienThiLoiGioiThieu release];
    mtvHienThiLoiGioiThieu = nil;
    [super viewDidUnload];
}
@end
