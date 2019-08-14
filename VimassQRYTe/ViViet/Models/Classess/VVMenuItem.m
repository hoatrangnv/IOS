//
//  VVMenuItem.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 11/23/12.
//
//

#import "VVMenuItem.h"

@implementation VVMenuItem

+(NSMutableArray *) itemsFromArray:(NSArray *)data
{
    int cnt = (int)data.count/2;
    NSMutableArray *items = [[[NSMutableArray alloc] initWithCapacity:cnt] autorelease];
    for (int i = 0; i < cnt; i++)
    {
        VVMenuItem *it = [[VVMenuItem new]autorelease];
        it.name = [data objectAtIndex:2*i];
        it.price = ((NSNumber *)[data objectAtIndex:2*i+1]).doubleValue;
        [items addObject:it];
    }
    
    return items;
}

-(id)initWithArray:(NSArray *)data
{
    if (self = [super init])
    {
        if ([data isKindOfClass:[NSArray class]])
        {
            self.name = [data objectAtIndex:0];
            self.price = ((NSNumber *)[data objectAtIndex:1]).intValue;
        }
    }
    return self;
}

-(void)dealloc
{
    self.name = nil;
    
    [super dealloc];
}

@synthesize name;
@synthesize price;
@synthesize selected;
@synthesize qty;

@end
