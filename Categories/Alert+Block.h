//
//  UIAlertView+Block.h
//  ViMASS
//
//  Created by Chung NV on 3/27/13.
//
//

#import <Foundation/Foundation.h>
#import "LocalizationSystem.h"

typedef void (^AlertBlock)(UIAlertView *alert,int indexClicked);

enum KIEU_HOP_THOAI
{
    TAG_HOP_THOAI_THONG_BAO_HOI_CO_XOA_TIN_KHONG_TOKEN,
    TAG_HOP_THOAI_THONG_BAO_HOI_CO_XOA_TIN_KEM_TOKEN
};

@interface UIAlertView(Block)<UIAlertViewDelegate>

@property (nonatomic,copy) AlertBlock blockDelegate;

+ (void)alert:(NSString *)text withTitle:(NSString *)title block:(AlertBlock) _block;
+ (void)hienThiThongBaoHaiNut:(NSString*)sCauThongBao
                 kieuHopThoai:(int)nKieu
                     delegate:(id<UIAlertViewDelegate>)delegate;
+ (void)hienThiThongBaoCoTextfield:(NSString*)sCauThongBao
                      kieuHopThoai:(int)nKieu
                     delegateAlert:(id<UIAlertViewDelegate>)delegateAlert
                 delegateTextfield:(id<UITextFieldDelegate>)delegateTextfield;

-(void)showWithBlock:(AlertBlock) _block;

@end

typedef void (^ActionSheetBlock)(UIActionSheet *actionSheet,int indexClicked);

@interface UIActionSheet(Block)<UIActionSheetDelegate>

@property (nonatomic,copy) ActionSheetBlock blockDelegate;

-(void)showInView:(UIView *) view
        withBlock:(ActionSheetBlock) _block;

@end
