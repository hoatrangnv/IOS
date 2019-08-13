//
//  NganHangGuiTietKiem.m
//  ViViMASS
//
//  Created by DucBui on 5/13/15.
//
//

#import "NganHangGuiTietKiem.h"
#import "JSONKit.h"

@implementation NganHangGuiTietKiem

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSString *bank = [dict valueForKey:@"bank"];
        if(bank)
            self.bank = bank;
        else
            self.bank = @"";
        NSString *maNganHang = [dict valueForKey:@"maNganHang"];
        if(maNganHang)
            self.maNganHang = maNganHang;
        else
            self.maNganHang = @"";
        
        NSArray *dsKyHan = [dict valueForKey:@"kyHan"];
        if(dsKyHan)
        {
            NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithCapacity:dsKyHan.count];
            for (NSDictionary *dictTemp in dsKyHan)
            {
                KyHanNganHang *kyHan = [[KyHanNganHang alloc] initWithDictionary:dictTemp];
                [arrTemp addObject:kyHan];
                [kyHan release];
            }
            self.mDanhSachKyHan = arrTemp;
            [arrTemp release];
        }
        else
        {
            self.mDanhSachKyHan = [NSArray new];
        }
    }
    return self;
}

+ (NSArray*)layDanhSachNganHangGuiTietKiem:(NSDictionary*)dict
{
    NSArray *dsNganHangGuiTietKiem = [dict valueForKey:@"danhSach"];
    if(dsNganHangGuiTietKiem)
    {
        NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:dsNganHangGuiTietKiem.count];
        for (NSDictionary *dict in dsNganHangGuiTietKiem)
        {
            NganHangGuiTietKiem *nganHangGuiTietKiem = [[NganHangGuiTietKiem alloc] initWithDictionary:dict];
            [temp addObject:nganHangGuiTietKiem];
            [nganHangGuiTietKiem release];
        }
        NSArray *arrTraVe = [NSArray arrayWithArray:temp];
        NSLog(@"%s - arrTraVe : %ld", __FUNCTION__, (unsigned long)arrTraVe.count);
        [temp release];
        return arrTraVe;
    }
    return nil;
}

- (NSString *)layBangLaiSuatHtml
{
    
    NSMutableString *strLaiSuat = [[[NSMutableString alloc] init] autorelease];
    for (KyHanNganHang *kyHan in _mDanhSachKyHan) {
        [strLaiSuat appendString:[kyHan layCotLaiSuatTheoKiHan]];
    }
    return [NSString stringWithFormat:@"<p style=\"text-align:center\"><strong>Lãi suất %@</strong></p><table style=\"font-family: arial; font-size: 12px; border: 1px solid #007aba; border-collapse: collapse; text-align: center;\" width=\"98%%\" border=\"1\" bordercolor=\"#007aba\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\"><tbody><tr style=\"color: #fff; text-align: center; background-color:#1870AF;\"><th width=\"143\">Kỳ hạn</th><th width=\"155\">Lãi cuối kỳ</th></tr>%@</tbody></table>", _bank, strLaiSuat];
}


- (void)dealloc
{
    [_laiKhongKyHan release];
    [_mDanhSachKyHan release];
    [_bank release];
    [_maNganHang release];
    [super dealloc];
}

@end
