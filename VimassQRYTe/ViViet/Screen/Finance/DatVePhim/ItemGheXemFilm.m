//
//  ItemGheXemFilm.m
//  ViViMASS
//
//  Created by nguyen tam on 9/17/15.
//
//

#import "ItemGheXemFilm.h"

@implementation ItemGheXemFilm

- (void)khoiTaoGhe:(NSDictionary *)dic{
    NSString *statusHien = [dic objectForKey:@"hien"];
    if (statusHien) {
        self.hienThi = statusHien;
    }
    else
        self.hienThi = @"0";
    
    NSString *statusVip = [dic objectForKey:@"vip"];
    if (statusVip) {
        self.vip = statusVip;
    }
    else
        self.vip = @"0";
    
    NSString *statusSTT = [dic objectForKey:@"stt"];
    if (statusSTT) {
        self.stt = statusSTT;
    }
    else
        self.stt = @"0";
    
    int statusTT = [[dic objectForKey:@"trangthai"] intValue];
    self.trangthai = statusTT;
    
    NSString *statusGia = [dic objectForKey:@"gia"];
    if (statusGia) {
//        NSLog(@"%s - statusGia : %@", __FUNCTION__, statusGia);
        self.gia = statusGia;
    }
    else
        self.gia = @"0";

    NSString *sIdTemp = [dic objectForKey:@"id"];
    if (sIdTemp) {
        self.sId = sIdTemp;
    }
    else
        self.sId = @"";

    NSString *sType = [dic objectForKey:@"type"];
    if (sType) {
        self.type = sType;
    }
    else
        self.type = @"";

    NSString *sName = [dic objectForKey:@"name"];
    if (sName) {
        self.name = sName;
    }
    else {
        self.name = @"";
    }
}

@end
