//
//  CellChuyenDi.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/12/16.
//
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"

@protocol CellChuyenDiProtocol <NSObject>

- (void)suKienThayDoiChonHanhLy;

@end

@interface CellChuyenDi : UITableViewCell<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, assign) id<CellChuyenDiProtocol> delegate;
@property (nonatomic, assign) int nKieu;
@property (retain, nonatomic) IBOutlet ExTextField *edDanhXung;
@property (retain, nonatomic) IBOutlet ExTextField *edHoTen;
@property (retain, nonatomic) IBOutlet ExTextField *edOptionHanhLy;
@property (retain, nonatomic) IBOutlet ExTextField *edNgaySinh;
- (void)khoiTaoNguoiLon;
@end
