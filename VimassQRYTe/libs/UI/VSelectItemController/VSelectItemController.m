//
//  SelectItemController.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/4/12.
//
//

#import "VSelectItemController.h"
#import "VSelectItemViewCell.h"
#import "VSelectItemView.h"
#import "SideViewController.h"

@interface VSelectItemController ()<UITableViewDelegate>

@property (nonatomic, retain) SideViewController *side_ctrl;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSString *title;

@end

@implementation VSelectItemController
{
    BOOL (^callback)(VSelectItemController *ctrl, int index, int state);
    
}
- (id)initWithData:(NSMutableArray *)data title:(NSString *)title
{
    if (self = [super init])
    {
        self.data = data;
        self.title = title;
    }
    return self;
}

- (void)initVSelectItemController
{
    
}
- (void)close;
{
    [self.side_ctrl close_animate:NO];
}
- (void)close:(void (^)())finished
{
    finished = [finished copy];
    [self.side_ctrl close_animate:YES callback:^(SideViewController *controller) {
        if (finished)
        {
            finished();
        }
        [finished release];
    }];
}

- (void)select_in_view:(UIView *)view
              callback:(BOOL (^)(VSelectItemController *ctrl, int index, int state))callback1;

{
    callback = [callback1 copy];
    
    self.side_ctrl = [[SideViewController new] autorelease];
    
    VSelectItemView *v_select = [VSelectItemView create];
    v_select.data = self.data;
    v_select.table.delegate = self;
    
    self.side_ctrl.left = v_select;
    self.side_ctrl.main = view;
    
    [self.side_ctrl open_side:-1 animate:YES];
}

#pragma mark - Tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (callback == nil)
        return;
    
    if (NO == callback (self, (int)indexPath.row, VSelectItemController_StateWillSelect))
        return;
    
    __block VSelectItemController * SELF = self;
    [self.side_ctrl close_animate:YES callback:^(SideViewController *controller)
    {
        SELF->callback (SELF, (int)indexPath.row, VSelectItemController_StateWillSelected);
    }];
}

#pragma mark - Cleaning

- (void) dealloc
{
    self.side_ctrl = nil;
    
    if (callback != nil)
        [callback release];
    
    self.data = nil;
    self.title = nil;
    [super dealloc];
}

@synthesize data = _data;
@synthesize title = _title;
@synthesize side_ctrl;

@end
