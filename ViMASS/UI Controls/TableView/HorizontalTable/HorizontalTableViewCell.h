//
//  HorizontalTableViewCell.h
//  ViMASS
//
//  Created by Chung NV on 5/29/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JSONKit.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
@interface HorizontalTableViewCell : UITableViewCell

+(NSString *) identify;
+(CGFloat) height;
+(CGFloat) heightWithData:(id)data;
+(CGFloat) heightWithDatas:(NSArray *)datas atIndexPath:(NSIndexPath *) indexpath;

-(void) setData:(id) data;
-(void) setDataWithJSON:(NSString *)JSON;
-(void) setActive:(BOOL)isActive; //TAG: HOANGPH 26/03/2013 Su dung trong ExHorizontalTableview
@end
