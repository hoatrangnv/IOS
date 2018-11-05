//
//  UnregisterToken.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 4/10/13.
//
//

#import "UnregisterTokenViewController.h"
#import "DDAlertPrompt.h"
#import "AccountService.h"
#import "Common.h"
#import "Alert+Block.h"

@interface UnregisterTokenViewController ()

@end

@implementation UnregisterTokenViewController

+(void)create:(void (^)(BaseScreen *))oncreate privateInfo:(NSDictionary *)privateInfo
{
    UnregisterTokenViewController *vc = [UnregisterTokenViewController new];
    [vc confirm_action];
}
- (void)confirm_action
{
    [self confirm:@"@unregister token confirm" title:nil block:^(UIAlertView *alert, int indexClicked)
    {
        if (indexClicked != INDEX_OF_OK_BUTTON)
            return;
        
        [self unregister_token];
    }];
}
- (void)unregister_token
{
#if 1
    [[AccountService requestWithCallback:^(AccountService *service, NSString *errcode)
      {
          if (errcode != nil)
          {
              [self alertErrorCode:errcode callback:^
               {
                   if ([@"BT130104" compare:errcode] == NSOrderedSame)
                       return;
                   
                   [self unregister_token];
               }];
              return;
          }
          
          [self alertErrorCode:@"@unregister completed" callback:nil];
      }] unregisterToken];
#else
    
    [DDAlertPrompt prompt:LocalizedString(@"enter 6 token number") secured:NO callback:^(DDAlertPrompt *alert, int selectedBtn)
     {
         if (selectedBtn != INDEX_OF_OK_BUTTON)
         {
             [self release];
             return;
         }
         
         NSString *htoken = alert.plainTextField.text;
         if ([Common isToken:htoken] == NO)
         {
             NSString *msg = htoken.length == 0 ? @"@regtoken - token is requried" : @"@regtoken - token is invalid";
             [UIAlertView alert:msg withTitle:nil block:^(UIAlertView *alert, int indexClicked)
             {
                 [self unregister_token];
             }];
             return;
         }
         
         [[AccountService requestWithCallback:^(AccountService *service, NSString *errcode)
           {
               if (errcode != nil)
               {
                   [self alertErrorCode:errcode callback:^
                   {
                       if ([@"BT130104" compare:errcode] == NSOrderedSame)
                           return;
                       
                       [self unregister_token];
                   }];
                   return;
               }
               [self alertErrorCode:@"@unregister completed" callback:nil];
               ]
           }] unregisterToken];
     }];
#endif
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
