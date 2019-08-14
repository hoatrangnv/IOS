//
//  UIAlertView+Block.m
//  ViMASS
//
//  Created by Chung NV on 3/27/13.
//
//

#import "Alert+Block.h"
#import <objc/runtime.h>


@implementation UIAlertView(Block)

+ (void)alert:(NSString *)text withTitle:(NSString *)title block:(AlertBlock)_block
{
    if (title == nil)
        title = LocalizedString(@"Notification");
    
    if (text.length > 0 && [[text substringToIndex:1] compare:@"@"] == NSOrderedSame)
        text = LocalizedString([text substringFromIndex:1]);
    
    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:title
                                                      message:text
                                                     delegate:nil
                                            cancelButtonTitle:LocalizedString(@"OK")
                                            otherButtonTitles:nil, nil] autorelease];
    [alert showWithBlock:_block];
}

+ (void)hienThiThongBaoHaiNut:(NSString*)sCauThongBao
                 kieuHopThoai:(int)nKieu
                     delegate:(id<UIAlertViewDelegate>)delegate
{
    
    NSString *title = [@"thong_bao" localizableString];
    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:title
                                                      message:sCauThongBao
                                                     delegate:delegate
                                            cancelButtonTitle:[@"button_huy" localizableString]
                                            otherButtonTitles:[@"button_dong_y" localizableString], nil] autorelease];
    alert.tag = nKieu;
    [alert show];
}

+ (void)hienThiThongBaoCoTextfield:(NSString*)sCauThongBao
                      kieuHopThoai:(int)nKieu
                     delegateAlert:(id<UIAlertViewDelegate>)delegateAlert
                 delegateTextfield:(id<UITextFieldDelegate>)delegateTextfield
{
    NSString *title = [@"thong_bao" localizableString];
    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:title
                                                      message:sCauThongBao
                                                     delegate:delegateAlert
                                            cancelButtonTitle:[@"button_huy" localizableString]
                                            otherButtonTitles:[@"button_dong_y" localizableString], nil] autorelease];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].delegate = delegateTextfield;
    [alert textFieldAtIndex:0].secureTextEntry = YES;
    [alert textFieldAtIndex:0].placeholder = [@"mat_khau_token" localizableString];
    alert.tag = nKieu;
    [alert show];
}

-(void)setBlockDelegate:(AlertBlock)blockDelegate
{
    if (blockDelegate)
    {
        self.delegate = self;
        objc_setAssociatedObject(self, "my key",blockDelegate, OBJC_ASSOCIATION_COPY);
    }
}
-(AlertBlock)blockDelegate
{
    return (AlertBlock)objc_getAssociatedObject(self,"my key");
}
-(void)showWithBlock:(AlertBlock)_block
{
    [self setBlockDelegate:_block];
    [self show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.blockDelegate)
        self.blockDelegate(self, (int)buttonIndex);
}

@end

@implementation UIActionSheet(Block)

-(void)setBlockDelegate:(ActionSheetBlock)blockDelegate
{
    if (blockDelegate)
    {
        self.delegate = self;
        objc_setAssociatedObject(self, "my key", blockDelegate, OBJC_ASSOCIATION_COPY);
    }
}
-(ActionSheetBlock)blockDelegate
{
    return (ActionSheetBlock)objc_getAssociatedObject(self,"my key");
}
-(void)showInView:(UIView *)view withBlock:(ActionSheetBlock)block_
{
    [self setBlockDelegate:block_];
    [self showInView:view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.blockDelegate(self, (int)buttonIndex);
}
-(void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    self.blockDelegate(self, (int)self.cancelButtonIndex);
}
@end
