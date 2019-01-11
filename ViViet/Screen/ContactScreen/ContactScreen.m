//
//  ContactScreen.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on December 15, 2012
//  Copyright (c) 2012 Vi Viet corp. All rights reserved.
//

#import "ContactScreen.h"
#import "Contact.h"
#import "PhoneContacts.h"
#import "Static.h"
#import "Common.h"
#import "SVPullToRefresh.h"
#import "ContactViewCell.h"
#import "LocalizationSystem.h"

@interface ContactScreen ()

@property (nonatomic, retain) NSArray *mDanhSachLienHe;
@property (nonatomic, retain) NSArray *firstChars;

@end

@implementation ContactScreen
{
    void (^_onSelect)(NSString *phone, Contact *contact);
    
//    NSMutableArray *_firstChars;        // First character in the contact. May depends on region.
    NSMutableDictionary *_contacts;     // Contact in each category.
}

- (void)selectContact: (void (^)(NSString *phone, Contact *contact)) onSelect_
{
    [_onSelect release];
    _onSelect = [onSelect_ copy];
}

#pragma mark - Contact helpers

- (NSMutableArray *) getFirstChars
{
    return [[[NSMutableArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil] autorelease];
}

- (void)classifyFromContacts: (NSArray *)all withKeyword:(NSString *)keyword
{
    NSMutableArray *_category = [self getFirstChars];
    
    if (_contacts)
        [_contacts removeAllObjects];
    else
        _contacts = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    for (Contact *ct in all)
    {
        NSString *fullName = ct.fullName;
        if (keyword != nil && keyword.length > 0)
        {
            if (([ct.fullName likeString:keyword] || [ct.phone likeString:keyword]) == NO)
                continue;
        }
        
        NSString *first = fullName.length > 0 ? [fullName substringToIndex:1] : @"";
        BOOL found = NO;
        int sectIndex = 0;
        
        for (NSString *ch in _category)
        {
            if ([first compare:ch options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch] == NSOrderedSame)
            {
                first = ch;
                found = YES;
                break;
            }
            sectIndex++;
        }
        if (!found) first = @"#";
        
        NSMutableArray * section = [_contacts objectForKey:first];
        if (section == nil)
        {
            section = [[NSMutableArray alloc] initWithCapacity:1];
            [_contacts setObject:section forKey:first];
            [section release];
        }
        [section addObject:ct];
    }
    
    self.firstChars = [NSArray arrayWithArray:[[_contacts allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        return [(NSString *)obj1 compare:(NSString *)obj2 options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch];
    }]];
}

#pragma mark - Views hierarchy


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (app.global.loadContactSuccess == NO)
    {
        self.isLoading = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thread_loadContact_success:) name:@"thread_loadContact" object:nil];
    }
    else
    {
        if(_mKieuHienThiLienHe == KIEU_HIEN_THI_LIEN_HE_THUONG)
        {
            self.mDanhSachLienHe = app.global.contacts;
        }
        else if(_mKieuHienThiLienHe == KIEU_HIEN_THI_LIEN_HE_MUON_TIEN)
        {
            self.mDanhSachLienHe = app.global.mDanhSachLienHeDaCoVi;
        }
        [self.tableView reloadData];
        [self classifyFromContacts:self.mDanhSachLienHe withKeyword:nil];
    }
    [self khoiTaoBanDau];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self khoiTaoSearchBar];
    self.searchDC = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
    
	self.searchDisplayController.searchResultsDataSource = self;
	self.searchDisplayController.searchResultsDelegate = self;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

#pragma mark - khoiTao

- (void)khoiTaoSearchBar
{
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeYes;
    [self.searchBar setPlaceholder:LocalizedString(@"Search")];
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
}

- (void)khoiTaoBanDau
{
//    self.title = [@"Contact" localizableString];
    NSLog(@"%s - line : %d ============> START", __FUNCTION__, __LINE__);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hienThiLoadingLayDanhBa];
    });
    [self addTitleView:[@"Contact" localizableString]];
    [self addBackButton:YES];
    [self addButton:@"refresh64" selector:@selector(suKienBamNutRefresh:) atSide:1];
    
    __block ContactScreen *weak = self;
    [tableView addPullToRefreshWithActionHandler:^
     {
         weak.isLoading = YES;
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             [weak->app.global refreshContacts];
             if(weak.mKieuHienThiLienHe == KIEU_HIEN_THI_LIEN_HE_THUONG)
             {
                 weak.mDanhSachLienHe = weak->app.global.contacts;
             }
             else if(weak.mKieuHienThiLienHe == KIEU_HIEN_THI_LIEN_HE_MUON_TIEN)
             {
                 weak.mDanhSachLienHe = weak->app.global.mDanhSachLienHeDaCoVi;
             }
             [weak classifyFromContacts:weak.mDanhSachLienHe withKeyword:nil];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weak->tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
                 [weak.tableView reloadData];
                 weak.isLoading = NO;
             });
         });
         return ;
     }];
}

