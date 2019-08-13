//
//  DoiTuongPhuongXa.m
//  ViViMASS
//
//  Created by DucBui on 7/13/15.
//
//

#import "DoiTuongPhuongXa.h"

@implementation DoiTuongPhuongXa

- (id)initWithDict:(NSDictionary*)dict
{
    self = [super initWithDict:dict];
    if(self)
    {
        NSString *tenPhuongXa = [dict valueForKey:@"tenPhuongXa"];
        if(tenPhuongXa)
            self.mTen = tenPhuongXa;
        else
            self.mTen = @"";
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
