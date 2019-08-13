
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
//  SSPhotoCropperViewController.m
//  SSPhotoCropperDemo
//
//  Created by Ahmet Ardal on 10/17/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import "SSPhotoCropperViewController.h"
#import "UIImage+Resize.h"

@interface SSPhotoCropperViewController(Private)
- (void) loadPhoto;
- (void) setScrollViewBackground;
- (IBAction) saveAndClose:(id)sender;
- (IBAction) cancelAndClose:(id)sender;
- (BOOL) isRectanglePositionValid:(CGPoint)pos;
- (IBAction) imageMoved:(id)sender withEvent:(UIEvent *)event;
- (IBAction) imageTouch:(id)sender withEvent:(UIEvent *)event;
@end

@implementation SSPhotoCropperViewController
{
    void (^listener)(SSPhotoCropperViewController *cropper, bool cancel);
}

@synthesize scrollView, photo, imageView, cropRectangleButton, infoButton,
minZoomScale, maxZoomScale, infoMessageTitle, infoMessageBody, photoCropperTitle;

@synthesize crop_ratio = _crop_ratio;
@synthesize desired_width = _desired_width;

- (void)setCrop_ratio:(CGFloat)ratio
{
    _crop_ratio = ratio;
    if (self.cropRectangleButton != nil)
    {
        CGRect b = self.cropRectangleButton.bounds;
        b.size.height = b.size.width/_crop_ratio;
        self.cropRectangleButton.bounds = b;
    }
}

- (id) initWithPhoto:(UIImage *)aPhoto
     showsInfoButton:(BOOL)showsInfoButton
              handle:(void (^)(SSPhotoCropperViewController *, bool))handle
{
    if (!(self = [super initWithNibName:@"SSPhotoCropperViewController" bundle:nil])) {
        return self;
    }
    
    if (handle != nil)
    {
        listener = [handle copy];
    }
    
    self.photo = aPhoto;
    _uiMode = SSPCUIModePresentedAsModalViewController;
    _showsInfoButton = showsInfoButton;
    
    self.minZoomScale = 0.5f;
    self.maxZoomScale = 30.0f;
    
    self.infoMessageTitle = @"In order to crop the photo";
    self.infoMessageBody = @"Use two of your fingers to zoom in and out the photo and drag the"
    @" green window to crop any part of the photo you would like to use.";
    self.photoCropperTitle = @"Crop Photo";
    
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.photo = nil;
    }
    return self;
}

//-(void)setPhoto:(UIImage *)org_photo
//{
//    NSLog(@"original orientation: %d", org_photo.imageOrientation);
//    if (org_photo != self->photo)
//    {
//        [self->photo release];
//        self->photo = [[UIImage imageWithCGImage:org_photo.CGImage scale:1.0 orientation:UIImageOrientationUp] retain];
//    }
//}

- (void) dealloc
{
    [listener release];
    [self.scrollView release];
    [self.photo release];
    [self.imageView release];
    [self.cropRectangleButton release];
    [self.infoButton release];
    [self.infoMessageTitle release];
    [self.infoMessageBody release];
    [self.photoCropperTitle release];
    [super dealloc];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction) infoButtonTapped:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:self.infoMessageTitle
                                                 message:self.infoMessageBody
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
    [av release];
}


#pragma -
#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.crop_ratio = _crop_ratio;
    
    //
    // setup view ui
    //
    UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                        target:self
                                                                        action:@selector(saveAndClose:)];
    self.navigationItem.rightBarButtonItem = bi;
    [bi release];
    
    if (_uiMode == SSPCUIModePresentedAsModalViewController) {
        bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                           target:self
                                                           action:@selector(cancelAndClose:)];
        self.navigationItem.leftBarButtonItem = bi;
        [bi release];
    }
    
    if (!_showsInfoButton) {
        [self.infoButton setHidden:YES];
    }
    
    self.title = self.photoCropperTitle;
    
    //
    // photo cropper ui stuff
    //
    [self setScrollViewBackground];
    [self.scrollView setMinimumZoomScale:self.minZoomScale];
    [self.scrollView setMaximumZoomScale:self.maxZoomScale];
    
    [self.cropRectangleButton addTarget:self
                                 action:@selector(imageTouch:withEvent:)
                       forControlEvents:UIControlEventTouchDown];
    [self.cropRectangleButton addTarget:self
                                 action:@selector(imageMoved:withEvent:)
                       forControlEvents:UIControlEventTouchDragInside];
    
    if (self.photo != nil) {
        [self loadPhoto];
    }
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


