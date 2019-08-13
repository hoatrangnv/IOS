//
//  ChatTableViewCell.h
//  ViMASS
//
//  Created by DucBT on 9/29/14.
//
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell
{
    /*Thoi gian gui*/
    UILabel* timeLabel;
    
    /*Subview of the MessagingCell, containing the actual message. It can be set in the cellForRowAtIndexPath:-Method.*/
    UILabel* messageLabel;
    
    /*Xac dinh trang thai da gui cua tin nhan tai cell hien tai*/
    BOOL sent;
    
    /*This is a private subview of the MessagingCell. It is not intended do be editable.*/
    @private UIView * messageView;
    
    /*This is a private subview of the MessagingCell, containing the ballon-graphic. It is not intended do be editable.*/
    @private UIImageView * balloonView;
    
    @private UIImageView * checkImageView;
}

@property (nonatomic, readonly) UIView * messageView;

@property (nonatomic, readonly) UILabel * messageLabel;

@property (nonatomic, readonly) UILabel * timeLabel;

@property (nonatomic, readonly) UIImageView * balloonView;

@property (nonatomic, readonly) UIImageView * checkImageView;

@property (assign) BOOL sent;

@property (assign) BOOL mDelete;

@property (assign) BOOL isChecked;

/**Returns the text margin in horizontal direction.
 @return CGFloat containing the horizontal text margin.
 */
+(CGFloat)textMarginHorizontal;

/**Returns the text margin in vertical direction.
 @return CGFloat containing the vertical text margin.
 */
+(CGFloat)textMarginVertical;

/** Returns the maximum width for a single message. The size depends on the UIInterfaceIdeom (iPhone/iPad). FOR CUSTOMIZATION: To edit the maximum width, edit this method.
 @return CGFloat containing the maximal width.
 */
+(CGFloat)maxTextWidth;

/** Calculates and returns the size of a frame containing the message, that is given as a parameter.
 @param message NSString containing the message string.
 @return CGSize containing the size of the message (w/h).
 */
+(CGSize)messageSize:(NSString*)message;

/**  Returns the ballon-Image for specified conditions.
 @param sent Indicates, wheather the message has been sent or received.
 @param selected Indicates, wheather the cell has been selected.
 FOR CUSTOMIZATION: To edit the image, user your own names in this method.
 */
+(UIImage*)balloonImage:(BOOL)sent isSelected:(BOOL)selected;

/**Initializes the PTSMessagingCell.
 @param reuseIdentifier NSString* containing a reuse Identifier.
 @return Instanze of the initialized PTSMessagingCell.
 */

-(id)initMessagingCellWithReuseIdentifier:(NSString*)reuseIdentifier;
@end
