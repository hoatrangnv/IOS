//
//  GiaoDienDieuKhoanCongTy.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/24/15.
//
//

#import "GiaoDienDieuKhoanCongTy.h"

@interface GiaoDienDieuKhoanCongTy ()

@end

@implementation GiaoDienDieuKhoanCongTy

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Điều khoản";
    [self addBackButton:YES];
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"dieukhoanchinhsach" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webDieuKhoan loadHTMLString:htmlString baseURL:nil];
}

- (void)dealloc {
    [_webDieuKhoan release];
    [super dealloc];
}
@end
