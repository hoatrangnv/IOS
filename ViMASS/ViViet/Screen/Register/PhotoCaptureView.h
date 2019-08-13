//
//  PhotoCaptureView.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 6/26/13.
//
//

#import <UIKit/UIKit.h>

#define PhotoCaptureViewMaxWidth_ID 500
#define PhotoCaptureViewMaxSize_ID 30*1024
#define PhotoCaptureViewMaxWidth_Passport 500
#define PhotoCaptureViewMaxSize_Passport 50 * 1024
#define PhotoCaptureViewMaxWidth_PersonalPhoto 300
#define PhotoCaptureViewMaxSize_PersonalPhoto 30 * 1024
#define PhotoCaptureViewMaxWidth_Signature 300
#define PhotoCaptureViewMaxSize_Signature 30 * 1024


@interface PhotoCaptureView : UIView<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) IBOutlet UIImageView *imgview;
@property (nonatomic, assign) IBOutlet UILabel *label;
@property (nonatomic, assign) IBOutlet UIButton *btn_camera;
@property (nonatomic, assign) IBOutlet UIButton *btn_gallery;
@property (nonatomic, assign) IBOutlet UIViewController *view_controller;

// Overlay view will be hidden when user already set image.
@property (nonatomic, retain) IBOutletCollection(UIView) NSArray *overlay;

@property (nonatomic, assign) CGFloat max_size;
@property (nonatomic, assign) CGFloat max_width;

@end
