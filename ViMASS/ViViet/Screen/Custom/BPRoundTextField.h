//
//  BPRoundTextField.h
//  Best Player iOS App
//
//  Created by Thuong Ngo Ba on 7/16/12.
//  Copyright (c) 2012 CMC. All rights reserved.
//

// How to use.

/**
 *
 *   Just change class name of the text field to BPRoundTextField in the Identity Inspector window
 *
 **/

#import <UIKit/UIKit.h>

@interface BPRoundTextField : UITextField
{
    NSString * image;
    NSString * icon;
}

@property (nonatomic, copy) NSString * image;
@property (nonatomic, copy) NSString * icon;
-(void)initialize;
@end
