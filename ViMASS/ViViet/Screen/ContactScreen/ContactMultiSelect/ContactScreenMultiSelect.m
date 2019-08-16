//
//  ContactScreen.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on December 15, 2012
//  Copyright (c) 2012 Vi Viet corp. All rights reserved.
//

#import "ContactScreenMultiSelect.h"
#import "Contact.h"
#import "PhoneContacts.h"
#import "Static.h"
#import "Common.h"
#import "SVPullToRefresh.h"
#import "ContactViewCellMultiSelect.h"
#import "LocalizationSystem.h"
#import "CustomNavigationTitleView.h"
#import "CustomViewSearch.h"
#import <Contacts/Contacts.h>
@interface ContactScreenMultiSelect ()<CustomNavigationTitleViewDelegate>
{
    IBOutlet CustomViewSearch *SearchView;
    CustomNavigationTitleView * titleCustom;
    MBProgressHUD *hud;
}
@property (nonatomic, retain) NSMutableArray *mDanhSachLienHe;
@property (nonatomic, retain) NSArray *firstChars;
@property (nonatomic, strong) NSMutableArray * multiSelectContact;
@end

@implementation ContactScreenMultiSelect
{
    void (^_onSelect)(NSString *phone, Contact *contact);
    void (^_multiSelect)(NSMutableArray * contacts);
//    NSMutableArray *_firstChars;        // First character in the contact. May depends on region.
    NSMutableDictionary *_contacts;     // Contact in each category.
}

- (void)selectContact: (void (^)(NSString *phone, Contact *contact)) onSelect_
{
    [_onSelect release];
    _onSelect = [onSelect_ copy];
}
- (void)selectMulticontact: (void (^)(NSMutableArray * contacts)) multiSelect {
    [_multiSelect release];
    _multiSelect = [multiSelect copy];
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
//    [self hienThiLoadingLayDanhBa];
    NSLog(@"%s -------------------> START", __FUNCTION__);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self hienThiLoadingLayDanhBa];
//    });
    
    UITextField *tfSearch = [_searchBar valueForKey:@"_searchField"];
    tfSearch.leftView = nil;
    
    _multiSelectContact = [[NSMutableArray alloc] init];
    [self khoiTaoBanDau];
    [self loadDanhBa];
//    if (app.global.loadContactSuccess == NO)
//    {
//        self.isLoading = YES;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thread_loadContact_success:) name:@"thread_loadContact" object:nil];
//    }
//    else
//    {
//        NSLog(@"%s - line : %d - loadContactSuccess == YES", __FUNCTION__, __LINE__);
//        self.isLoading = NO;
//        if(_mKieuHienThiLienHe == KIEU_HIEN_THI_LIEN_HE_THUONG)
//        {
//            self.mDanhSachLienHe = app.global.contacts;
//        }
//        else if(_mKieuHienThiLienHe == KIEU_HIEN_THI_LIEN_HE_MUON_TIEN)
//        {
//            self.mDanhSachLienHe = app.global.mDanhSachLienHeDaCoVi;
//        }
//        NSLog(@"%s - line : %d - self.mDanhSachLienHe.count : %ld", __FUNCTION__, __LINE__, self.mDanhSachLienHe.count);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self anLoading];
//            [self classifyFromContacts:self.mDanhSachLienHe withKeyword:nil];
//            [self.tableView reloadData];
//        });
//    }
}

- (void)hienThiLoadingLayDanhBaNew {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [Localization languageSelectedStringForKey:@"dang_lay_danh_ba"];
}

- (void)anLoadingNew {
    [hud hideUsingAnimation:YES];
}

