//
//  SelectItemViewCell.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/4/12.
//
//

#import <UIKit/UIKit.h>
#import "TableLoadMoreCell.h"
@interface SelectItemViewCell : TableLoadMoreCell
{
    IBOutlet UIImageView *background;
}
@property (retain, nonatomic) IBOutlet UILabel *lblText;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
