//
//  UIViewController+Common.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 11/5/12.
//

#import "UIViewController+Common.h"
#import "BPButton.h"
#import "Static.h"
#import "LocalizationSystem.h"
#import "Alert+Block.h"
#import "Common.h"
#import "Cities.h"
#import "ProvinceCoreData.h"
#import "ViToken.h"
#import "VSelectItemController.h"

#pragma mark - ViewToTextInfo

@interface ViewToTextInfo : NSObject
{
    @public
    void *p;
    int type;
    NSString *text;
    NSArray *texts;
}
+ (ViewToTextInfo*)infoWithPointer:(void*)p type:(int)type text:(NSString *)text;
@end

@implementation ViewToTextInfo

+ (ViewToTextInfo*)infoWithPointer:(void*)p type:(int)type text:(NSString *)text
{
    ViewToTextInfo *o = [[ViewToTextInfo new] autorelease];
    o->p = p;
    o->type = type;
    o->text = [text copy];
    return o;
}
- (void)dealloc
{
    [text release];
    [texts release];
    [super dealloc];
}
@end

#pragma mark - UIViewController (Common)

@implementation UIViewController (Common)

- (void)fix_status_bar
{
    if (SYSTEM_VERSION_LESS_THAN(@"7"))
    {
        CGRect r = self.view.bounds;
        r.origin.y = 20;
        r.size.height = UIScreenHeight - 20;
        self.view.bounds = r;
    }
}

- (void)select_police_department:(void (^)(int index, NSString *PD))callback;
{
    callback = [callback copy];
    NSArray *provinces = [ProvinceCoreData allProvinces];
    
    NSMutableArray *strs = [[[NSMutableArray alloc] initWithCapacity:provinces.count + 1] autorelease];
    
    [strs addObject:LocalizedString(@"bo cong an")];
    for (Cities *city in provinces)
    {
        NSString *str = [NSString stringWithFormat:LocalizedString(@"cong an tinh"), [city getName]];
        
        [strs addObject:str];
    }
    
    __block VSelectItemController *sel = [[VSelectItemController alloc] initWithData:strs title:LocalizedString(@"select a province")];
    
    [sel select_in_view:self.view
               callback:^BOOL(VSelectItemController *ctrl, int index, int state)
     {
         if (state == VSelectItemController_StateWillSelect)
             return YES;
         
         NSString *str = nil;
         if (index == 0)
         {
             str = LocalizedString(@"bo cong an");
         }
         else
         {
             index--;
             str = [NSString stringWithFormat:LocalizedString(@"cong an tinh"), [((Cities *)[provinces objectAtIndex:index]) getName]];
         }
         callback (index, str);
         [callback release];
         [sel release];
         return YES;
     }];
}

- (BOOL)can_use_token
{
    if (token_type <= 0)
    {
        [self alert:[@"ban chua dang ky loai token nao" localizableString] withTitle:nil block:nil];
        return NO;
    }
    
    if (token_type == TOKEN_TYPE_SOFT && [ViToken canGenerateOTP:current_account] == NO)
    {
        [self alert:[@"chua dang ky vitoken tren thiet bi" localizableString] withTitle:nil block:nil];
        return NO;
    }
    
    return YES;
}
- (BOOL)can_use_soft;
{
    if ([ViToken available] == NO)
    {
        [self alert:[@"chua dang ky softoken" localizableString] withTitle:nil block:nil];
        return NO;
    }
    
    return YES;
}
#pragma mark - Auto localize view

- (BOOL)isAutoLocalizeViewText:(NSString *)str
{
    return (str.length > 1 && [str rangeOfString:@"@"].location == 0);
}
- (NSString *)getLocalizeViewText:(NSString *)str
{
    return [str substringFromIndex:1];
}

- (void)localizeViews
{
    for (int i = 0; i < self.viewToText.count; i++)
    {
        ViewToTextInfo *inf = [self.viewToText objectAtIndex:i];
        @try
        {
            switch (inf->type)
            {
                case 0:
                    ((UILabel *)inf->p).text = LocalizedString(inf->text);
                    break;
                case 1:
                    [((UIButton *)inf->p) setTitle:LocalizedString(inf->text) forState:UIControlStateNormal];
                    break;
                case 2:
                    ((UITextField *)inf->p).placeholder = LocalizedString(inf->text);
                    break;
                case 3:
                    for (int i = 0; i < ((UISegmentedControl *)inf->p).numberOfSegments; i++)
                    {
                        if (i < inf->texts.count)
                        {
                            NSString *str = [inf->texts objectAtIndex:i];
                            if (str != nil && str.length > 0)
                            {
                                [((UISegmentedControl *)inf->p) setTitle:LocalizedString(str) forSegmentAtIndex:i];
                            }
                        }
                    }
                    break;
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"auto localized error");
            [self.viewToText removeObject:inf];
            i--;
        }
    }
}
- (void)initAutoLocalizeView
{
    self.viewToText = [[[NSMutableArray alloc] init] autorelease];
    [self localizeView:self.view];
}

