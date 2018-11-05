//
//  DropdownList.m
//  ViMASS
//
//  Created by Chung NV on 7/25/13.
//
//

#import "DropdownList.h"
#import <QuartzCore/QuartzCore.h>

@implementation DropdownList
{
    CGRect showRect;
    CGRect hideRect;
    
    BOOL waitAnimate;
}
-(BOOL)isShow
{
    return self.hidden == NO;
}
-(void) showUnderView:(UIView *) underView
               inView:(UIView *) showInView;
{
    CGFloat offset = 5.f;
    
    if (waitAnimate)
        return;
    
    if (underView == nil)
        return;
    if (showInView == nil)
        showInView = underView.superview;
    if (showInView == nil)
        return;
    
    CGRect showFrame = showRect;
    
    CGRect r = [underView convertRect:underView.bounds toView:showInView];
    r.origin.y += underView.bounds.size.height + offset;
    showFrame.origin.y = r.origin.y;
    hideRect.origin.y = r.origin.y;

    
//    CGRect showFrame = showRect;
//    float oy = underView.frame.origin.y + underView.frame.size.height + offset;
//    showFrame.origin.y = oy;
//    hideRect.origin.y = oy;
    
    self.frame = hideRect;
    self.hidden = YES;
    if ([showInView.subviews containsObject:self] == NO)
        [showInView addSubview:self];
    
    [showInView bringSubviewToFront:self];
    
    waitAnimate = YES;
    __block DropdownList *weakSelf = self;
    
#ifdef SHOW_DROP_ANIMATE
    
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.frame = showFrame;
        weakSelf.hidden = NO;
    } completion:^(BOOL finished) {
        waitAnimate = NO;
    }];
#else
    
    weakSelf.frame = showFrame;
    weakSelf.hidden = NO;
    waitAnimate = NO;
    
#endif
}

-(void)hide
{
    if (waitAnimate)
        return;
    
#ifdef SHOW_DROP_ANIMATE
    
    waitAnimate = YES;
    __block DropdownList *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.frame = hideRect;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
        waitAnimate = NO;
    }];
#else
    
    self.hidden = YES;
    
#endif
}


-(void)didSelectedItem:(DropdownListDidSelectItem)didSelecteItem
{
    [_didSelecteItem release];
    _didSelecteItem = [didSelecteItem copy];
}

#pragma mark - Delegate & Datasource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didSelecteItem)
    {
        int index = (int)indexPath.row;
        _didSelecteItem(index,[_source objectAtIndex:index]);
    }
    [self hide];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = _source ? _source.count : 0;
    return number;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DropdownList"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DropdownList"];
        
        if (self.textfield != nil)
        {
            cell.textLabel.textColor = self.textfield.textColor;
            cell.textLabel.font = self.textfield.font;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 3;
        }
    }
    NSString * txt = [_source objectAtIndex:indexPath.row];
    cell.textLabel.text = txt;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Neu text dai hon 1 dong thi tinh lai chieu cao. Nguoc lai lay 44.0f
    NSString *txt = [self.source objectAtIndex:indexPath.row];
    if (txt != nil)
    {
        CGSize sz_bounds = CGSizeMake(300, 99999);
        CGSize sz = [txt sizeWithFont:self.textfield.font constrainedToSize:sz_bounds lineBreakMode:NSLineBreakByWordWrapping];
        
        if (sz.height > 44)
            return sz.height;
        
    }
    return 44.0f;
}


#pragma mark - Init
-(void) _init
{
    self.dataSource = self;
    self.delegate = self;
    self.hidden = YES;
    showRect = self.frame;
    hideRect = self.frame;
    hideRect.size.height = 2;
    
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [[UIColor blackColor] CGColor];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self _init];
    }
    return self;
}

-(id) init
{
    if (self = [super init])
    {
        [self _init];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self _init];
    }
    return self;
}
-(void)dealloc
{
    self.textfield = nil;
    [_didSelecteItem release];
    [_source release];
    
    [super dealloc];
    
}

@end
