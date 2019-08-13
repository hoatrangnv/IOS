//
//  CropImageHelper.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 9/9/13.
//
//

#import "CropImageHelper.h"
#import "UIImagePickerController+UniBlock.h"
#import "DemoImageEditor.h"
#import "UIImage+Resize.h"

@implementation CropImageHelper

+ (CGSize)best_viewframe_for_ratio:(CGFloat)ratio
{
    CGRect available_rect = [[UIScreen mainScreen] bounds];
    available_rect.size.height -= 20 + 44;
    
    CGFloat w = available_rect.size.width;
    CGFloat h = roundf (w / ratio);
    
    if (h > available_rect.size.height)
    {
        h = available_rect.size.height;
        w = roundf(h * ratio);
    }
    
    return CGSizeMake(w, h);
}

+ (void)crop_image_from:(UIImagePickerControllerSourceType)type
                  ratio:(CGFloat)ratio
              max_width:(CGFloat)max_width
                maxsize:(CGFloat)maxsize
         viewcontroller:(UIViewController *)nav
               callback:(void (^)(UIImage *img, NSData *data))callback;
{
    callback = [callback copy];
    
    UIImagePickerController *picker = [UIImagePickerController pickerFrom:type callback:^(UIImagePickerController *picker, NSDictionary *info)
    {
        if (info == nil)
        {
//            [nav dismissModalViewControllerAnimated:YES];
            [nav dismissViewControllerAnimated:YES completion:^{}];
            if(callback)
                [callback release];
            return;
        }
        
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType compare:@"public.image"] == NSOrderedSame)
        {
            UIImage *scrn = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            
            DemoImageEditor *vc = [[[DemoImageEditor alloc] initWithNibName:@"DemoImageEditor" bundle:nil] autorelease];
            NSLog(@"This is a trick to force view being loaded in order to get toolbar.items%@", vc.view);
            
            NSMutableArray *a = [NSMutableArray arrayWithArray:vc.toolbar.items];
            [a removeObjectAtIndex:2];
            [a removeObjectAtIndex:2];
            [a removeObjectAtIndex:2];
            vc.toolbar.items = a;
            
            vc.cropSize = [self best_viewframe_for_ratio:ratio];
            vc.checkBounds = YES;
            vc.doneCallback = ^(UIImage *editedImage, BOOL canceled)
            {
                if (canceled)
                {
                    if ([nav respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
                    {
                        [nav dismissViewControllerAnimated:YES completion:nil];
                    }
                    else
                        [nav dismissViewControllerAnimated:YES completion:^{}];
                    if(callback)
                        [callback release];
                    return;
                }
                
                [editedImage compressBelowMaxSize:maxsize minCompressRatio:1 widthRange:@[[NSNumber numberWithFloat:max_width]] completedBlock:^(NSData *compressedData, UIImage *compressedImage)
                {
                    callback (compressedImage, compressedData);
                    if(callback)
                        [callback release];
                }];
            };
            if(vc)
                vc.sourceImage = scrn;
            [vc reset:NO];
            
            [picker pushViewController:vc animated:YES];
            [vc.navigationController setNavigationBarHidden:YES animated:YES];
            return;
        }
        
//        [nav dismissModalViewControllerAnimated:YES];
        [nav dismissViewControllerAnimated:YES completion:^{}];
        [callback release];
    }];
    /*
     On iPad, UIImagePickerController must be presented via UIPopoverController
     */
//    [nav presentModalViewController:picker animated:YES];
    [nav presentViewController:picker animated:YES completion:^{}];
    
}

@end