- (void)localizeView:(UIView *)parentView
{

    for (UIView *v in parentView.subviews)
    {
        if ([v isKindOfClass:[UILabel class]])
        {
            NSString *txt = ((UILabel *)v).text;
            if (txt.length > 1 && [txt rangeOfString:@"@"].location == 0)
            {
                txt = [txt substringFromIndex:1];
                [self.viewToText addObject:[ViewToTextInfo infoWithPointer:(void *)v type:0 text:txt]];
            }
        }
        else if ([v isKindOfClass:[UIButton class]])
        {
            NSString *txt = [((UIButton *)v) titleForState:UIControlStateNormal];
            if (txt.length > 1 && [txt rangeOfString:@"@"].location == 0)
            {
                txt = [txt substringFromIndex:1];
                [self.viewToText addObject:[ViewToTextInfo infoWithPointer:(void *)v type:1 text:txt]];
            }
        }
        else if ([v isKindOfClass:[UITextField class]])
        {
            NSString *txt = ((UITextField *)v).placeholder;
            if (txt.length > 1 && [txt rangeOfString:@"@"].location == 0)
            {
                txt = [txt substringFromIndex:1];
                [self.viewToText addObject:[ViewToTextInfo infoWithPointer:(void *)v type:2 text:txt]];
            }
        }
        else if ([v isKindOfClass:[UISegmentedControl class]])
        {
            UISegmentedControl *seg = (UISegmentedControl *)v;
            NSMutableArray *texts = [[NSMutableArray alloc] initWithCapacity:1];
            BOOL shouldAdd = NO;
            for (int i = 0; i < seg.numberOfSegments; i++)
            {
                NSString *txt = [seg titleForSegmentAtIndex:i];
                if ([self isAutoLocalizeViewText:txt])
                {
                    txt = [self getLocalizeViewText:txt];
                    shouldAdd = YES;
                }
                else
                {
                    txt = @"";
                }
                [texts addObject:txt];
            }
            if (shouldAdd == NO)
            {
                [texts release];
            }
            else
            {
                ViewToTextInfo *inf = [ViewToTextInfo infoWithPointer:(void *)v type:3 text:nil];
                inf->texts = texts;
                [self.viewToText addObject:inf];
            }
        }
        else
        {
            [self localizeView:v];
        }
    }
}

- (void)addBackground
{
    return;
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *bg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_grad_bg"]] autorelease];
    bg.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
}

- (void)alertErrorCode:(NSString *)errorCode callback:(void (^)(void)) callback;
{
    if (callback != nil)
        callback = [callback copy];
    
    NSString * titleMess = AMLocalizedString(@"Notification", @"Notification");
    NSString * titleButton = AMLocalizedString(@"OK", @"OK");
    
    NSString * msg = [Common getErrorDescription:errorCode];
    
    UIAlertView *al = [[[UIAlertView alloc] initWithTitle:titleMess
                                                  message:msg
                                                 delegate:nil
                                        cancelButtonTitle:titleButton
                                        otherButtonTitles:nil, nil] autorelease];

    [al showWithBlock:^(UIAlertView *alert, int indexClicked)
    {
        if (callback)
        {
            callback();
            [callback release];
        }
    }];
}

- (UIAlertView *)alert:(NSString *)text withTitle:(NSString *)title block:(AlertBlock) _block;
{
    return [UIViewController alert:text withTitle:title block:_block];
}

- (UIAlertView *)confirm:(NSString *)text title:(NSString *)title block:(AlertBlock) _block;
{
    return [UIViewController confirm:text title:title block:_block];
}

+ (UIAlertView *)alert:(NSString *)text withTitle:(NSString *)title block:(AlertBlock) _block
{
    if (title == nil)
        title = LocalizedString(@"Notification");
    
    if (text.length > 0 && [[text substringToIndex:1] compare:@"@"] == NSOrderedSame)
        text = LocalizedString([text substringFromIndex:1]);
    
    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:title
                                                      message:text
                                                     delegate:nil
                                            cancelButtonTitle:AMLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil, nil] autorelease];
    [alert showWithBlock:_block];
    return alert;
}

