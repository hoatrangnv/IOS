// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support resizing/cropping

typedef void (^CompressedBlock)(NSData *compressedData,UIImage *compressedImage);

@interface UIImage (Resize)
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (NSData *)compressedData:(CGFloat)compressionQuality;

- (void)compressBelowMaxSize:(CGFloat)maxSize minCompressRatio:(NSInteger)minCompressRatio widthRange:(NSArray*)widthArr completedBlock:(CompressedBlock)_block;
//- (NSData*)compressBelowMaxSize:(CGFloat)maxSize minCompressRatio:(NSInteger)minCompressRatio widthRange:(NSArray*)widthArr;

@end
