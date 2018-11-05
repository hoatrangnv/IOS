//
//  ContactScreen.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on December 15, 2012
//  Copyright (c) 2012 Vi Viet corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiaoDichViewController.h"
#import "AppDelegate.h"
#import "Contact.h"

#define KIEU_HIEN_THI_LIEN_HE_THUONG 1100
#define KIEU_HIEN_THI_LIEN_HE_MUON_TIEN 1101 

@interface ContactScreen : GiaoDichViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    UITableView *tableView;
}

@property (nonatomic, assign) NSInteger mKieuHienThiLienHe;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) UISearchDisplayController *searchDC;

- (void)selectContact: (void (^)(NSString *phone)) onSelect;

@end
