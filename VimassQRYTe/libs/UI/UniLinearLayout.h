//
//  UniLinearLayout.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 3/3/14.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    UniLinearLayoutOrientation_Vertical = 1,
    UniLinearLayoutOrientation_Horizontal = 1 << 1
    
} UniLinearLayoutOrientation;

@interface UniLinearLayout : UIView

@property (nonatomic, assign) UniLinearLayoutOrientation orientation;

@end
