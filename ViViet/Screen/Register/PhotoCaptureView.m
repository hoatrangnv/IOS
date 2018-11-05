//
//  PhotoCaptureView.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 6/26/13.
//
//

#import "PhotoCaptureView.h"
#import "AppDelegate.h"
#import "BaseScreen.h"
#import "CropImageHelper.h"
#import <objc/runtime.h>
#import "Common.h"

@implementation PhotoCaptureView
{
    bool initialized;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (initialized)
        return;
    self.max_width = 600;
    self.max_size = 100 * 1024;
    
    initialized = true;
    self.imgview.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gest = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch_image)] autorelease];
    gest.numberOfTapsRequired = 1;
    [self.imgview addGestureRecognizer:gest];
    
    [self.btn_camera addTarget:self action:@selector(capture_camera) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_gallery addTarget:self action:@selector(capture_gallery) forControlEvents:UIControlEventTouchUpInside];
}

- (void)capture_camera
{
    [self capture:UIImagePickerControllerSourceTypeCamera];
}
- (void)capture_gallery
{
    [self capture:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (void)touch_image
{
    if (self.imgview.image == nil)
        return;
}
- (void)capture:(int)source
{
    if ([UIImagePickerController isSourceTypeAvailable:source])
    {
        __block UIViewController *vc = [Common top_view_controller];
        [vc.view endEditing:YES];
        [CropImageHelper crop_image_from:source
                                   ratio:self.imgview.frame.size.width/self.imgview.frame.size.height
                               max_width:self.max_width
                                 maxsize:self.max_size
                          viewcontroller:vc
                                callback:^(UIImage *img, NSData *data)
         {
             self.imgview.image = img;
             objc_setAssociatedObject(img, "image_data", data, OBJC_ASSOCIATION_RETAIN);
             if (self.overlay)
             {
                 for (UIView *v in self.overlay)
                     v.hidden = YES;
             }
             
//             [vc dismissModalViewControllerAnimated:YES];
             [vc dismissViewControllerAnimated:YES completion:^{}];
//             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//             [[UIApplication sharedApplication] setStatusBarHidden:NO];
         }];
    }
    else
    {
        [UIAlertView alert:@"device does not support this feature" withTitle:nil block:nil];
    }
}

- (void)dealloc
{
    self.overlay = nil;
    [super dealloc];
}

@synthesize imgview;
@end
