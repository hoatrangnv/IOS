//
//  SelectItemController.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/4/12.
//
//

#import "SelectItemController.h"
#import "SelectItemViewCell.h"
#import "ExSearchBar.h"
#define kAnimateTime 0.3
#define kBlackMargin 0

@interface SelectItemController ()
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, copy) NSString *title;
@end

@implementation SelectItemController
{
    void (^_onFinish)(int index, bool didSelected);
    BOOL (^callback)(SelectItemController *view, int index, int flag);
    // Views
    UITableView *_table;
    UIView *_container;
    UIView *leftbar;
    UILabel *_lbTitle;
    // Data
    NSMutableArray *_data;
    NSMutableArray *_data_search;
    NSString *_title;
    int _selectedIndex;
    BOOL isFilter;
}

- (void) show: (void (^)(int index, bool didSelected))onFinish
{
    _onFinish = [onFinish copy];
    [super show];
}

- (void)shows:(BOOL (^)(SelectItemController *view, int index, int flag))callback_;
{
    callback = [callback_ copy];
    [super show];
}

// Override
- (void)didDismiss
{
    if (callback)
    {
        callback (self, _selectedIndex, SelectItemController_DidSelect);
        return;
    }
    
    _onFinish (_selectedIndex, _selectedIndex >= 0);
}
- (void)will_dismiss
{
    if (callback != nil)
        callback (self, _selectedIndex, SelectItemController_WillSelect);
}

#pragma mark - Specific implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (callback != nil && NO == callback (self, (int)indexPath.row, SelectItemController_ItemSelected))
    {
        return;
    }
    
    if (isFilter)
    {
        NSString *item = [_data_search objectAtIndex:indexPath.row];
        _selectedIndex = (int)[_data indexOfObject:item];
    }else
        _selectedIndex = (int)indexPath.row;
    
    [self dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFilter)
    {
        return _data_search.count;
    }
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"Select Item View Cell";
    SelectItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectItemViewCell" owner:nil options:nil];
        cell = (SelectItemViewCell *)[nib objectAtIndex:0];
    }
    if (isFilter)
        cell.lblText.text = [_data_search objectAtIndex:indexPath.row];
    else
        cell.lblText.text = [_data objectAtIndex:indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar
   textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
        isFilter = NO;
    else
    {
        isFilter = YES;
        if (!_data_search)
            _data_search = [[NSMutableArray alloc] init];
        [_data_search removeAllObjects];
        
        for (NSString * item in _data)
        {
            NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchText];
            BOOL match =  [regex evaluateWithObject:item];
            if(match)
                [_data_search addObject:item];
        }
    }
    [_table reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.window.frame.size;
    NSLog(@"size: %f", size.height);
    CGRect fr = self.bounds;
    fr.origin.y = 20;
    fr.size = size;
    fr.size.height -= 20; // status_bar (Pin bar)
    
    self.frame = fr;
    
    CGRect r = self.bounds;
    r.origin = CGPointZero;
    _table.frame = r;
    _container.frame = r;
}

- (void)initSelectItemController
{
    self.backgroundColor = [UIColor whiteColor];
    
    _container = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
    _container.userInteractionEnabled = YES;
    
    _table = [[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain] autorelease];
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.frame = CGRectMake(0, 0, 0, 0);
    [_container addSubview:_table];
//    if (!_searchBar)
//    {
//        self.searchBar = [[ExSearchBar alloc] initWithFrame:CGRectMake(0,
//                                                                   0,
//                                                                   320,
//                                                                   44)];
//        self.searchBar.autocorrectionType = UITextAutocorrectionTypeYes;
//        [self.searchBar setPlaceholder:LocalizedString(@"Search")];
//        self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        
//        _searchBar.delegate = self;
//        _searchBar.showsCancelButton = NO;
//        [_container addSubview:_searchBar];
//    }
    
    
    /*UIImageView *topbar = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-bg"]] autorelease];
    topbar.frame = CGRectMake(0, 0, 320, 44);
    [self addSubview:topbar];
    
    _lbTitle = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
    _lbTitle.font = [UIFont boldSystemFontOfSize:18];
    _lbTitle.textColor = [UIColor whiteColor];
    _lbTitle.backgroundColor = [UIColor clearColor];
    _lbTitle.text = _title;
    _lbTitle.textAlignment = UITextAlignmentCenter;
    _lbTitle.numberOfLines = 0;
    
//    [_container addSubview:_lbTitle];
    */
    [self addSubview:_container];
}

- (id) initWithData: (NSMutableArray *)data title:(NSString *)title;
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 460)])
    {
        _selectedIndex = -1;
        self.data = data;
        self.title = title;
        [self initSelectItemController];
    }
    return self;
}

- (void) dealloc
{
    if (callback != nil)
        [callback release];
    
    [_onFinish release];
    self.data = nil;
    self.title = nil;
    self.searchBar = nil;
    [super dealloc];
}

@synthesize data = _data;
@synthesize title = _title;
@end
