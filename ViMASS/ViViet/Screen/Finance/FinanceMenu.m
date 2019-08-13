//
//  FinanceMenu.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 2/15/14.
//
//

#import "FinanceMenu.h"
#import "ActionItem.h"
#import "GridActionData.h"
#import "FinanceMenuCell.h"
#import "LoginViewController.h"
#import "Common.h"
#import "ViTokenViewController.h"
#import "LoginController.h"
#import "UnregisterTokenViewController.h"
#import "RegisterTokenViewController.h"

@interface FinanceMenu ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) ActionItem *root;
@property (nonatomic, assign) ActionItem *submenu;
@end

@implementation FinanceMenu
{
    IBOutlet UIView *_content;
    IBOutlet UIButton *v_btnMember;
    IBOutlet UIButton *v_btnCorp;
    IBOutlet UITableView *v_menu;
    IBOutlet UITableView *v_submenu;
    
    BOOL _personal;
}

- (IBAction)didSelectMember:(id)sender
{
    if (v_btnMember.selected == YES)
        return;
    
    v_btnMember.selected = YES;
    v_btnCorp.selected = NO;
}

- (IBAction)didSelectCorp:(id)sender
{
    [UIAlertView alert:@"Under development".localizableString withTitle:nil block:nil];
    return;
    if (v_btnCorp.selected == YES)
        return;
    
    v_btnMember.selected = NO;
    v_btnCorp.selected = YES;
}

- (void)reloadData
{
    self.root = [GridActionData vimass_menu_item_with_id:@"tai_chinh"];
}

- (void)hideSubmenu;
{
    [self hideSubmenu:nil];
    
}

- (void)hideSubmenu:(void (^)(void))callback;
{
    UIView *v = v_submenu.superview;
    void (^cb)(void) = nil;
    if (callback)
        cb = [callback copy];
    
    [UIView animateWithDuration:0.15 animations:^
    {
        v.transform = CGAffineTransformMakeScale(0.8, 0.8);
        v.alpha = 0;
    }
    completion:^(BOOL finished)
    {
        if (cb)
        {
            cb ();
            [cb release];
        }
    }];
}

- (void)performAction:(ActionItem *)item
{
    [self hideSubmenu:^
    {
        [self doAction:item];
    }];
}

- (void)doAction:(ActionItem *)item
{
    if (self.delegate && item.selector != nil && item.selector.length > 0 && [self.delegate respondsToSelector:NSSelectorFromString(item.selector)])
    {
        [self.delegate performSelector:NSSelectorFromString(item.selector) withObject:item];
        return;
    }

    __block FinanceMenu *SELF = self;
    //
    // Check login requirement
    //
    if (item.checkLogin.boolValue == YES && (current_account == nil || current_account.length == 0))
    {
        [LoginController loginForFinance:YES callback:^(BOOL logined, id model)
        {
            if (logined)
                [SELF doAction:item];
        }];
        
        return;
    }
    //
    // Contain view controller that process the action
    //
    if (item.viewController != nil && [Common isEmptyString:item.viewController] == NO)
    {
        Class klass = NSClassFromString(item.viewController);
        if (klass != nil)
        {
            if ([item.viewController compare:@"ViTokenViewController"] == NSOrderedSame)
            {
                ViTokenViewController *vc = [[[ViTokenViewController alloc] initWithNibName:@"ViTokenViewController" bundle:nil] autorelease];
                
                [vc register_token_with_phone:current_account];
                UIViewController *host = self.delegate;
                [host presentModalViewController:vc animated:YES];
                return;
            }
            
            __block NSString *display = [item.display copy];
            
            NSMutableDictionary *dic = (NSMutableDictionary *)item.params;
            if (item.ID != nil && item.ID.length > 0)
            {
                dic = [NSMutableDictionary dictionaryWithDictionary:item.params];
                [dic setObject:item.ID forKey:@"ID"];
            }
            
            [klass create_with_params:dic oncreate:^(BaseScreen *view_controller)
             {
                 UIViewController *host = SELF.delegate;
                 if (display && [display compare:ACTION_ITEM_DISPLAY_PRESENT] == NSOrderedSame)
                     [host presentModalViewController:view_controller animated:YES];
                 else
                     [host.navigationController pushViewController:view_controller animated:YES];
                 
                 [display release];
             }];
            
            return;
        }
    }
    
    BaseScreen *host = self.delegate;
    [host alert:@"@Under development" withTitle:nil block:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1)
        [self hideSubmenu];
}