#pragma -
#pragma UIScrollViewDelegate Methods

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


#pragma -
#pragma Private Methods

- (void) loadPhoto
{
    if (self.photo == nil) {
        return;
    }
    
    CGFloat w = self.photo.size.width;
    CGFloat h = self.photo.size.height;
    CGRect imageViewFrame = CGRectMake(0.0f, 0.0f, roundf(w / 2.0f), roundf(h / 2.0f));
    self.scrollView.contentSize = imageViewFrame.size;
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:imageViewFrame];
    iv.image = self.photo;
    [self.scrollView addSubview:iv];
    self.imageView = iv;
    //    self.imageView.contentMode = UIViewContentModeCenter;
    [iv release];
}

- (void) setScrollViewBackground
{
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"photo_cropper_bg"]];
}
- (UIImage *)reorient_image:(UIImage *)img
{
    UIImage *img2 = [[[UIImage alloc] initWithCGImage:img.CGImage scale:1.0 orientation:UIImageOrientationUp] autorelease];
    return img2;
}

- (UIImage *)cropped_image
{
    return [self croppedPhoto];
}
- (UIImage *) croppedPhoto
{
    UIImage *rslt = nil;
    @autoreleasepool
    {
        CGFloat ox = self.scrollView.contentOffset.x;
        CGFloat oy = self.scrollView.contentOffset.y;
        CGFloat zoomScale = self.scrollView.zoomScale;
        
        CGFloat cx = roundf ((ox + self.cropRectangleButton.frame.origin.x) * 2.0f / zoomScale);
        CGFloat cy = roundf ((oy + self.cropRectangleButton.frame.origin.y) * 2.0f / zoomScale);
        
        CGFloat cw = roundf (self.cropRectangleButton.frame.size.width * 2.0f / zoomScale);
        CGFloat ch = roundf (self.cropRectangleButton.frame.size.height * 2.0f / zoomScale);
        
        NSLog(@"photo size: %@", NSStringFromCGSize(self.photo.size));
        
        rslt = [[self.photo croppedImage:CGRectMake(cx, cy, cw, ch)] retain];
        
        NSLog(@"image size sau crop: %@", NSStringFromCGSize(rslt.size));
        
        NSLog(@"1. ch = %f, cw = %f", ch, cw);
        if (_desired_width > 0 && cw > _desired_width)
        {
            ch = roundf(ch * _desired_width / cw);
            cw = _desired_width;
            
            NSLog(@"2. ch = %f, cw = %f", ch, cw);
            
            UIImage *tmp = rslt;
            rslt = [[rslt resizedImage:CGSizeMake(cw, ch) interpolationQuality:kCGInterpolationDefault] retain];
            [tmp release];
        }
    }
    return [rslt autorelease];
}

- (IBAction) saveAndClose:(id)sender
{
    if (listener != nil)
    {
        listener (self, false);
    }
}

- (IBAction) cancelAndClose:(id)sender
{
    if (listener != nil)
    {
        listener (self, true);
    }
}

- (BOOL) isRectanglePositionValid:(CGPoint)pos
{
    CGRect innerRect = CGRectMake((pos.x + 15), (pos.y + 15), 150, 150);
    return CGRectContainsRect(self.scrollView.frame, innerRect);
}

- (IBAction) imageMoved:(id)sender withEvent:(UIEvent *)event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    
    CGPoint prev = _lastTouchDownPoint;
    _lastTouchDownPoint = point;
    CGFloat diffX = point.x - prev.x;
    CGFloat diffY = point.y - prev.y;
    
    UIControl *button = sender;
    CGRect newFrame = button.frame;
    newFrame.origin.x += diffX;
    newFrame.origin.y += diffY;
    if ([self isRectanglePositionValid:newFrame.origin]) {
        button.frame = newFrame;
    }
}

- (IBAction) imageTouch:(id)sender withEvent:(UIEvent *)event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    _lastTouchDownPoint = point;
}

@end
