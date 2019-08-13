//
//  TPKeyboardAvoidAcessory
//
//  Created by MAC on 9/24/12.
//  Copyright (c) 2012 ChungNV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPKeyboardAvoidAcessory : UIScrollView
{
    UIEdgeInsets    _priorInset;
    BOOL            _priorInsetSaved;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
    CGSize          _originalContentSize;
    
}
@property (retain,nonatomic) NSMutableArray  *textFields;
@property (nonatomic, assign) BOOL showToolBar;
- (void) adjustOffsetToIdealIfNeeded;
@end