- (void)loadDanhBa {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hienThiLoadingLayDanhBaNew];
    });
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Để lấy danh bạ, vui lòng cho phép ứng dụng được quyền truy cập vào danh bạ của bạn." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:TRUE completion:nil];
        return;
    }
    
    
    __block ContactScreenMultiSelect *weak = self;
    weak.isLoading = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // user didn't grant access;
                    // so, again, tell user here why app needs permissions in order  to do it's job;
                    // this is dispatched to the main queue because this request could be running on background thread
                });
                return;
            }
            
            // build array of contacts
            
            NSMutableArray *contacts = [NSMutableArray array];
            
            NSError *fetchError;
            CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactIdentifierKey, [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName], CNContactPhoneNumbersKey]];
            
            BOOL success = [store enumerateContactsWithFetchRequest:request error:&fetchError usingBlock:^(CNContact *contact, BOOL *stop) {
                [contacts addObject:contact];
            }];
            
            
            
            if (!success) {
                NSLog(@"HomeCenterViewController - %s - fetchError : %@", __FUNCTION__, fetchError);
                [weak anLoadingNew];
                weak.isLoading = NO;
                return;
            }
            
            NSLog(@"HomeCenterViewController - %s - contacts : %ld", __FUNCTION__, (long)contacts.count);
            
            // you can now do something with the list of contacts, for example, to show the names
            
            CNContactFormatter *formatter = [[CNContactFormatter alloc] init];
            
            for (CNContact *contact in contacts) {
                NSString *sName = [formatter stringFromContact:contact];
                NSArray <CNLabeledValue<CNPhoneNumber *> *> *phoneNumbers = contact.phoneNumbers;
                for (CNLabeledValue<CNPhoneNumber *> *firstPhone in phoneNumbers) {
                    CNPhoneNumber *number = firstPhone.value;
                    NSString *digits = number.stringValue;
                    if (digits.length > 0) {
                        Contact *newContact = [[Contact alloc] initWithPhone:digits
                                                                   firstName:sName
                                                                    lastName:@""
                                                                    recordID:@""];
                        if (!self.mDanhSachLienHe) {
                            self.mDanhSachLienHe = [[NSMutableArray alloc] init];
                        }
                        [self.mDanhSachLienHe addObject:newContact];
                    }
                }
            }
            NSLog(@"HomeCenterViewController - %s - self.mDanhSachLienHe : %ld", __FUNCTION__, (long)self.mDanhSachLienHe.count);
            [weak classifyFromContacts:weak.mDanhSachLienHe withKeyword:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weak anLoadingNew];
                [weak->tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
                weak.isLoading = NO;
                [self classifyFromContacts:self.mDanhSachLienHe withKeyword:nil];
                [self.tableView reloadData];
                [weak.tableView reloadData];
                
            });
        }];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self khoiTaoSearchBar];
//    self.searchDC = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
//
//    self.searchDisplayController.searchResultsDataSource = self;
//    self.searchDisplayController.searchResultsDelegate = self;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
//    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (void)hienThiLoadingLayDanhBa {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [Localization languageSelectedStringForKey:@"dang_lay_danh_ba"];
}

#pragma mark - khoiTao

- (void)khoiTaoSearchBar
{
//    self.searchBar.autocorrectionType = UITextAutocorrectionTypeYes;
//    [self.searchBar setPlaceholder:LocalizedString(@"Search")];
//    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
}

- (void)khoiTaoBanDau
{
    NSLog(@"%s - line : %d ============> START", __FUNCTION__, __LINE__);
    [self addTitleView:[@"Contact" localizableString]];
    UIBarButtonItem *btnLeft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(suKienChonBack:)];
    btnLeft.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    self.navigationItem.leftBarButtonItem = btnLeft;
    
//    [self addButtonRight];
    [self initTitleViewNavigationbar];
    SearchView.delegate = self;
//    [self addButton:@"refresh64" selector:@selector(suKienBamNutRefresh:) atSide:1];
    
    __block ContactScreenMultiSelect *weak = self;
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

- (void)suKienChonBack:(UIButton *)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)initTitleViewNavigationbar {
//    titleCustom = [[CustomNavigationTitleView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
//    titleCustom.delegate = self;
//    self.navigationItem.titleView = titleCustom;
    
    UITextField *viewTop = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
    viewTop.placeholder = @"Thêm số điện thoại";
    viewTop.layer.cornerRadius = 5;
    viewTop.keyboardType = UIKeyboardTypePhonePad;
    [viewTop setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.titleView = viewTop;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Xong" style:UIBarButtonItemStyleDone target:self action:@selector(suKienChonAddSDT)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)suKienChonAddSDT {
    UITextField *tfSDT = (UITextField *)self.navigationItem.titleView;
    if (![tfSDT.text isEmpty]) {
        Contact *newContact = [[Contact alloc] initWithPhone:tfSDT.text firstName:@"" lastName:@"" recordID:@""];
        [_multiSelectContact addObject:newContact];
    }
    if (_multiSelect)
    {
        _multiSelect(_multiSelectContact);
    }
}

- (void)addButtonRight {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Xong" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(buttonRightClick) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];

    UIBarButtonItem *negativeSeperator = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        negativeSeperator.width = -15;
        [button.widthAnchor constraintEqualToConstant:30].active = YES;
        [button.heightAnchor constraintEqualToConstant:30].active = YES;
    }
    else
        negativeSeperator.width = -10;

    self.navigationItem.rightBarButtonItems = @[rightItem];

}
#pragma mark -  CustomNavigationTitleViewDelegate
- (void)textFieldDidBeginEditing {
    SearchView.txtSearch.text = @"";
    SearchView.txtSearch.rightView = nil;
    [SearchView.txtSearch endEditing:true];
    [self classifyFromContacts:self.mDanhSachLienHe withKeyword:nil];
    [tableView reloadData];
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
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self anLoading];
        [tableView reloadData];
    });
}

