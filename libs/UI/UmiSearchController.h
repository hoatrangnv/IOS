//
//  UmiSearchController.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 11/1/13.
//
//

#import <Foundation/Foundation.h>
@class UmiSearchController;

@protocol UmiSearchControllerDelegate <NSObject>
@optional

- (void)UmiSearchController:(UmiSearchController *)search_controller search:(NSString *)text;
- (void)UmiSearchController:(UmiSearchController *)search_controller text_change:(NSString *)text;

@end

@interface UmiSearchController : NSObject <UITextFieldDelegate>

@property (nonatomic, assign) IBOutlet UITextField *textfield;
@property (nonatomic, assign) IBOutlet UIView *bar;
@property (nonatomic, assign) IBOutlet UITableView *table;
@property (nonatomic, assign) IBOutlet UIButton *button;

@property (nonatomic, assign) IBOutlet id<UmiSearchControllerDelegate> delegate;

@end
