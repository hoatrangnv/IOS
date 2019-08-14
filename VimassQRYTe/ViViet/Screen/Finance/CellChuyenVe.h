//
//  CellChuyenVe.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/18/16.
//
//

#import <UIKit/UIKit.h>
#import "ExTextField.h"

@protocol CellChuyenVeDelegate <NSObject>

- (void)suKienChonHanhLyChuyenVe;

@end

@interface CellChuyenVe : UITableViewCell<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) id<CellChuyenVeDelegate> delegate;
@property (retain, nonatomic) IBOutlet ExTextField *edHanhLy;
@property (retain, nonatomic) IBOutlet UILabel *lblKhachHang;
@end
