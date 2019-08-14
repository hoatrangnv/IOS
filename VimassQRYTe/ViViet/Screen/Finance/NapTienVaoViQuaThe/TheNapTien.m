//
//  TheNapTien.m
//  ViViMASS
//
//  Created by DucBui on 4/20/15.
//
//

#import "TheNapTien.h"

@implementation TheNapTien

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSString *idBank = [dict valueForKey:@"idBank"];
        NSString *idTheBankNet = [dict valueForKey:@"idTheBankNet"];
        NSString *linkAnh = [dict valueForKey:@"linkAnh"];
        NSNumber *doDai = [dict valueForKey:@"doDai"];

        
        if(idBank)
        {
            self.idBank = idBank;
        }
        else
        {
            self.idBank = @"";
        }
        
        if(idTheBankNet)
        {
            self.idTheBankNet = idTheBankNet;
        }
        else
        {
            self.idTheBankNet = @"";
        }
        
        if(linkAnh)
        {
            self.linkAnh = linkAnh;
        }
        else
        {
            self.linkAnh = @"";
        }
        
        if(doDai)
        {
            self.doDai = doDai;
        }
        else
        {
            self.doDai = [NSNumber numberWithInt:-1];
        }
        
    }
    return self;
}

- (void)dealloc
{
    [_idBank release];
    [_idTheBankNet release];
    [_linkAnh release];
    [_doDai release];

    [super dealloc];
}
@end
