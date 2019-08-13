//
//  UIView+Swipe.h
//  ViMASS
//
//  Created by Chung NV on 4/1/14.
//
//

#import <Foundation/Foundation.h>

typedef void (^UIViewSwipeBlock)(UIView *view);
typedef enum {
    UIViewSwipeDirectionUp,
    UIViewSwipeDirectionRight,
    UIViewSwipeDirectionDown,
    UIViewSwipeDirectionLeft
} UIViewSwipeDirection;

@interface UIView(Swipe)

@property (nonatomic,copy) UIViewSwipeBlock swipeUpBlock;
@property (nonatomic,copy) UIViewSwipeBlock swipeRightBlock;
@property (nonatomic,copy) UIViewSwipeBlock swipeDownBlock;
@property (nonatomic,copy) UIViewSwipeBlock swipeLeftBlock;

@property (nonatomic,retain) UISwipeGestureRecognizer *swipeGestureUp;
@property (nonatomic,retain) UISwipeGestureRecognizer *swipeGestureRight;
@property (nonatomic,retain) UISwipeGestureRecognizer *swipeGestureDown;
@property (nonatomic,retain) UISwipeGestureRecognizer *swipeGestureLeft;
/**
 *
 * Swipe with direction and block.
 * @param direction Hướng : UIViewSwipeDirectionUp,Right,Down,Left
 * @param block block xử lý.
 *
 */
-(void) swipe:(UIViewSwipeDirection) direction
       action:(UIViewSwipeBlock) block;

-(BOOL) swipe_remove:(UIViewSwipeDirection) direction;

@end
