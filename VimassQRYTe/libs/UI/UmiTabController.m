//
//  UmiTabController.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 10/24/13.
//
//

#import "UmiTabController.h"

@interface UmiTabController ()
@property (nonatomic, readonly) CGRect frame;
@end

@implementation UmiTabController
{
    id<UmiTabControllerDelegate> delegate;
    int selected_tab;
}

- (CGRect)frame
{
    return self.container.bounds;
}

- (void)setDelegate:(id<UmiTabControllerDelegate>)delegate1
{
    if (delegate != delegate1)
    {
        delegate = delegate1;
    }
}

- (void)setSelected_tab:(int)index
{
    if (index != selected_tab)
    {
        if ([delegate respondsToSelector:@selector(UmiTabController:will_select_tab:)] && NO == [delegate UmiTabController:self will_select_tab:index])
            return;
        
        UIViewController *current_vc = nil;
        if (selected_tab >= 0)
            current_vc = [self.view_controllers objectAtIndex:selected_tab];
            
        UIViewController *next_vc = [self.view_controllers objectAtIndex:index];
        
        next_vc.view.frame = self.frame;
        
        
        if (current_vc)
        {
            [current_vc viewWillDisappear:NO];
            [current_vc.view removeFromSuperview];
            [current_vc viewDidDisappear:NO];
        }
        
        [next_vc viewWillAppear:NO];
        [self.container addSubview:next_vc.view];
        [next_vc viewDidAppear:NO];
        
        selected_tab = index;
        if ([delegate respondsToSelector:@selector(UmiTabController:did_select_tab:)])
            [delegate UmiTabController:self did_select_tab:selected_tab];
    }
}
- (id)init
{
    if (self = [super init])
    {
        selected_tab = -1;
    }
    return self;
}
-(void)dealloc
{
    self.view_controllers = nil;
    [super dealloc];
}

@synthesize delegate = delegate;
@synthesize selected_tab = selected_tab;
@synthesize view_controllers;

@end
