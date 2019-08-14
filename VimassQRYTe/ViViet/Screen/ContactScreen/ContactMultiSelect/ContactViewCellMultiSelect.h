//
//  ContactViewCell.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/15/12.
//
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface ContactViewCellMultiSelect : UITableViewCell
{
    IBOutlet UILabel *_lbName;
    IBOutlet UILabel *_lbPhone;
    IBOutlet UIImageView *_walletIcon;
    
    IBOutlet UIImageView *mimgvBorderAvatar;
    IBOutlet UIImageView *avatar;
}
+ (CGFloat) height;
- (id)initWithReuseIdentifier:(NSString *)rid;

- (void) setContact:(Contact *)ct isSelected:(BOOL)selected;
@end
