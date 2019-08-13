//
//  RegisterTokenViewController.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/20/12.
//
//

#import "RegisterTokenViewController.h"
#import "AccountService.h"
#import "LocalizationSystem.h"
#import "Alert+Block.h"
#import "Common.h"

@interface RegisterTokenViewController ()

@end

@implementation RegisterTokenViewController

+ (RegisterTokenViewController *)create
{
    return [[[RegisterTokenViewController alloc] initWithNibName:@"RegisterTokenViewController" bundle:nil] autorelease];
}
+(void)create:(void (^)(BaseScreen *))oncreate privateInfo:(NSDictionary*) privateInfo;
{
    RegisterTokenViewController *vc = [[RegisterTokenViewController alloc] initWithNibName:@"RegisterTokenViewController" bundle:nil];
    if (oncreate)
        oncreate([vc autorelease]);
    
}

- (BOOL)validate
{
    BOOL r = YES;
    ExTextField *first = nil;
    r = [txtSerial validate] && r;
    if (r == NO && first == nil)
        first = txtSerial;
    
    r = [txtToken validate] && r;
    if (r == NO && first == nil)
        first = txtToken;
    
    if (first)
    {
        [UIAlertView alert:first.textError withTitle:nil block:^(UIAlertView *alert, int indexClicked) {
            [first becomeFirstResponder];
        }];
    }
    
    return r;
}

- (IBAction)didSelectRegister
{
    if ([self validate] == NO)
    {
        return;
    }
    
    [txtSerial resignFirstResponder];
    [txtToken resignFirstResponder];
    
    NSString * serial = txtSerial.text;
    NSString * htoken  = txtToken.text;
    
    self.isLoading = YES;
    [[AccountService requestWithCallback:^(AccountService *service, NSString *errcode)
    {
        self.isLoading = NO;
        if (errcode)
        {
            NSString *msg = [Common getcErrorDescription:errcode,
                             [serial cStringUsingEncoding:NSUTF8StringEncoding],
                             [current_account cStringUsingEncoding:NSUTF8StringEncoding]];
            
            [UIAlertView alert:msg withTitle:nil block:nil];
            return;
        }
        
        NSString *msg = [Common getcErrorDescription:@"BT001",
                         [serial cStringUsingEncoding:NSUTF8StringEncoding],
                         [current_account cStringUsingEncoding:NSUTF8StringEncoding]];
        
        [UIAlertView alert:msg withTitle:nil block:^(UIAlertView *alert, int indexClicked)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }] registerToken:serial token:htoken];
}

#pragma mark - Views

- (void)viewWillAppear:(BOOL)animated
{
    [self addBackButton:NO];
//    [self addButtonLogOut];
    self.navigationItem.title = LocalizedString(@"regtoken");
    [HistoryManager addHistoryWith:NSStringFromClass([self class])
                             title:@"regtoken"
                               tag:@"register token,dang ki token"
                        checkLogin:YES
                    andPrivateInfo:nil];
    [self localizeViews];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initAutoLocalizeView];
    [self addBackground];
    
    for (ExTextField *tf in textFields)
    {
        [tf iconErrorTapBlock:^{
            [UIAlertView alert:tf.textError withTitle:nil block:^(UIAlertView *alert, int indexClicked) {
                [tf becomeFirstResponder];
            }];
        }];
    }
    
    txtSerial.max_length = 13;
    [txtSerial setTextError:LocalizedString(@"regtoken serial is requried") forType:ExTextFieldTypeEmpty];
    [txtSerial setTextError:LocalizedString(@"regtoken serial is invalid") forType:ExTextFieldTypeToken];
    [txtSerial changePattern:@"^[0-9]{13}$"];
    
    txtToken.max_length = 6;
    [txtToken setTextError:LocalizedString(@"regtoken is requried") forType:ExTextFieldTypeEmpty];
    [txtToken setTextError:LocalizedString(@"regtoken is invalid") forType:ExTextFieldTypeToken];
    
}
- (void)dealloc {
    [txtSerial release];
    [txtToken release];
    [textFields release];
    [super dealloc];
}
- (void)viewDidUnload {
    [txtSerial release];
    txtSerial = nil;
    [txtToken release];
    txtToken = nil;
    [textFields release];
    textFields = nil;
    [super viewDidUnload];
}


@end
