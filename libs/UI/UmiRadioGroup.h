//
//  UmiRadioGroup.h
//  test_radios
//
//  Created by Ngo Ba Thuong on 8/17/13.
//  Copyright (c) 2013 ViMASS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UmiRadioGroup_ContentModeFix  0
#define UmiRadioGroup_ContentModeLeft 1
#define UmiRadioGroup_ContentModeJustify 2

@class UmiRadioGroup;

@protocol UmiRadioGroupDelegate <NSObject>

- (void)UmiRadioGroup:(UmiRadioGroup *)radios did_select_item:(int)index;

@end

@interface UmiRadioGroup : NSObject
{
    NSArray* radios;
    
    int         content_mode;
    CGFloat     button_padding;
    int         selectedIndex;
    BOOL        enabled;
    
    id<UmiRadioGroupDelegate> delegate;
}
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *radios;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) BOOL      enabled;
@property (nonatomic, assign) int content_mode;
@property (nonatomic, assign) CGFloat button_padding;
@property (nonatomic, assign) IBOutlet id<UmiRadioGroupDelegate> delegate;

@end
