//
//  BPButton.h
//  test
//
//  Created by Thuong Ngo Ba on 7/22/12.
//  Copyright (c) 2012 CMC. All rights reserved.
//

/**
 *
 *   How to use: create a button, set button's class to BPButton and set "BGImage" keyPath as Background Image location.
 *
 *
 **/
#import <UIKit/UIKit.h>

CG_INLINE CGRect
CGMarginMake(CGFloat top, CGFloat right, CGFloat bottom, CGFloat left)
{
    CGRect rect;
    rect.origin.x = left;
    rect.origin.y = top;
    rect.size.width = right;
    rect.size.height = bottom;
    return rect;
}


@interface BPButton : UIButton

@property (nonatomic, assign) CGRect margin;
@property (nonatomic, assign) BOOL autoResizeWidth; // Auto extend/collapse with depends on content

-(void)setImage:(NSString *)imageFile;



@end
