//
//  HomeScreen.m
//  CameraUploadApp
//
//  Created by QUANGHIEP on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeScreen.h"
#import "LoginScreen.h"
//#import "ListingDisplayScreen.h"

#import "MoneySendScreen.h"
#import "Static.h"
#import "SignInScreen.h"
#import "ServiceResults.h"
#import "Msg.h"
#import "AccountScreen.h"
#import "LocalizationSystem.h"
@interface HomeScreen ()

@end

@implementation HomeScreen
#pragma mark
#pragma mark init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        modelInterface = [[ModelInterfaces alloc] init];
        NSArray *object1 = [NSArray arrayWithObjects:AMLocalizedString(@"Giao dịch", nil), AMLocalizedString(@"Thực hiện gửi và nhận tiền trong tài khoản", nil), nil];
        NSArray *object2 = [NSArray arrayWithObjects:AMLocalizedString(@"Sao kê", nil), AMLocalizedString(@"Xem lịch sử giao dịch", nil), nil];
        NSArray *object3 = [NSArray arrayWithObjects:AMLocalizedString(@"Xem số dư", nil), AMLocalizedString(@"Số tiền còn trong tài khoản",nil), nil];
        dataToTable = [[NSMutableArray alloc] initWithObjects:object1, object2, object3,  nil];
    }
    return self;
}
- (void) dealloc
{
    [dataToTable release];
    [modelInterface release];
    [super dealloc];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self setStyleForTitleViewWithFontSize:0];
//    LoginScreen *loginScreen = [[LoginScreen alloc] initWithNibName:@"LoginScreen" bundle:nil];
//    [self presentModalViewController:loginScreen animated:YES];
//    [loginScreen release];
    [self addButtonLogOut];
    [self addButtonLeftHidden];

}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshBanner];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
#pragma mark
#pragma mark handle Notification
- (void) handleNotificationSignin:(NSNotification *) notification
{
    NSString * object = [notification object];
    if ([object isEqualToString:NOTIFI_SIGNUP]) {
           [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFI_SIGNUP object:nil];
        SignInScreen * screen = [[SignInScreen alloc] initWithNibName:@"SignInScreen" bundle:nil];
//        [self presentModalViewController:screen animated:YES];
        [[self navigationController] pushViewController:screen animated:YES];
        [screen release];
    }
    else if([object isEqualToString:NOTIFI_SIGNUPED])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFI_SIGNUP object:nil];
        LoginScreen *loginScreen = [[LoginScreen alloc] initWithNibName:@"LoginScreen" bundle:nil];
        [self presentModalViewController:loginScreen animated:YES];
        [loginScreen release];
    }
}

#pragma mark - Action
//- (void) logout:(id) sender
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString([NSString stringWithFormat:@"%@:", @"notificationLogout"]) name:NOTIFI_LOGOUT object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_LOGOUT object:nil];
//    [[self navigationController] popToRootViewControllerAnimated:NO];
//}
#pragma mark - AlerView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"cancel");
            break;
        }
        case 1:
        {
            NSLog(@"OK");
            [self showLoadingScreen];
            NSString * pass = [[NSUserDefaults standardUserDefaults] objectForKey:PINCODE];
            UITextField * textField = (UITextField *)[alertView viewWithTag:100];
            NSString * otp = [textField text];
            [modelInterface confirmTransactionWithObServer:self andOTP:otp andPassword:pass andOutputMethodName:@"confirmOTP"];
            break;
        }
        default:
            break;
    }
    
}
- (void) confirmOTP:(NSNotification *) notification
{
    [self hideLoadingScreen];
    ServiceResults * serviceResult = [notification object];
    NSString *observer = [serviceResult sObServer];
    Msg *msg = [serviceResult msgRespone];
    [self removeObserver:observer];
    NSString *sStatusResult = [serviceResult sStatusResult];
//    if ([self checkRequestWithNotificationTitle:sStatusResult] == NO) {
//        return;
//    }
    //    if ([[msg msgCode] isEqual:NOTIFI_TRANSFERMONEY_SUCCESS]) {
    if (![[msg msgCode] isEqual:NOTIFI_TRANSFERMONEY_SUCCESS]) {
        [self showScreenWithNibName:@"CurrentBalanceScreen" andAnimator:YES];
    }
    else {
        [self showAlertScreenAndContentWithCodeMess:[msg msgCode]];
    }
}
#pragma mark - TableView
- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataToTable count];    
}

- (UITableViewCell*)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    if ([dataToTable count] <= 0) 
        return cell;
    
    NSArray *arr  = [dataToTable objectAtIndex:indexPath.row];
    cell.textLabel.text = [arr objectAtIndex:0];
    cell.detailTextLabel.text = [arr objectAtIndex:1];
    cell.detailTextLabel.numberOfLines = 0;
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"icon1.png"];
    }
    else if (indexPath.row == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"icon2.png"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"icon3.png"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    //        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self showScreenWithNibName:@"MoneyTransferBetweenAccMainScreen"  andAnimator:YES];
    }
    else if (indexPath.row == 1)
    {
       [self showScreenWithNibName:@"HistoryTransactionScreen" andAnimator:YES];
    }
    else
    {
         [self showOTPConfirm];
    }
}

@end