- (void)anLoading {
    [hud hide:YES];
}

- (NSString *)formatPhoneNumer:(NSString *)phone
{
    NSString *p = [phone stringByReplacingOccurrencesOfString:@"+84" withString:@"0"];
    return p;
}

#pragma mark - Search delegate

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    [self classifyFromContacts:self.mDanhSachLienHe withKeyword:[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    [self classifyFromContacts:self.mDanhSachLienHe withKeyword:[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self classifyFromContacts:self.mDanhSachLienHe withKeyword:@""];
}

#pragma mark - Events
- (void)buttonRightClick {
    [self.view endEditing:YES];
    if ([titleCustom isHasText]) {
        // to add number contact to address
        __block ContactScreenMultiSelect *weak = self;
        weak.isLoading = YES;
        [PhoneContacts addNewNumberToContact:titleCustom.txtAddNumber.text completion:^{
            weak->titleCustom.txtAddNumber.text = @"";
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
        }];
        
    } else {
        // back to view
        if (_multiSelect) {
            _multiSelect(_multiSelectContact);
        }
    }
}
-(void) buttonBackClicked:(id) sender
{
    if (_onSelect)
    {
        _onSelect (@"",@"");
    }
}

- (void)suKienBamNutRefresh:(id)sender
{
    __block ContactScreenMultiSelect *weak = self;
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
    
    ContactViewCellMultiSelect *cell = (ContactViewCellMultiSelect *)[tableView1 dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) 
    {
        NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"ContactViewCellMultiSelect" owner:nil options:nil];
        cell = (ContactViewCellMultiSelect *)[views lastObject];
    }
    
    NSString *key = [_firstChars objectAtIndex:indexPath.section];
    NSArray *sect = [_contacts objectForKey:key];
    Contact *ct = [sect objectAtIndex:indexPath.row];
    BOOL isSelected = [_multiSelectContact containsObject:ct];
    [cell setContact:ct isSelected:isSelected];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self anLoading];
    });
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
    if (![_multiSelectContact containsObject:ct]) {
        [_multiSelectContact addObject:ct];
    } else {
        [_multiSelectContact removeObject:ct];
    }
    [titleCustom.txtAddNumber endEditing:YES];
    [self textFieldDidBeginEditing];
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tbl heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 54.0;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tbl
{
    return _firstChars;
}

// header in section view + title + height
- (UIView *)tableView:(UITableView *)tbl viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tbl.frame.size.width, 32.0)];
    view.backgroundColor = [UIColor lightGrayColor];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 50, 32)];
    lbl.text = [_firstChars objectAtIndex:section];
    lbl.textColor = [UIColor blackColor];
    lbl.backgroundColor = [UIColor lightGrayColor];
    lbl.font = [UIFont boldSystemFontOfSize:15];
    lbl.backgroundColor = [UIColor clearColor];
    
    //    [view addSubview:img];
    [view addSubview:lbl];
    
    [lbl release];
    //    [img release];
    return [view autorelease];
}
-(CGFloat)tableView:(UITableView *)tbl heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

#pragma mark - CustomSearchDelegate
- (void)refresh {
    __block ContactScreenMultiSelect *weak = self;
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
- (void)searchContact:(NSString*)text {
    if (text.length == 0) {
        [self.view endEditing:true];
    }
    [self classifyFromContacts:self.mDanhSachLienHe withKeyword:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    [tableView reloadData];
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
//    [searchBar release];
    [SearchView release];
    [super dealloc];
}

//@synthesize searchBar;
@synthesize tableView;
//@synthesize searchDC;

@end
