//
//  ExPicker.h
//  ViMASS
//
//  Created by Chung NV on 8/7/13.
//
//

#import <UIKit/UIKit.h>

@interface ExPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, retain) NSArray *datasource;
@property (nonatomic, retain) UIPickerView *pickerView;

-(void) selectRow:(int) row animated:(BOOL) animated;

-(void) didPickerDone:(void(^)(int index,id selectedValue)) pickerDone;
-(void) didPickerCancel:(void(^)(ExPicker *picker)) pickerCancel;
@end