+ (UIAlertView *)confirm:(NSString *)text title:(NSString *)title block:(AlertBlock)_block
{
    if (title == nil)
        title = LocalizedString(@"Notification");
    
    if (text.length > 0 && [[text substringToIndex:1] compare:@"@"] == NSOrderedSame)
        text = LocalizedString([text substringFromIndex:1]);
    
    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:title
                                                      message:text
                                                     delegate:nil
                                            cancelButtonTitle:LocalizedString(@"Cancel")
                                            otherButtonTitles:LocalizedString(@"OK"), nil] autorelease];

    [alert showWithBlock:_block];
    return alert;
}


- (void)addNavigationItemWithTitle:(NSString *)title andAction:(SEL)selector atLeftSide:(BOOL)left
{
    BPButton * button = [[BPButton new] autorelease];
    [button setImage:@"button-nav-bg"];
    button.frame = CGRectMake(0, 0, 0, 33);
    button.margin = CGMarginMake(0, 8, 0, 8);
    button.autoResizeWidth = YES;
    
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    button.titleLabel.numberOfLines = 1;
    button.titleLabel.minimumScaleFactor = 7.0f;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * buttonItem = [[[UIBarButtonItem alloc]initWithCustomView:button] autorelease];
    if (left)
        self.navigationItem.leftBarButtonItem = buttonItem;
    else
        self.navigationItem.rightBarButtonItem = buttonItem;
}

- (UIBarButtonItem *)negative_baritem_at_side:(BOOL)left;
{
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7"))
        negativeSeperator.width = -5;
    else
        negativeSeperator.width = -6;
    
    return negativeSeperator;
}

- (void)addBackButton: (BOOL) force
{
    if (force == NO)
    {
        if (self.presentingViewController != nil)
            return;
        if (self.navigationController == nil)
            return;
        if (self.navigationController.viewControllers == nil)
            return;
        UIViewController *ctrl = [self.navigationController.viewControllers objectAtIndex:0];
        if (ctrl == self)
            return;
    }
    /*
     * Chung NV Edit :@do - add button with image back-button-bg
     */
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 35, 44);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(didSelectBackButton) forControlEvents:UIControlEventTouchUpInside];

//    [button setImage:[UIImage imageNamed:@"login-btn-back-white.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    UIBarButtonItem *leftItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    leftItem.width = 35;
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7"))
        negativeSeperator.width = -5;
    else
        negativeSeperator.width = -16;

    self.navigationItem.leftBarButtonItems = @[negativeSeperator, leftItem];
    [self add_transparent_baritem:YES];
    [self.navigationItem setHidesBackButton:YES];
    
    return;
}
-(void) didSelectBackButton
{
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void) customLogoutButton
{
    NSString * titleButton = AMLocalizedString(@"Logout", @"Logout");
    UIFont *font = [UIFont boldSystemFontOfSize:14];
    int width = [titleButton sizeWithFont:font].width + 10;
    BPButton * button = [[BPButton alloc] initWithFrame:CGRectMake(0, 0, width, 33)];
    
    [button setTag:101];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, button.frame.size.width, button.frame.size.height)];
    lb.font = font;
    lb.textColor = [UIColor whiteColor];
    lb.backgroundColor = [UIColor clearColor];
    lb.text = AMLocalizedString(@"Logout", @"Logout");
    [button addSubview:lb];
    [lb release];
    [button addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    [button release];
    [buttonItem release];
    
}

-(void) addHiddenButton:(BOOL) left
{
    UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)] autorelease];
    UIBarButtonItem *btn = [[[UIBarButtonItem alloc] initWithCustomView:v] autorelease];
    if (left)
        self.navigationItem.leftBarButtonItem = btn;
    else
        self.navigationItem.rightBarButtonItem = btn;
}

- (BOOL)validateNotificationPhones:(NSString **)phoneList
{
    NSString *phones = *phoneList;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[phones componentsSeparatedByString:@","]];
    for (int i = 0; i < arr.count; i++)
    {
        NSString *phone = [arr objectAtIndex:i];
        phone = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (phone == nil || phone.length == 0)
        {
            [arr removeObjectAtIndex:i];
            i--;
        }
    }
    *phoneList = [arr componentsJoinedByString:@","];
    return arr.count <= 10;
}

@dynamic viewToText;

@end
