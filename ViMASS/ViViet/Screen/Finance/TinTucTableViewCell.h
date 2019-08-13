//
//  TinTucTableViewCell.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 1/8/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TinTucTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *imgvIcon;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblContent;

@end

NS_ASSUME_NONNULL_END
