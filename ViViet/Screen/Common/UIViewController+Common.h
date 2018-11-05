//
//  UIViewController+Common.h
//  ViMASS
//
//  Created by GOD on 11/5/12.
//
//

#import <UIKit/UIKit.h>
#import "DDAlertPrompt.h"
#import "Alert+Block.h"
//#import "Msg.h"

@interface UIViewController (Common)

/**
 *
 * Shift the main view 20 to top in OS version < 7. The view should account for
 * new design of ios 7.
 *
 */
- (void)fix_status_bar;
/**
 *
 * Dành cho app muốn làm theo phong cách status bar như ios < 7. Hàm này sẽ thêm vào 1 view trên đầu (nếu hệ điều hành > 7) để
 * giống như ios < 7. Nếu ios < 7 thì không phải làm gì.
 *
 **/
- (void)fix_status_bar:(UIColor *)color;

- (void)select_police_department:(void (^)(int index, NSString *PD))callback;
- (BOOL)can_use_token;
- (BOOL)can_use_soft;

- (void)didSelectBackButton;
- (void)customLogoutButton;
- (void)addHiddenButton:(BOOL) left;
- (void)addNavigationItemWithTitle:(NSString *)title andAction:(SEL)selector atLeftSide:(BOOL)left;
- (void)addBackButton: (BOOL) force;
- (UIBarButtonItem *)negative_baritem_at_side:(BOOL)left;
- (void)alertErrorCode:(NSString *)errorCode callback:(void (^)(void)) callback;

//- (UIAlertView *)alert:(NSString *)text withTitle:(NSString *)title withTarget:(id)target andTag:(int)tag;
- (UIAlertView *)alert:(NSString *)text withTitle:(NSString *)title block:(AlertBlock) _block;
- (UIAlertView *)confirm:(NSString *)text title:(NSString *)title block:(AlertBlock) _block;
+ (UIAlertView *)alert:(NSString *)text withTitle:(NSString *)title block:(AlertBlock) _block;
+ (UIAlertView *)confirm:(NSString *)text title:(NSString *)title block:(AlertBlock) _block;
/*
 ham duoi se bo dan di. Thay vao do su dung ham prompt cua DDAlertPrompt
 ChungNV : Em đổi cái hàm này rồi anh nhé
 *
 - (DDAlertPrompt *)prompt:(NSString *)msg type:(int)type callback:..;
 */

- (void)addBackground;
- (void)initAutoLocalizeView;
- (void)localizeViews;

// Common for this app
- (BOOL)validateNotificationPhones:(NSString **)phoneList;

@property (nonatomic, retain) NSMutableArray *viewToText;

@end
