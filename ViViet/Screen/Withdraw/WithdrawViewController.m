//
//  WithdrawViewController.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/3/12.
//
//

#import "WithdrawViewController.h"
#import "Common.h"
#import "AccountService.h"
#import "LocalizationSystem.h"
#import "UILabel+Helpers.h"

@interface WithdrawViewController ()

@end

@implementation WithdrawViewController
{
    int auth_method;
    NSString *balance;
    void(^_oncreate)(WithdrawViewController *controller);
}

+ (void)create:(void(^)(BaseScreen *controller))oncreate
   privateInfo:(NSDictionary*) privateInfo;
{
    WithdrawViewController *vc = [[WithdrawViewController alloc] initWithNibName:@"WithdrawViewController" bundle:nil];
    vc->_oncreate = [oncreate copy];
    [vc request_balance_and_auth_method];
}

- (void)request_balance_and_auth_method
{
    AccountService * get_auth_method_request = nil;
    AccountService * get_balance_request = nil;
    
    get_auth_method_request = [AccountService requestWithCallback:^(AccountService *service, NSString *errcode)
   {
       self.isLoading = NO;
       if (errcode)
       {
           [get_balance_request cancel];
           [self handleError:errcode alertBlock:nil];
//           [self alertErrorCode:errcode callback:nil];
           [self release];
       }
       else
       {
           auth_method = [((NSString *)service.data) intValue];
           [self update_request_state];
       }
   }];
    
    get_balance_request = [AccountService requestWithCallback:^(AccountService *service, NSString *errcode)
       {
           self.isLoading = NO;
           if (errcode)
           {
               [get_auth_method_request cancel];
//               [self alertErrorCode:errcode callback:nil];
               [self handleError:errcode alertBlock:nil];
               [self release];
           }
           else
           {
               balance = [service.data copy];
               [self update_request_state];
           }
       }];
    
    self.isLoading = YES;
    self.isLoading = YES;
    [get_auth_method_request getConfirmMethod];
    [get_balance_request getBalance];
}

- (void)update_request_state
{
    if (auth_method != 0 && balance != nil)
    {
        if (_oncreate)
            _oncreate ([self autorelease]);
    }
}
- (void)success
{
    [UIAlertView alert:@"@wd - completed" withTitle:nil block:^(UIAlertView *alert, int indexClicked)
     {
         [self.navigationController popViewControllerAnimated:YES];
     }];
}

- (void)withdraw
{
    if ([self validate] == NO)
    {
        return;
    }
    
    NSString *amount = [txtAmount getAmount];
    NSString *token = [txtToken.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    self.isLoading = YES;
    [[AccountService requestWithCallback:^(AccountService *service, NSString *errcode)
      {
          self.isLoading = NO;
          if (errcode)
          {
              [self alertErrorCode:errcode callback:nil];
              return;
          }
          
          if ([AccountService requireOTP:auth_method] == NO)
          {
              [self success];
              return;
          }
          
          [self confirm_OTP:^(NSString *errcode)
           {
               if (errcode == nil)
               {
                   [self success];
               }
           }];
          
      }] withdraw:amount token:token];
}

#pragma mark - Util

- (void) setNeedToken:(BOOL)need
{
    CGRect r = viewToken.frame;
    CGRect btnWithdrawFrame = btnWithdraw.frame;
    
    viewToken.hidden = !need;
    if (need == NO)
    {
        btnWithdrawFrame.origin.y -= r.size.height;
        btnWithdraw.frame = btnWithdrawFrame;
    }
}

- (BOOL) validate
{
    BOOL r = YES;
    ExTextField *first = nil;
    
    r = [txtAmount validate] && r;
    if (r == NO && first == nil)
        first = txtAmount;
    
    if (viewToken.hidden == NO)
    {
        r = [txtToken validate] && r;
        if (r == NO && first == nil)
            first = txtToken;
    }
    if (first)
    {
        [UIAlertView alert:first.textError withTitle:nil block:^(UIAlertView *alert, int indexClicked) {
            [first becomeFirstResponder];
        }];
    }
    
    return r;
}

#pragma mark - Events

- (IBAction)didSelectWithdraw:(id)sender
{
    [self withdraw];
}

#pragma mark - View hierarchy

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    self.title = LocalizedString(@"wd - title");
    
    [HistoryManager addHistoryWith:NSStringFromClass([self class])
                             title:@"wd - title"
                               tag:@"rut tien,with draw,withdraw,cash out"
                        checkLogin:YES
                    andPrivateInfo:nil];
    
    [self setNeedToken:[AccountService requireHardToken:auth_method]];
    
    [self localizeViews];
//    [self addButtonLogOut];
    [self addButtonBack];
    
    CGRect r = [lb_amount_title fit_text];
    
    lb_amount.text = [NSString stringWithFormat:@"%@ %@", balance, LocalizedString(@"common - currency unit")];
    CGRect fr = lb_amount.frame;
    fr.origin.x = r.origin.x + r.size.width + 5;
    lb_amount.frame = fr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initAutoLocalizeView];
    [self addBackground];
    [self _setUpTextFields];
}
-(void) _setUpTextFields
{
    txtAmount.max_length = 13;
    [txtAmount setTextError:LocalizedString(@"wd - amount is required") forType:ExTextFieldTypeEmpty];
    [txtAmount setTextError:LocalizedString(@"wd - amount is invalid") forType:ExTextFieldTypeMoney];
    
    [txtAmount addAmountConstraintWithBlock:^BOOL(double amount) {
        return amount > 0;
    } withErrorMessage:LocalizedString(@"wd - amount is invalid")];
    
    [txtAmount  iconErrorTapBlock:^{
        [UIAlertView alert:txtAmount.textError withTitle:nil block:^(UIAlertView *alert, int indexClicked) {
            [txtAmount becomeFirstResponder];
        }];
    }];
    
    txtToken.max_length = 6;
    [txtToken setTextError:LocalizedString(@"wd - token is required") forType:ExTextFieldTypeEmpty];
    [txtToken setTextError:LocalizedString(@"wd - token is invalid") forType:ExTextFieldTypeToken];
    
    [txtToken iconErrorTapBlock:^{
        [UIAlertView alert:txtToken.textError withTitle:nil block:^(UIAlertView *alert, int indexClicked) {
            [txtToken becomeFirstResponder];
        }];
    }];
}

- (void)viewDidUnload
{
    [txtAmount release];
    txtAmount = nil;
    [txtToken release];
    txtToken = nil;
    [btnWithdraw release];
    btnWithdraw = nil;
    [viewToken release];
    viewToken = nil;
    [lb_amount release];
    lb_amount = nil;
    [lb_amount_title release];
    lb_amount_title = nil;
    [super viewDidUnload];
}
- (void)dealloc
{
    [balance release];
    [txtAmount release];
    [txtToken release];
    [btnWithdraw release];
    [viewToken release];
    [lb_amount release];
    [lb_amount_title release];
    [super dealloc];
}
@end
