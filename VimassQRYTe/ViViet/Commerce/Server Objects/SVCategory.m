//
//  SVCategory.m
//  ViMASS
//
//  Created by Chung NV on 5/31/13.
//
//

#import "SVCategory.h"

@implementation SVCategory
-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.showSubCate = NO;
        self.ID = [[dict objectForKey:@"catId"] intValue];
        self.name = [dict objectForKey:@"name"];
        NSArray * subs_arr = [dict objectForKey:@"subs"];
        if (subs_arr != nil && subs_arr.count > 0)
        {
            NSMutableArray *subs = [NSMutableArray new];
            for (NSDictionary *sub_dict in subs_arr)
            {
                SVCategory *sub_cate = [[SVCategory alloc] initWithDictionary:sub_dict];
                [subs addObject:sub_cate];
            }
            self.subs = subs;
            [subs release];
        }
    }
    return self;
}

-(void)dealloc
{
    [_name release];
    [_subs release];
    [super dealloc];
}
@end
