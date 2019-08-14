//
//  ObjectItemChuyenTienAnDanh.m
//  ViViMASS
//
//  Created by Mac Mini on 11/2/18.
//

#import "ObjectItemChuyenTienAnDanh.h"

@implementation ObjectItemChuyenTienAnDanh
-(NSDictionary*)toDict
{
    return @{@"sdt":self.sdt,@"tenHienThi":self.tenHienThi,@"soTien":[NSNumber numberWithDouble: self.soTien],@"fee":[NSNumber numberWithDouble: self.fee]};
}
@end
