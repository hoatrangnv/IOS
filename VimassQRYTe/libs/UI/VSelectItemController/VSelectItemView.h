//
//  VSelectItemView.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 11/23/13.
//
//

#import <UIKit/UIKit.h>

@interface VSelectItemView : UIView<UITableViewDataSource>

@property (nonatomic, retain) NSArray *data;
@property (nonatomic, readonly) UITableView *table;

+ (VSelectItemView *)create;

@end
