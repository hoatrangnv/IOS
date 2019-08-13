//
//  SelectItemController.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/4/12.
//
//

#import <UIKit/UIKit.h>

#define VSelectItemController_StateWillSelect 1
#define VSelectItemController_StateWillSelected 2

@interface VSelectItemController : NSObject

@property (nonatomic, readonly) NSMutableArray *data;
@property (nonatomic, readonly) NSString *title;

- (id) initWithData:(NSMutableArray *)data title:(NSString *)title;

- (void)select_in_view:(UIView *)view
              callback:(BOOL (^)(VSelectItemController *ctrl, int index, int state))callback;

- (void)close:(void(^)()) finished;
- (void)close;

@end
