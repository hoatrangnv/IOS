//
//  UmiTextView.h
//  test_multilineedit
//
//  Created by Ngo Ba Thuong on 9/3/13.
//  Copyright (c) 2013 ViMASS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"
@interface UmiTextView : UITextView <UITextViewDelegate, UITextFieldDelegate>
{
    UITextField *textfield;
}

@property (nonatomic, assign) IBOutlet UITextField *textfield;

- (void)update_frame;
- (void)update_textfield;
- (void)setPlaceHolder:(NSString*) sPlace;
@end