- (void)showSubmenuOfItem:(ActionItem *)item
{
    self.submenu = item;
    UIView *v_animate = v_submenu.superview;
    //
    // Khong hieu sao phai reset bang lenh duoi day. Neu khong thi kich thuoc tinh duoc
    // cua table se bi sai.
    //
    v_animate.transform = CGAffineTransformIdentity;
    
    int index = [self.root.childs indexOfObject:item];
    UITableViewCell *ce = [v_menu cellForRowAtIndexPath: [NSIndexPath indexPathForItem:index inSection:0]];
    CGRect r_initial = [ce convertRect:ce.bounds toView:v_animate.superview];
    r_initial.origin.x = 0;
    r_initial.size.width = r_initial.size.height;
    
    // Tinh frame cua table se hien thi ra
    
    CGRect r_end = v_animate.frame;
    r_end.origin.y = r_initial.origin.y < 0 ? 0 : r_initial.origin.y;
    r_end.size.height = item.childs.count * v_submenu.rowHeight;
    CGFloat maxHeight = v_menu.frame.size.height;
    if (r_end.size.height > maxHeight)
    {
        r_end.size.height = maxHeight;
    }
    
    if (r_end.origin.y + r_end.size.height > maxHeight)
    {
        r_end.origin.y = maxHeight - r_end.size.height;
    }
    
    
    v_animate.frame = r_end;
    v_animate.alpha = 0;
    [v_submenu reloadData];
    
    CGAffineTransform mtx = CGAffineTransformIdentity;
    
    mtx = CGAffineTransformTranslate(mtx,
                                     -(r_end.origin.x + r_end.size.width/2 - r_initial.origin.x - r_initial.size.width/2),
                                     -(r_end.origin.y + r_end.size.height/2 - r_initial.origin.y - r_initial.size.height/2));
    
    mtx = CGAffineTransformScale(mtx,
                                 r_initial.size.width / r_end.size.width,
                                 r_initial.size.height / r_end.size.height);
    
    
    v_animate.transform = mtx;
    [UIView animateWithDuration:0.2 animations:^{
        
        v_animate.transform = CGAffineTransformIdentity;
        v_animate.alpha = 1;
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block ActionItem *item = nil;
    __block FinanceMenu *SELF = self;
    if (tableView.tag == 1)
    {
        item = [self.root.childs objectAtIndex:indexPath.row];
    }
    else
    {
        item = [self.submenu.childs objectAtIndex:indexPath.row];
    }
    
    if (tableView.tag == 2 ||
        (tableView.tag == 1 && (item.childs == nil || item.childs.count == 0)))
    {
        return [self performAction:item];
    }
//    if ([@"bao_cmn_mat" compare:item.ID] == NSOrderedSame)
//    {
//        if (current_account == nil || current_account.length == 0)
//        {
//            [LoginController loginForFinance:YES callback:^(BOOL logined, id model)
//             {
//                 if (!logined)
//                     return;
//                 ActionItem *tmp = [item.childs objectAtIndex:1];
//                 tmp.title = hard_token_available == YES ? LocalizedString(@"home - unbind hard token") : LocalizedString(@"home - register hard token");
//                 
//                 tmp.viewController = hard_token_available == YES ? NSStringFromClass([UnregisterTokenViewController class]) : NSStringFromClass([RegisterTokenViewController class]);
//                 
//                 [SELF showSubmenuOfItem:item];
//             }];
//            return;
//        }
//    }
    if (tableView.tag == 1 && item.childs && item.childs.count > 0)
    {
        [self showSubmenuOfItem:item];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (tableView.tag == 1)
    {
        return self.root.childs.count;
    }
    
    return self.submenu.childs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ActionItem *item = nil;
    FinanceMenuCell *ce = nil;
    
    ce = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d", tableView.tag]];
    if (!ce)
    {
        ce = [FinanceMenuCell createWithLevel:tableView.tag - 1];
    }
    
    if (tableView.tag == 1)
    {
        item = [self.root.childs objectAtIndex:indexPath.row];
        ce.item = [self.root.childs objectAtIndex:indexPath.row];
    }
    else
    {
        item = [self.submenu.childs objectAtIndex:indexPath.row];
        ce.item = [self.submenu.childs objectAtIndex:indexPath.row];
    }
    
    return ce;
}

- (void)init_FinanceMenu
{
    self.root = [GridActionData vimass_menu_item_with_id:@"tai_chinh"];
    
    [self initAutoLocalizeView];
    [self localizeViews];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        _content.frame = self.bounds;
        [self addSubview:_content];
        
        [self init_FinanceMenu];
    }
    return self;
}


- (void)dealloc
{
    self.root = nil;
    [_content release];
    [v_btnCorp release];
    [v_btnMember release];
    [v_menu release];
    [v_submenu release];
    [super dealloc];
}

@end
