//
//  CNVRadioBox.h
//  CNVTextField
//
//  Created by Chung NV on 2/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNVCheckBox.h"
@class CNVRadioBox;
typedef void(^RadioBoxBlock) (CNVRadioBox *radio);

@interface CNVRadioBox : UISegmentedControl<CNVCheckBoxDelegate>

@property (nonatomic)        NSInteger           selectedRadioIndex;
@property (nonatomic,retain) UIFont            * font;
@property (nonatomic,retain) UIColor           * textColor;

@property (nonatomic,retain) NSMutableArray    * items;

@property (nonatomic,retain) UIImage           * imageChecked;
@property (nonatomic,retain) UIImage           * imageUnchecked;

-(void) insertItemWithTitle:(NSString *)title 
                    atIndex:(NSUInteger)index;

-(void) setSelectedAtIndex:(int) index;
- (void)setCheckedImage:(UIImage *)checkedImage uncheckedImage:(UIImage *)uncheckedImage;

-(void) valueChanged:(RadioBoxBlock) block;
@end
