//
//  SelectItemController.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/4/12.
//
//

#import <UIKit/UIKit.h>
#import "KazeSlider.h"

#define SelectItemController_ItemSelected 1
#define SelectItemController_WillSelect 2
#define SelectItemController_DidSelect 3
#define SelectItemController_DidCancel 4

@interface SelectItemController : KazeSlider <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>

@property (retain, nonatomic) UISearchBar *searchBar;

- (id) initWithData: (NSMutableArray *)data title:(NSString *)title;

#warning Deprecated

- (void) show:(void (^)(int index, bool didSelected))onFinish;
//
//
//
- (void)shows:(BOOL (^)(SelectItemController *view, int index, int flag))callback;

@end
