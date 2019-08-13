//
//  TableLoadMoreCell.h
//  ViMASS
//
//  Created by Chung NV on 6/10/13.
//
//


@class TableLoadMoreCell;
@protocol TableMoreCellDelegate <NSObject>

-(void) tableLoadMoreCell:(TableLoadMoreCell *)cell didClickedView:(UIView *) view;

@end
#import <UIKit/UIKit.h>

@interface TableLoadMoreCell : UITableViewCell

#pragma mark - MUST BE OVERRIDE by SUBs
@property (nonatomic, assign) id<TableMoreCellDelegate> cellDelegate;

+(CGFloat) height;
+(CGFloat) heightWithData:(id)data;
+(NSString *) identify;
-(void) setData:(id) data;

@end
