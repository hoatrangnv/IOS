//
//  DropdownList.h
//  ViMASS
//
//  Created by Chung NV on 7/25/13.
//
//

#import <UIKit/UIKit.h>

typedef void(^DropdownListDidSelectItem)(int selectedIndex, id selectedValue);

@interface DropdownList : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    DropdownListDidSelectItem _didSelecteItem;
}
@property (nonatomic, retain) NSArray *source;

@property (nonatomic, retain) IBOutlet UITextField *textfield;

-(BOOL) isShow;
-(void) showUnderView:(UIView *) underView
               inView:(UIView *) showInView;
-(void) hide;

-(void) didSelectedItem:(DropdownListDidSelectItem) didSelecteItem;
@end
