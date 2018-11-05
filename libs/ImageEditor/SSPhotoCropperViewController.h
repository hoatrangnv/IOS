
/*
 Copyright 2011 Ahmet Ardal
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

//
//  SSPhotoCropperViewController.h
//  SSPhotoCropperDemo
//
//  Created by Ahmet Ardal on 10/17/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum SSPhotoCropperUIMode_ {
    SSPCUIModePresentedAsModalViewController,
    SSPCUIModePushedOnToANavigationController
} SSPhotoCropperUIMode;


@interface SSPhotoCropperViewController: UIViewController<UIScrollViewDelegate>
{
    CGFloat _crop_ratio;
    CGFloat _desired_width;
    
    UIScrollView *scrollView;
    UIImage *photo;
    UIImageView *imageView;
    UIButton *cropRectangleButton;
    UIButton *infoButton;
    
    CGPoint _lastTouchDownPoint;
    SSPhotoCropperUIMode _uiMode;
    BOOL _showsInfoButton;
    
    CGFloat minZoomScale;
    CGFloat maxZoomScale;
    
    NSString *infoMessageTitle;
    NSString *infoMessageBody;
    NSString *photoCropperTitle;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) UIImage *photo;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *cropRectangleButton;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, assign) CGFloat minZoomScale;
@property (nonatomic, assign) CGFloat maxZoomScale;
@property (nonatomic, retain) NSString *infoMessageTitle;
@property (nonatomic, retain) NSString *infoMessageBody;
@property (nonatomic, retain) NSString *photoCropperTitle;

@property (nonatomic, readonly, assign) UIImage *cropped_image;
@property (nonatomic, assign) CGFloat crop_ratio;
@property (nonatomic, assign) CGFloat desired_width;


- (id) initWithPhoto:(UIImage *)aPhoto
     showsInfoButton:(BOOL)showsInfoButton
              handle:(void (^)(SSPhotoCropperViewController *cropper, bool cancel))handle;

- (IBAction) infoButtonTapped:(id)sender;

@end