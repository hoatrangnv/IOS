//
//  CustomViewSearch.h
//  ViViMASS
//
//  Created by Nguyen Van Hoanh on 11/4/18.
//

#import <UIKit/UIKit.h>
@protocol CustomViewSearchDelegate <NSObject>
- (void)refresh;
- (void)searchContact:(NSString*)text;
@end
@interface CustomViewSearch : UIView
@property (nonatomic,retain) id<CustomViewSearchDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UITextField *txtSearch;
@property (retain, nonatomic) IBOutlet UIButton *btnRefresh;
- (IBAction)actionRefresh:(id)sender;

@end
