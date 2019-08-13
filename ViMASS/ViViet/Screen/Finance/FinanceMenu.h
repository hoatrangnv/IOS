//
//  FinanceMenu.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 2/15/14.
//
//

#import <UIKit/UIKit.h>
#import "UIView+Localization.h"

@class FinanceMenu;

@protocol FinanceMenuDelegate <NSObject>
@optional

- (void)FinanceMenuDidSelectCorpMode:(FinanceMenu *)view;

@end

@interface FinanceMenu : UIView

@property (nonatomic, assign) IBOutlet id<FinanceMenuDelegate> delegate;

@end
