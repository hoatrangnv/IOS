//
//  CNVCheckBox.h
//  CNVTextField
//
//  Created by Chung NV on 2/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CNVCheckBox;

typedef void (^CheckBoxValueChanged)(CNVCheckBox *checkBox);

@protocol CNVCheckBoxDelegate <NSObject>

-(void) CNVCheckBoxValueChanged:(CNVCheckBox*) _checkbox;

@end


@interface CNVCheckBox : UIButton

@property (nonatomic) BOOL checked;
@property (nonatomic,readonly,retain) UILabel                 * lblText;
@property (nonatomic,readonly,retain) UIImageView             * imageCheckbox;
@property (nonatomic,retain)          UIImage                 * imageUnchecked;
@property (nonatomic,retain)          UIImage                 * imageChecked;
@property (nonatomic,retain) IBOutlet id<CNVCheckBoxDelegate>   delegate;

-(void) setTitleCheckbox:(NSString*) _text;
-(void) valueChanged:(CheckBoxValueChanged) valueChangedBlock;

@end
