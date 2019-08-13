//
//  DoiTuongGiaoDichTheoLo.m
//  ViViMASS
//
//  Created by DucBui on 6/25/15.
//
//

#import "DoiTuongGiaoDichTheoLo.h"
#import "DoiTuongChiTietGiaoDichTheoLo.h"
#import "JSONKit.h"

@implementation DoiTuongGiaoDichTheoLo

- (id)initWithDict:(NSDictionary*)dict
{
    self = [super initWithDict:dict];
    if(self)
    {
        NSArray *dsGiaoDich = [dict valueForKey:@"dsGiaoDich"];
        if(dsGiaoDich)
        {
            NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
            for(NSDictionary *dictGD in dsGiaoDich)
            {
                DoiTuongChiTietGiaoDichTheoLo *doiTuongChiTiet = [[DoiTuongChiTietGiaoDichTheoLo alloc] initWithDict:dictGD];
                [temp addObject:doiTuongChiTiet];
                [doiTuongChiTiet release];
            }
            self.mDsGiaoDich = temp;
        }
        else
        {
            self.mDsGiaoDich = [NSArray new];
        }
        NSString *linkFile = [dict valueForKey:@"linkFile"];
        if(linkFile)
            self.linkFile = linkFile;
        else
            self.linkFile = @"";
        
        NSNumber *total = [dict valueForKey:@"total"];
        if(total)
            self.total = total;
        else
            self.total = [NSNumber numberWithLong:0];
    }
    return self;
}

- (NSString*)layChiTietHienThi
{
    NSMutableString *sXauHTML = [[[NSMutableString alloc] init] autorelease];
    
    return sXauHTML;
}



- (void)dealloc
{
    [_linkFile release];
    [_mDsGiaoDich release];
    [_total release];
    [super dealloc];
}

@end
