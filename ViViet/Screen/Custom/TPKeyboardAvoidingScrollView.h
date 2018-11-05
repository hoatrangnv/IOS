//
//  TPKeyboardAvoidingScrollView.h
//
//  Created by Michael Tyson on 11/04/2011.
//  Copyright 2011 A Tasty Pixel. All rights reserved.
//

@interface TPKeyboardAvoidingScrollView : UIScrollView {
    UIEdgeInsets    _priorInset;
    BOOL            _priorInsetSaved;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
    CGSize          _originalContentSize;
}
/**
 *
 * Distance from top edge of the keyboard to the bottom of the textfield
 */
@property (nonatomic, assign) CGFloat addtionOffset;

- (void)adjustOffsetToIdealIfNeeded;

@end
