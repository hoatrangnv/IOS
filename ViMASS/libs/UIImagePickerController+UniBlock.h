//
//  UIImagePickerController+UniBlock.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 9/6/13.
//
//

#import <UIKit/UIKit.h>

typedef void (^UniPickerCallback)(UIImagePickerController *picker, NSDictionary *info);

@interface UIImagePickerController (UniBlock)<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

+ (UIImagePickerController *)pickerFrom:(UIImagePickerControllerSourceType)type callback:(UniPickerCallback)callback;

@end
