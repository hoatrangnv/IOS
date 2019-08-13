#import "UIImage+Resize.h"
#define kMAX_IMAGEPIX 200.0          // max pix 200.0px
#define kMAX_IMAGEDATA_LEN 102400   // max data length 5K

// Private helper methods
@interface UIImage ()
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;
@end

@implementation UIImage (Resize)

- (UIImage *)croppedImage:(CGRect)bounds
{
    CGFloat tmp = 0, tx = 0, ty = 0;
    UIImage *croppedImage = nil;
    
    @autoreleasepool
    {
        switch(self.imageOrientation)
        {
            case UIImageOrientationRight:
                tmp = bounds.origin.y;
                bounds.origin.y = self.size.width - bounds.size.width - bounds.origin.x;
                bounds.origin.x = tmp;
                
                tmp = bounds.size.height;
                bounds.size.height = bounds.size.width;
                bounds.size.width = tmp;
                break;
                
            case UIImageOrientationDown:
                tx = bounds.origin.x;
                ty = bounds.origin.y;
                
                bounds.origin.x = self.size.width - bounds.size.width - tx;
                bounds.origin.y = self.size.height - bounds.size.height - bounds.origin.y;
                
                break;
                
            default:
                break;
        }
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
        croppedImage = [[UIImage alloc] initWithCGImage:imageRef scale:1.0 orientation:self.imageOrientation];
        CGImageRelease(imageRef);
    }
    
    return [croppedImage autorelease];
}

// Returns a copy of this image that is squared to the thumbnail size.
// If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail. (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality {
    UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                       bounds:CGSizeMake(thumbnailSize, thumbnailSize)
                                         interpolationQuality:quality];
    
    // Crop out any part of the image that's larger than the thumbnail size
    // The cropped rect must be centered on the resized image
    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
    CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
                                 round((resizedImage.size.height - thumbnailSize) / 2),
                                 thumbnailSize,
                                 thumbnailSize);
    UIImage *croppedImage = [resizedImage croppedImage:cropRect];
    
    UIImage *transparentBorderImage = borderSize ? [croppedImage transparentBorderImage:borderSize] : croppedImage;

    return [transparentBorderImage roundedCornerImage:cornerRadius borderSize:borderSize];
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %ld", (long)contentMode];
    }
    
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    
    return [self resizedImage:newSize interpolationQuality:quality];
}

- (NSData *)compressedData:(CGFloat)compressionQuality {
    assert(compressionQuality <= 1.0 && compressionQuality >= 0);
    
    return UIImageJPEGRepresentation(self, compressionQuality);
}


#pragma mark -
#pragma mark Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    
    return transform;
}

- (void)compressBelowMaxSize:(CGFloat)maxSize minCompressRatio:(NSInteger)minCompressRatio widthRange:(NSArray*)widthArr completedBlock:(CompressedBlock)_block {
    
    //__block UIImage *weakSelf = self;
    __block NSArray *weakWidthArr = [widthArr retain];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        //Do task in background thread
        NSData *compressedData = [self compressImage:self belowMaxSize:maxSize minCompressRatio:minCompressRatio widthRange:weakWidthArr];
        dispatch_sync(dispatch_get_main_queue(), ^{
            //Call complete block
            NSLog(@"Final Compress Data: %lu", (unsigned long)[compressedData length]);
            UIImage *compressedImage = [UIImage imageWithData:compressedData];
            _block(compressedData, compressedImage);
            [weakWidthArr release];
        });
    });
}

- (NSData*)compressImage:(UIImage*)image belowMaxSize:(CGFloat)maxSize minCompressRatio:(NSInteger)minCompressRatio widthRange:(NSArray*)widthArr {
    NSLog(@"BEGIN COMPRESS DATA ...");
    
    //Sort width array
    NSArray *sortedWidthArr = [widthArr sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSNumber *widthVal = nil;
    NSData *data = nil;
    UIImage *resized = nil;
    int count = 0;
    for (widthVal in sortedWidthArr) {
        CGFloat resizeWidth = [widthVal floatValue];
        CGFloat originalWidth = self.size.width;
        CGFloat resizeHeight = self.size.height * resizeWidth / originalWidth;
        resized = [image resizedImage:CGSizeMake(resizeWidth, resizeHeight) interpolationQuality:kCGInterpolationHigh];
        int minRatio = (int)minCompressRatio;
        int stepRatio = 5;
        int currentRatio = 100;
        do {
            if (currentRatio < minRatio) break;
            float compress = (float)currentRatio/100;
            data = UIImageJPEGRepresentation(resized, compress);
//            NSLog(@"Data length:%lu width:%f height%f ratio:%f", (unsigned long)[data length]/1024, resizeWidth, resizeHeight, compress);
            currentRatio -= stepRatio;
        }
        while ([data length] > maxSize);
        //while (YES);
        
        if ([data length] <= maxSize) {
            //finalRatio = currentRatio + stepRatio;
            break;
        }
        
        //if (count == [sortedWidthArr count] - 1) {
            //finalRatio = currentRatio + stepRatio;
        //}
        count++;
    }
    
    return data;
}

@end
