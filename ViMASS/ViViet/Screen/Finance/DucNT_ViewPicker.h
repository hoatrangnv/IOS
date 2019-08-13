//
//  DucNT_ViewPicker.h
//  ViMASS
//
//  Created by MacBookPro on 7/29/14.
//
//

#import <UIKit/UIKit.h>

typedef void(^CapNhatGiaTriPicker)(int);

@interface DucNT_ViewPicker : UITextView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (retain, nonatomic) IBOutlet UIButton *btnDone;
@property (retain, nonatomic) IBOutlet UIButton *btnCancel;
@property (retain, nonatomic) IBOutlet UIPickerView *viewPicker;

- (IBAction)suKienDone:(id)sender;
- (IBAction)suKienCancel:(id)sender;

@property (retain, nonatomic) NSArray *dsDuLieu;
@property (assign, nonatomic) int nViTriDuocChon;

-(id)initWithNib;
-(void)khoiTaoDuLieu:(NSArray *)dicDuLieu;
-(void)capNhatKetQuaLuaChon:(CapNhatGiaTriPicker)nhanGiaTri;

@end
