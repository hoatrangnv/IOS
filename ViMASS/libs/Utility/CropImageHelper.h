//
//  CropImageHelper.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 9/9/13.
//
//

#import <Foundation/Foundation.h>

@interface CropImageHelper : NSObject

+ (void)crop_image_from:(UIImagePickerControllerSourceType)type
                  ratio:(CGFloat)ratio
              max_width:(CGFloat)max_width
                maxsize:(CGFloat)maxsize
         viewcontroller:(UIViewController *)nav
               callback:(void (^)(UIImage *img, NSData *data))callback;

@end
