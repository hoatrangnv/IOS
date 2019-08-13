//
//  DoiTuongQuanHuyen.m
//  ViViMASS
//
//  Created by DucBui on 7/13/15.
//
//

#import "DoiTuongQuanHuyen.h"

@implementation DoiTuongQuanHuyen

- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSString *tenQuanHuyen = [dict valueForKey:@"tenQuanHuyen"];
        if(tenQuanHuyen)
            self.mTen = tenQuanHuyen;
        else
            self.mTen = @"";
        
        NSArray *dsPhuongXa = [dict valueForKey:@"dsPhuongXa"];
        if(dsPhuongXa)
        {
            NSMutableArray *tempPhuongXa = [[NSMutableArray alloc] initWithCapacity:dsPhuongXa.count];
            for(NSDictionary *dictPhuongXa in dsPhuongXa)
            {
                DoiTuongPhuongXa *doiTuongPhuongXa = [[DoiTuongPhuongXa alloc] initWithDict:dictPhuongXa];
                [tempPhuongXa addObject:doiTuongPhuongXa];
                [doiTuongPhuongXa release];
            }
            self.dsPhuongXa = tempPhuongXa;
            [tempPhuongXa release];
        }
        else
            self.dsPhuongXa = [NSArray new];
        
    }
    return self;
}

- (void)dealloc
{
    if (_dsPhuongXa) {
        [_dsPhuongXa release];    
    }
    [super dealloc];
}
@end
