//
//  MultipagePhotoCapture.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 9/5/13.
//
//

#import "MultipagePhotoCapture.h"
#import "AppDelegate.h"
#import <objc/runtime.h>
#import "CropImageHelper.h"

@interface MultipagePhotoCapture ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@end

@implementation MultipagePhotoCapture
{
    NSMutableArray *v_images;
    BOOL editmode;
}

- (void)did_crop_image:(UIImage *)img
{
    if (v_images == nil)
        v_images = [[NSMutableArray alloc] initWithCapacity:10];
    
    if (editmode == NO)
    {
        UIImageView *v_img = [[[UIImageView alloc] initWithImage:img] autorelease];
        [v_images addObject:v_img];
        
        CGRect added_rect = CGRectMake((v_images.count - 1) * v_scroll.frame.size.width, 0, v_scroll.frame.size.width, v_scroll.frame.size.height);
        v_img.frame = added_rect;
        [v_scroll addSubview:v_img];
        v_scroll.contentSize = CGSizeMake(v_images.count* v_scroll.frame.size.width, added_rect.size.height);
        [v_scroll setContentOffset:CGPointMake((v_images.count - 1) * v_scroll.frame.size.width, 0) animated:YES];
        
        UITapGestureRecognizer *ges = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did_tap_on_image)] autorelease];
        v_img.userInteractionEnabled = YES;
        [v_img addGestureRecognizer:ges];
    }
    else
    {
        CGFloat x = v_scroll.contentOffset.x;
        int idx = roundf (x / v_scroll.frame.size.width);
        
        UIImageView *v = [v_images objectAtIndex:idx];
        v.image = img;
    }
}

- (void)crop:(UIImagePickerControllerSourceType)source
{
    __block AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [CropImageHelper crop_image_from:source
                               ratio:210.f/297.f
                           max_width:600
                             maxsize:250 * 1024
                      viewcontroller:app.navigationController
                            callback:^(UIImage *img, NSData *data)
     {
         objc_setAssociatedObject(img, "image_data", data, OBJC_ASSOCIATION_RETAIN);
         
         if (v_images.count == 0)
         {
             [self did_crop_image:(img)];
             [app.navigationController dismissViewControllerAnimated:YES completion:nil];
         }
         else
         {
             [app.navigationController dismissViewControllerAnimated:YES completion:^
              {
                  [self did_crop_image:(img)];
              }];
         }
         
//         [app.navigationController dismissModalViewControllerAnimated:YES];
         [app.navigationController dismissViewControllerAnimated:YES completion:^{}];
     }];
}

- (void)did_tap_on_image
{
    editmode = YES;
    [self crop:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)add
{
    editmode = NO;
    [self crop:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)del
{
    if (v_images == nil || v_images.count == 0)
        return;
    
    self.userInteractionEnabled = NO;
    
    CGFloat x = v_scroll.contentOffset.x;
    int idx = roundf (x / v_scroll.frame.size.width);
    
    UIImageView *del_img = [v_images objectAtIndex:idx];
    UIImageView *next_img = idx < v_images.count - 1 ? [v_images objectAtIndex:idx+1] : nil;
    
    [UIView animateWithDuration:0.35 animations:^
     {
         CGRect r = del_img.frame;
         r.origin.x = r.origin.x + r.size.width/2;
         r.origin.y = r.origin.y + r.size.height/2;
         r.size.height = 0;
         r.size.width = 0;
         
         del_img.frame = r;
         
         if (next_img != nil)
         {
             r = next_img.frame;
             r.origin.x -= r.size.width;
             
             next_img.frame = r;
         }
         else if (v_images.count >= 2)
         {
             UIImageView *pre_img = [v_images objectAtIndex:idx-1];
             v_scroll.contentOffset = CGPointMake(pre_img.frame.origin.x, 0);
         }
         
     } completion:^(BOOL finished)
     {
         [del_img removeFromSuperview];
         [v_images removeObjectAtIndex:idx];
         for (int i = idx + 1; i < v_images.count; i++)
         {
             CGRect r = CGRectMake(i * v_scroll.frame.size.width, 0, v_scroll.frame.size.width, v_scroll.frame.size.height);
             ((UIView *)[v_images objectAtIndex:i]).frame = r;
         }
         v_scroll.contentSize = CGSizeMake(v_images.count* v_scroll.frame.size.width, v_scroll.frame.size.height);
         
         self.userInteractionEnabled = YES;
     }];
}

- (NSArray *)images
{
    NSMutableArray *a = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    for (int i = 0; i < v_images.count; i++)
         [a addObject:((UIImageView *)[v_images objectAtIndex:i]).image];
    
    return a;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        UIView *v = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        
        v.frame = self.bounds;

        [self addSubview:v];
    }
    return self;
}


- (void)dealloc {
    [v_scroll release];
    [super dealloc];
}
@end