#pragma mark - xuLy

-(void)thread_loadContact_success:(NSNotification *)noti
{
    if(_mKieuHienThiLienHe == KIEU_HIEN_THI_LIEN_HE_THUONG)
    {
        self.mDanhSachLienHe = app.global.contacts;
    }
    else if(_mKieuHienThiLienHe == KIEU_HIEN_THI_LIEN_HE_MUON_TIEN)
    {
        self.mDanhSachLienHe = app.global.mDanhSachLienHeDaCoVi;
    }
    
    [self classifyFromContacts:self.mDanhSachLienHe withKeyword:nil];
    self.isLoading = NO;
    [tableView reloadData];
}

- (NSString *)formatPhoneNumer:(NSString *)phone
{
    NSString *p = [phone stringByReplacingOccurrencesOfString:@"+84" withString:@"0"];
    return p;
}

#pragma mark - Search delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self classifyFromContacts:self.mDanhSachLienHe withKeyword:[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self classifyFromContacts:self.mDanhSachLienHe withKeyword:@""];
}

#pragma mark - Events

-(void) buttonBackClicked:(id) sender
{
    if (_onSelect)
    {
        _onSelect (@"",@"");
    }
}

- (void)suKienBamNutRefresh:(id)sender
{
    __block ContactScreen *weak = self;
    weak.isLoading = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weak->app.global refreshContacts];
        if(weak.mKieuHienThiLienHe == KIEU_HIEN_THI_LIEN_HE_THUONG)
        {
            weak.mDanhSachLienHe = weak->app.global.contacts;
        }
        else if(weak.mKieuHienThiLienHe == KIEU_HIEN_THI_LIEN_HE_MUON_TIEN)
        {
            weak.mDanhSachLienHe = weak->app.global.mDanhSachLienHeDaCoVi;
        }
        [weak classifyFromContacts:weak.mDanhSachLienHe withKeyword:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weak->tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
            [weak.tableView reloadData];
            weak.isLoading = NO;
        });
    });

}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ContactCell";
    
    ContactViewCell *cell = (ContactViewCell *)[tableView1 dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) 
    {
        NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"ContactViewCell" owner:nil options:nil];
        cell = (ContactViewCell *)[views lastObject];
    }
    
    NSString *key = [_firstChars objectAtIndex:indexPath.section];
    NSArray *sect = [_contacts objectForKey:key];
    Contact *ct = [sect objectAtIndex:indexPath.row];
    [cell setContact:ct];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tbl numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [_firstChars objectAtIndex:section];
    return ((NSArray *)[_contacts objectForKey:key]).count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tbl
{
    return _firstChars.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tbl didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [_firstChars objectAtIndex:indexPath.section];
    NSArray *sect = [_contacts objectForKey:key];
    Contact *ct = [sect objectAtIndex:indexPath.row];
    
    if (_onSelect)
    {
        _onSelect ([self formatPhoneNumer:ct.phone],ct);
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tbl heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [ContactViewCell height];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tbl
{
    return _firstChars;
}

// header in section view + title + height
- (UIView *)tableView:(UITableView *)tbl viewForHeaderInSection:(NSInteger)section
{
    CGRect r = CGRectMake(0, 0, 320, 20);
    UIView *view = [[UIView alloc] initWithFrame:r];
    view.backgroundColor = [UIColor lightGrayColor];
    
    //    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    //    img.image = [Common stretchImage:@"section_header_bg"];
    r.origin.x = 10;
    r.size.width = 300;
    UILabel *lbl = [[UILabel alloc] initWithFrame:r];
    lbl.text = [_firstChars objectAtIndex:section];
    lbl.textColor = [UIColor blackColor];
    lbl.backgroundColor = [UIColor lightGrayColor];
    lbl.font = [UIFont boldSystemFontOfSize:14];
    lbl.backgroundColor = [UIColor clearColor];
    
    //    [view addSubview:img];
    [view addSubview:lbl];
    
    [lbl release];
    //    [img release];
    return [view autorelease];
}
-(CGFloat)tableView:(UITableView *)tbl heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


#pragma mark - dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(_mDanhSachLienHe)
        [_mDanhSachLienHe release];
    if(_firstChars)
        [_firstChars release];
    [_contacts release];
    [_onSelect release];
    
    [tableView release];
    [searchBar release];
    [super dealloc];
}

@synthesize searchBar;
@synthesize tableView;
@synthesize searchDC;

@end
