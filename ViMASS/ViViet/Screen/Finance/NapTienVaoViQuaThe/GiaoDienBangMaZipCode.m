//
//  GiaoDienBangMaZipCode.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/12/15.
//
//

#import "GiaoDienBangMaZipCode.h"

@interface GiaoDienBangMaZipCode ()

@end

@implementation GiaoDienBangMaZipCode

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zipcode" ofType:@"txt"]];

    NSString *sXauHtml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self.webZipCode loadHTMLString:sXauHtml baseURL:nil];
    [sXauHtml release];
}

- (void)dealloc {
    [_webZipCode release];
    [super dealloc];
}
@end
