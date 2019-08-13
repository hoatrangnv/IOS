//
//  ContactScreen.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 8/7/19.
//

#import "ContactScreen.h"
#import "Contact.h"
#import "PhoneContacts.h"
#import "Static.h"
#import "Common.h"
#import "SVPullToRefresh.h"
#import "ContactViewCell.h"
#import "LocalizationSystem.h"
#import <Contacts/Contacts.h>
@interface ContactScreen (){
    MBProgressHUD *hud;
}

@property (nonatomic, retain) NSMutableArray *mDanhSachLienHe;
@property (nonatomic, retain) NSArray *firstChars;

@end

@implementation ContactScreen
{
    void (^_onSelect)(NSString *phone, Contact *contact);
    
    //    NSMutableArray *_firstChars;        // First character in the contact. May depends on region.
    NSMutableDictionary *_contacts;     // Contact in each category.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _mKieuHienThiLienHe = KIEU_HIEN_THI_LIEN_HE_THUONG;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    if (_isShowTitle) {
    UITextField *viewTop = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
    viewTop.placeholder = @"Thêm số điện thoại";
    viewTop.layer.cornerRadius = 5;
    viewTop.keyboardType = UIKeyboardTypePhonePad;
        [viewTop setBackgroundColor:[UIColor whiteColor]];
        self.navigationItem.titleView = viewTop;
        
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Xong" style:UIBarButtonItemStyleDone target:self action:@selector(suKienChonAddSDT)];
        self.navigationItem.rightBarButtonItem = rightBtn;
//    }

    UITextField *tfSearch = [_searchBar valueForKey:@"_searchField"];
    tfSearch.leftView = nil;
    
    [self loadDanhBa];
}

- (void)suKienChonAddSDT {
    UITextField *tfSDT = (UITextField *)self.navigationItem.titleView;
    NSLog(@"%s - tfSDT : %@", __FUNCTION__, tfSDT.text);
    Contact *newContact = [[Contact alloc] initWithPhone:tfSDT.text firstName:@"" lastName:@"" recordID:@""];
    if (_onSelect)
    {
        _onSelect ([self formatPhoneNumer:newContact.phone],newContact);
        
    }
}

- (void)hienThiLoadingLayDanhBaNew {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [Localization languageSelectedStringForKey:@"dang_lay_danh_ba"];
}

- (void)anLoadingNew {
    [hud hideUsingAnimation:YES];
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
    
    
    __block ContactScreen *weak = self;
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
                [weak->_tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
                [weak.tableView reloadData];
                weak.isLoading = NO;
            });
        }];
    });
}

#pragma mark - Search delegate

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    NSLog(@"%s - searchText : %@", __FUNCTION__, searchText);
//    [self classifyFromContacts:self.mDanhSachLienHe withKeyword:[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    NSLog(@"%s - searchText : %@", __FUNCTION__, searchText);
    [self classifyFromContacts:self.mDanhSachLienHe withKeyword:[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self classifyFromContacts:self.mDanhSachLienHe withKeyword:@""];
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

- (NSString *)formatPhoneNumer:(NSString *)phone
{
    NSString *p = [phone stringByReplacingOccurrencesOfString:@"+84" withString:@"0"];
    return p;
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

- (void)dealloc {
    [_searchBar release];
    [_tableView release];
    [super dealloc];
}
@end
