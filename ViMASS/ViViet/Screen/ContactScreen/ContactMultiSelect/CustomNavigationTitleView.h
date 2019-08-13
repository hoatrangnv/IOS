//
//  CustomNavigationTitleView.h
//  ViViMASS
//
//  Created by Nguyen Van Hoanh on 11/4/18.
//

#import <UIKit/UIKit.h>
@protocol CustomNavigationTitleViewDelegate<NSObject>
- (void)textFieldDidBeginEditing;
@end
@interface CustomNavigationTitleView : UIView <UITextFieldDelegate>
@property (retain,nonatomic) id<CustomNavigationTitleViewDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UITextField *txtAddNumber;
- (BOOL)isHasText;
@end
