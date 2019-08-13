//
//  CellGioChieuPhim.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/9/15.
//
//

#import "CellGioChieuPhim.h"

@implementation CellGioChieuPhim

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfView = [[NSBundle mainBundle] loadNibNamed:@"CellGioChieuPhim" owner:self options:nil];
        if ([arrayOfView count] < 1) {
            return nil;
        }

        if (![[arrayOfView objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }

        self = [arrayOfView objectAtIndex:0];
    }
    return self;
}

- (void)dealloc {
    [_lblGio release];
    [super dealloc];
}
@end
