//
//  HorizontalTableViewCell.m
//  ViMASS
//
//  Created by Chung NV on 5/29/13.
//
//

#import "HorizontalTableViewCell.h"

@implementation HorizontalTableViewCell
+(NSString *) identify
{
    return NSStringFromClass([self class]);
}
+(CGFloat) height
{
    return 44.0;
}
-(void)setData:(id)data
{
    
}
-(void)setDataWithJSON:(NSString *)JSON
{
    
}

-(void)_init
{
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity,M_PI_2);
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self _init];
    }
    return self;
}
-(id)init
{
    if (self = [super init])
    {
        [self _init];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self _init];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self _init];
    }
    return self;
}

- (void)setActive:(BOOL)isActive {
    //Abstract
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat) heightWithData:(id)data
{
    return 44.0f;
}

+ (CGFloat)heightWithDatas:(NSArray *)datas atIndexPath:(NSIndexPath *)indexpath
{
    return 44.0f;
}

@end
