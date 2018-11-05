//
//  ItemChonGheCGV.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 7/4/16.
//
//

#import "ItemChonGheCGV.h"

@implementation ItemChonGheCGV

- (id)init {
    self = [super init];
    if(self)
    {
        self.arrGheChon = [[NSMutableArray alloc] init];
        self.isChon = NO;
        self.nGiaTri = -1;
    }
    return self;
}

- (NSString *)convertJSON {
    
}

@end
