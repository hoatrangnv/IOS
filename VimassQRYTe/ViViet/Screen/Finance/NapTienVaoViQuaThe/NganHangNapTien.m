//
//  NganHangNapTien.m
//  ViViMASS
//
//  Created by DucBui on 4/20/15.
//
//

#import "NganHangNapTien.h"
#import "TheNapTien.h"
#import "JSONKit.h"

@implementation NganHangNapTien

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSString *tenBank = [dict valueForKey:@"tenBank"];
        NSNumber *trangThaiDirect = [dict valueForKey:@"trangThaiDirect"];
        NSArray *danhSachTheNapTien = [dict valueForKey:@"danhSach"];
        if(tenBank)
        {
            self.tenBank = tenBank;
        }
        else
            self.tenBank = @"";
        
        if(trangThaiDirect)
        {
            self.trangThaiDirect = trangThaiDirect;
        }
        else
        {
            self.trangThaiDirect = [NSNumber numberWithInt:-1];
        }
        
        NSMutableArray *danhSach = [[NSMutableArray alloc] init];
        if(danhSachTheNapTien)
        {
            for(NSDictionary *dict in danhSachTheNapTien)
            {
                TheNapTien *theNapTien = [[TheNapTien alloc] initWithDictionary:dict];
                [danhSach addObject:theNapTien];
                [theNapTien release];
            }
            self.danhSachTheNapTien = danhSach;
        }
        else
        {
            self.danhSachTheNapTien = danhSach;
        }
        [danhSach release];
    }
    return self;
}


+ (NSArray*)layDanhSachNganHangNapTien
{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jsonNapTienTheBank" ofType:@"txt"]];
    NSDictionary *dict = [data objectFromJSONData];
    NSArray *banks = [dict valueForKey:@"bank"];
    if(banks)
    {
        NSMutableArray *temp = [[[NSMutableArray alloc] initWithCapacity:banks.count] autorelease];
        for(NSDictionary *dictBank in banks)
        {
            NganHangNapTien *objNganHangNapTien = [[NganHangNapTien alloc] initWithDictionary:dictBank];
            [temp addObject:objNganHangNapTien];
            [objNganHangNapTien release];
        }
//        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"tenBank" ascending:YES selector:@selector(caseInsensitiveCompare:)];
//        NSArray *sortArray = [temp sortedArrayUsingDescriptors:@[sort]];
        return temp;
    }
    return nil;
}

- (void)dealloc
{
    [_trangThaiDirect release];    
    [_tenBank release];
    [_danhSachTheNapTien release];
    [super dealloc];
}

@end
