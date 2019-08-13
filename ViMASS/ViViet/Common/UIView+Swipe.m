//
//  UIView+Swipe.m
//  ViMASS
//
//  Created by Chung NV on 4/1/14.
//
//

#import "UIView+Swipe.h"
#import <objc/runtime.h>

@implementation UIView(Swipe)

#pragma mark - Actions Swipe

-(void) did_swiped_up
{
    if (self.swipeUpBlock)
    {
        self.swipeUpBlock(self);
    }
}

-(void) did_swiped_right
{
    if (self.swipeRightBlock)
    {
        self.swipeRightBlock(self);
    }
}

-(void) did_swiped_down
{
    if (self.swipeDownBlock)
    {
        self.swipeDownBlock(self);
    }
}

-(void) did_swiped_left
{
    if (self.swipeLeftBlock)
    {
        self.swipeLeftBlock(self);
    }
}

-(void)swipe:(UIViewSwipeDirection)direction action:(UIViewSwipeBlock)block
{
    switch (direction)
    {
        case UIViewSwipeDirectionUp:
            [self setSwipeUpBlock:block];
            break;
        case UIViewSwipeDirectionRight:
            [self setSwipeRightBlock:block];
            break;
        case UIViewSwipeDirectionDown:
            [self setSwipeDownBlock:block];
            break;
        case UIViewSwipeDirectionLeft:
            [self setSwipeLeftBlock:block];
            break;
        default:
            break;
    }
}

-(BOOL)swipe_remove:(UIViewSwipeDirection)direction
{
    switch (direction)
    {
        case UIViewSwipeDirectionUp:
            [self removeGestureRecognizer:self.swipeGestureUp];
            break;
        case UIViewSwipeDirectionRight:
            [self removeGestureRecognizer:self.swipeGestureRight];
            break;
        case UIViewSwipeDirectionDown:
            [self removeGestureRecognizer:self.swipeGestureDown];
            break;
        case UIViewSwipeDirectionLeft:
            [self removeGestureRecognizer:self.swipeGestureLeft];
            break;
        default:
            break;
    }
    return YES;
}


#pragma mark - SET & GET blocks
-(void)setswipeUpBlock:(UIViewSwipeBlock)swipeUpBlock
{
    if (swipeUpBlock)
    {
        if (self.swipeGestureUp == nil)
        {
            UISwipeGestureRecognizer * swipe_up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(did_swiped_up)];
            [swipe_up setDirection:UISwipeGestureRecognizerDirectionUp];
            [self setSwipeGestureUp:swipe_up];
        }
        if ([self.gestureRecognizers containsObject:self.swipeGestureUp] == NO)
        {
            [self addGestureRecognizer:self.swipeGestureUp];
        }
        objc_setAssociatedObject(self, "swipeUpBlock",swipeUpBlock, OBJC_ASSOCIATION_COPY);
    }
}
-(UIViewSwipeBlock)swipeUpBlock
{
    return (UIViewSwipeBlock)objc_getAssociatedObject(self,"swipeUpBlock");
}


-(void)setSwipeRightBlock:(UIViewSwipeBlock)swipeRightBlock
{
    if (swipeRightBlock)
    {
        if (self.swipeGestureRight == nil)
        {
            UISwipeGestureRecognizer * swipe_right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(did_swiped_right)];
            [swipe_right setDirection:UISwipeGestureRecognizerDirectionRight];
            [self setSwipeGestureRight:swipe_right];
        }
        if ([self.gestureRecognizers containsObject:self.swipeGestureRight] == NO)
        {
            [self addGestureRecognizer:self.swipeGestureRight];
        }
        objc_setAssociatedObject(self, "swipeRightBlock",swipeRightBlock, OBJC_ASSOCIATION_COPY);
    }
}
-(UIViewSwipeBlock)swipeRightBlock
{
    return (UIViewSwipeBlock)objc_getAssociatedObject(self,"swipeRightBlock");
}


-(void)setswipeDownBlock:(UIViewSwipeBlock)swipeDownBlock
{
    if (swipeDownBlock)
    {
        if (self.swipeGestureDown == nil)
        {
            UISwipeGestureRecognizer * swipe_down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(did_swiped_down)];
            [swipe_down setDirection:UISwipeGestureRecognizerDirectionDown];
            [self setSwipeGestureDown:swipe_down];
        }
        if ([self.gestureRecognizers containsObject:self.swipeGestureDown] == NO)
        {
            [self addGestureRecognizer:self.swipeGestureDown];
        }
        objc_setAssociatedObject(self, "swipeDownBlock",swipeDownBlock, OBJC_ASSOCIATION_COPY);
    }
}
-(UIViewSwipeBlock)swipeDownBlock
{
    return (UIViewSwipeBlock)objc_getAssociatedObject(self,"swipeDownBlock");
}


-(void)setSwipeLeftBlock:(UIViewSwipeBlock)swipeLeftBlock
{
    if (swipeLeftBlock)
    {
        if (self.swipeGestureLeft == nil)
        {
            UISwipeGestureRecognizer * swipe_left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(did_swiped_left)];
            [swipe_left setDirection:UISwipeGestureRecognizerDirectionLeft];
            [self setSwipeGestureLeft:swipe_left];
        }
        if ([self.gestureRecognizers containsObject:self.swipeGestureLeft] == NO)
        {
            [self addGestureRecognizer:self.swipeGestureLeft];
        }
        
        objc_setAssociatedObject(self, "swipeLeftBlock",swipeLeftBlock, OBJC_ASSOCIATION_COPY);
    }
}
-(UIViewSwipeBlock)swipeLeftBlock
{
    return (UIViewSwipeBlock)objc_getAssociatedObject(self,"swipeLeftBlock");
}

#pragma mark - SETER + GETER for Gesture
-(void)setSwipeGestureUp:(UISwipeGestureRecognizer *) gesture
{
    if (gesture)
    {
        objc_setAssociatedObject(self, "swipeGestureUp",gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
-(UISwipeGestureRecognizer *)swipeGestureUp
{
    return (UISwipeGestureRecognizer *)objc_getAssociatedObject(self,"swipeGestureUp");
}


-(void)setSwipeGestureRight:(UISwipeGestureRecognizer *) gesture
{
    if (gesture)
    {
        objc_setAssociatedObject(self, "swipeGestureRight",gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
-(UISwipeGestureRecognizer *)swipeGestureRight
{
    return (UISwipeGestureRecognizer *)objc_getAssociatedObject(self,"swipeGestureRight");
}


-(void)setSwipeGestureDown:(UISwipeGestureRecognizer *) gesture
{
    if (gesture)
    {
        objc_setAssociatedObject(self, "swipeGestureDown",gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
-(UISwipeGestureRecognizer *)swipeGestureDown
{
    return (UISwipeGestureRecognizer *)objc_getAssociatedObject(self,"swipeGestureDown");
}

-(void)setSwipeGestureLeft:(UISwipeGestureRecognizer *) gesture
{
    if (gesture)
    {
        objc_setAssociatedObject(self, "swipeGestureLeft",gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
-(UISwipeGestureRecognizer *)swipeGestureLeft
{
    return (UISwipeGestureRecognizer *)objc_getAssociatedObject(self,"swipeGestureLeft");
}
@end
