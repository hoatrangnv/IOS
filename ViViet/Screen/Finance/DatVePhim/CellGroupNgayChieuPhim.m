//
//  CellGroupNgayChieuPhim.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 12/9/15.
//
//

#import "CellGroupNgayChieuPhim.h"

@implementation CellGroupNgayChieuPhim

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfView = [[NSBundle mainBundle] loadNibNamed:@"CellGroupNgayChieuPhim" owner:self options:nil];
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
    [_lblTime release];
    [super dealloc];
}
@end
