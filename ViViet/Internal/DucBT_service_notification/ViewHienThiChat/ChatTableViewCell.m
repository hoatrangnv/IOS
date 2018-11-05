//
//  ChatTableViewCell.m
//  ViMASS
//
//  Created by DucBT on 9/29/14.
//
//

#import "ChatTableViewCell.h"

#define kKHOANG_CACH_GIUA_CAC_DOI_TUONG 5.0f
#define kCANH_LE_TRAI 8.0f
#define kDO_RONG_IMAGE 30.0f


@implementation ChatTableViewCell

@synthesize sent, messageLabel, messageView, timeLabel, balloonView, checkImageView;

static CGFloat textMarginHorizontal = 15.0f;
static CGFloat textMarginVertical = 7.5f;
static CGFloat messageTextSize = 14.0;


+(CGFloat)textMarginHorizontal {
    return textMarginHorizontal;
}

+(CGFloat)textMarginVertical {
    return textMarginVertical;
}

+(CGFloat)maxTextWidth {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 220.0f;
    } else {
        return 400.0f;
    }
}

+ (CGSize)messageSize:(NSString*)message {
    return [message sizeWithFont:[UIFont systemFontOfSize:messageTextSize] constrainedToSize:CGSizeMake([ChatTableViewCell maxTextWidth], CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
}

+ (UIImage*)balloonImage:(BOOL)sent isSelected:(BOOL)selected {
//    if (sent == YES && selected == YES) {
//        return [[UIImage imageNamed:@"balloon_selected_right"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
//    } else if (sent == YES && selected == NO) {
//        return [[UIImage imageNamed:@"balloon_read_right"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
//    } else if (sent == NO && selected == YES) {
//        return [[UIImage imageNamed:@"balloon_selected_left"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
//    } else {
//        return [[UIImage imageNamed:@"balloon_read_left"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
//    }
    if(sent == YES)
    {
        return [[UIImage imageNamed:@"balloon_read_left"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    }
    else
    {
        return [[UIImage imageNamed:@"balloon_read_right"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    }
}

#pragma mark -
#pragma mark Object-Lifecycle/Memory management

-(id)initMessagingCellWithReuseIdentifier:(NSString*)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        /*Selection-Style of the TableViewCell will be 'None' as it implements its own selection-style.*/
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:[UIColor clearColor]];
        self.mDelete = NO;
        self.isChecked = NO;
        
        /*Now the basic view-lements are initialized...*/
        messageView = [[UIView alloc] initWithFrame:CGRectZero];
        messageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        checkImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        /*Message-Label*/
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.font = [UIFont systemFontOfSize:messageTextSize];
        self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.messageLabel.numberOfLines = 0;
        
        /*Time-Label*/
        self.timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        self.timeLabel.textColor = [UIColor darkGrayColor];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        
        /*...and adds them to the view.*/
        [self.messageView addSubview: self.balloonView];
        [self.messageView addSubview: self.messageLabel];
        
        [self.messageView addSubview: self.timeLabel];
        [self.messageView addSubview: self.checkImageView];
        [self.contentView addSubview: self.messageView];
        
        /*...and a gesture-recognizer, for LongPressure is added to the view.*/
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [recognizer setMinimumPressDuration:1.0f];
        [self addGestureRecognizer:recognizer];
    }
    
    return self;
}

#pragma mark -
#pragma mark Layouting

- (void)layoutSubviews {
    /*This method layouts the TableViewCell. It calculates the frame for the different subviews, to set the layout according to size and orientation.*/

    /*Calculates the size of the message. */
    CGSize textSize = [ChatTableViewCell messageSize:self.messageLabel.text];

    /*Calculates the size of the timestamp.*/
    CGSize dateSize = [self.timeLabel.text sizeWithFont:self.timeLabel.font forWidth:[ChatTableViewCell maxTextWidth] lineBreakMode:NSLineBreakByClipping];
    
//    CGFloat fDoCaoNoiDung = dateSize.height + textSize.height + 2*textMarginVertical;
//    if(fDoCaoNoiDung < kDO_CAO_ANH)
//    {
//        fDoCaoNoiDung
//    }
    
    /*Initializes the different frames , that need to be calculated.*/
    CGRect ballonViewFrame = CGRectZero;
    CGRect messageLabelFrame = CGRectZero;
    CGRect timeLabelFrame = CGRectZero;
    CGRect checkImageFrame = CGRectZero;
    
    float ballonViewHeight = textSize.height + 2*textMarginVertical +dateSize.height + kKHOANG_CACH_GIUA_CAC_DOI_TUONG;
    float widthTextSize = textSize.width;
    if(widthTextSize < dateSize.width)
        widthTextSize = dateSize.width;
    
    float fDoRongAnhDelete = 0;
    if(_mDelete)
    {
        fDoRongAnhDelete = kKHOANG_CACH_GIUA_CAC_DOI_TUONG + kDO_RONG_IMAGE;
    }
    else
    {
        fDoRongAnhDelete = 0;
    }
    
    
    if (self.sent == YES)
    {
        ballonViewFrame = CGRectMake(kKHOANG_CACH_GIUA_CAC_DOI_TUONG + fDoRongAnhDelete, kKHOANG_CACH_GIUA_CAC_DOI_TUONG, widthTextSize + 2*textMarginHorizontal, ballonViewHeight);
        
        messageLabelFrame = CGRectMake(ballonViewFrame.origin.x + textMarginHorizontal , ballonViewFrame.origin.y + textMarginVertical, textSize.width, textSize.height);
        
        timeLabelFrame = CGRectMake(messageLabelFrame.origin.x, messageLabelFrame.origin.y + messageLabelFrame.size.height + kKHOANG_CACH_GIUA_CAC_DOI_TUONG, dateSize.width, dateSize.height);
        
        if(_mDelete)
        {
            float fViTriX = kKHOANG_CACH_GIUA_CAC_DOI_TUONG;
            float fViTriY = ballonViewFrame.origin.y + (ballonViewFrame.size.height - kDO_RONG_IMAGE) / 2;
            checkImageFrame = CGRectMake(fViTriX, fViTriY, kDO_RONG_IMAGE, kDO_RONG_IMAGE);
        }
    }
    else
    {
        ballonViewFrame = CGRectMake(self.frame.size.width - (widthTextSize + 2*textMarginHorizontal) - kKHOANG_CACH_GIUA_CAC_DOI_TUONG - fDoRongAnhDelete, kKHOANG_CACH_GIUA_CAC_DOI_TUONG, widthTextSize + 2*textMarginHorizontal, ballonViewHeight);
        
        messageLabelFrame = CGRectMake(self.frame.size.width - textMarginHorizontal - kKHOANG_CACH_GIUA_CAC_DOI_TUONG - textSize.width - fDoRongAnhDelete, ballonViewFrame.origin.y + textMarginVertical, textSize.width, textSize.height);
        
        timeLabelFrame = CGRectMake(self.frame.size.width - textMarginHorizontal - kKHOANG_CACH_GIUA_CAC_DOI_TUONG - dateSize.width - fDoRongAnhDelete, messageLabelFrame.origin.y + messageLabelFrame.size.height + kKHOANG_CACH_GIUA_CAC_DOI_TUONG, dateSize.width, dateSize.height);
        
        if(_mDelete)
        {
            float fViTriX = self.frame.size.width - kKHOANG_CACH_GIUA_CAC_DOI_TUONG - fDoRongAnhDelete;
            float fViTriY = ballonViewFrame.origin.y + (ballonViewFrame.size.height - kDO_RONG_IMAGE) / 2;
            checkImageFrame = CGRectMake(fViTriX, fViTriY, kDO_RONG_IMAGE, kDO_RONG_IMAGE);
        }
    }

    self.balloonView.image = [ChatTableViewCell balloonImage:self.sent isSelected:self.selected];
    if(_isChecked)
    {
        self.checkImageView.image = [[UIImage imageNamed:@"ic_checked"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    }
    else
    {
        self.checkImageView.image = [[UIImage imageNamed:@"ic_unchecked"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    }

    
    /*Sets the pre-initialized frames  for the balloonView and messageView.*/
    self.balloonView.frame = ballonViewFrame;
    self.messageLabel.frame = messageLabelFrame;
    self.checkImageView.frame = checkImageFrame;
    
    /*If there is next for the timeLabel, sets the frame of the timeLabel.*/
    
    if (self.timeLabel.text != nil) {
        self.timeLabel.frame = timeLabelFrame;
    }
}


#pragma mark -
#pragma mark UIGestureRecognizer-Handling

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressRecognizer {
    /*When a LongPress is recognized, the copy-menu will be displayed.*/
    if (longPressRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    if ([self becomeFirstResponder] == NO) {
        return;
    }
    
    UIMenuController * menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.balloonView.frame inView:self];
    
    [menu setMenuVisible:YES animated:YES];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    /*Selecting a UIMessagingCell will cause its subviews to be re-layouted. This process will not be animated! So handing animated = YES to this method will do nothing.*/
    [super setSelected:selected animated:NO];
    
//    [self setNeedsLayout];
//    
//    /*Furthermore, the cell becomes first responder when selected.*/
//    if (selected == YES) {
//        [self becomeFirstResponder];
//    } else {
//        [self resignFirstResponder];
//    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
}

-(BOOL)canBecomeFirstResponder {
    /*This cell can become first-responder*/
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    /*Allows the copy-Action on this cell.*/
    if (action == @selector(copy:)) {
        return YES;
    } else {
        return [super canPerformAction:action withSender:sender];
    }
}

-(void)copy:(id)sender {
    /**Copys the messageString to the clipboard.*/
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.messageLabel.text];
}



- (void)dealloc
{
    if(checkImageView)
        [checkImageView release];
    if(messageLabel)
        [messageLabel release];
    if(messageView)
        [messageView release];
    if(timeLabel)
       [timeLabel release];
    if(balloonView)
        [balloonView release];
    [super dealloc];
}

@end
