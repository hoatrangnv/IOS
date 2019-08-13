//
//  TableLoadMoreCell.m
//  ViMASS
//
//  Created by Chung NV on 6/10/13.
//
//

#import "TableLoadMoreCell.h"

@implementation TableLoadMoreCell
+(CGFloat)height
{
    return 42.0f;
}
+(NSString *)identify
{
    return NSStringFromClass([self class]);
}
-(void)setData:(id)data
{
    
}

+(CGFloat) heightWithData:(id)data
{
    return 44.0f;
}

@end
