//
//  UIImagePickerController+UniBlock.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 9/6/13.
//
//

#import "UIImagePickerController+UniBlock.h"
#import <objc/runtime.h>


@implementation UIImagePickerController (UniBlock)

+ (UIImagePickerController *)pickerFrom:(UIImagePickerControllerSourceType)type callback:(UniPickerCallback)callback;
{
    UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
    
    picker.sourceType = type;
    picker.delegate = picker;
    
    objc_setAssociatedObject(picker, "uniblock", callback, OBJC_ASSOCIATION_COPY);
    
    return picker;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"%@", mediaType);
    
    UniPickerCallback callback = objc_getAssociatedObject(self, "uniblock");
    if (callback == nil)
        return;
    
    callback (picker, info);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"%@", mediaType);
    
    UniPickerCallback callback = objc_getAssociatedObject(self, "uniblock");
    if (callback == nil)
        return;
    
    callback (picker, info);
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    UniPickerCallback callback = objc_getAssociatedObject(self, "uniblock");
    if (callback == nil)
        return;
    
    callback (picker, nil);
}
@end
