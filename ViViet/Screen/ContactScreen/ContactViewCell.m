//
//  ContactViewCell.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/15/12.
//
//

#import "ContactViewCell.h"
#import "PhoneContacts.h"

@implementation ContactViewCell


- (void) setContact:(Contact *)ct
{
    _lbName.text = ct.fullName;
    _lbPhone.text = ct.phone;
    _walletIcon.hidden = !ct.hasAccount;
    UIImage * imgAvatar = [PhoneContacts getAvatarByRecordID:ct.recordID];
    if (imgAvatar)
    {
        avatar.image = imgAvatar;
        if(ct.hasAccount)
        {

            [mimgvBorderAvatar setHidden:NO];
        }
        else
        {
            [mimgvBorderAvatar setHidden:YES];
        }
    }
    
    else
    {
        [mimgvBorderAvatar setHidden:YES];
        if(ct.hasAccount)
        {
            avatar.image = [UIImage imageNamed:@"danhba64x64"];
        }
        else
        {
            avatar.image = [UIImage imageNamed:@"icon_noavatar_danhba"];
        }
    }
}

-(id)init
{
    NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"ContactViewCell" owner:nil options:nil];
    self = [views lastObject];
    return self;
}

- (id)initWithReuseIdentifier:(NSString *)rid
{
//    return [self init];
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    if (self)
    {
        _lbName = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 244, 25)] autorelease];
        _lbName.font = [UIFont boldSystemFontOfSize:16];
        _lbName.textColor = [UIColor blackColor];
        _lbName.backgroundColor = [UIColor whiteColor];
        _lbName.adjustsFontSizeToFitWidth = YES;
        _lbName.numberOfLines = 1;
        _lbName.minimumScaleFactor = 8;
        [self addSubview:_lbName];
        
        _lbPhone = [[[UILabel alloc] initWithFrame:CGRectMake(10, 25, 244, 25)] autorelease];
        _lbPhone.font = [UIFont systemFontOfSize:13];
        _lbPhone.textColor = [UIColor blackColor];
        _lbPhone.backgroundColor = [UIColor whiteColor];
        _lbPhone.adjustsFontSizeToFitWidth = YES;
        _lbPhone.numberOfLines = 1;
        _lbPhone.minimumScaleFactor = 8;
        
        [self addSubview:_lbPhone];
        
        _walletIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vv.png"]] autorelease];
        _walletIcon.frame = CGRectMake(250, 16, 60, 17);
        _walletIcon.hidden = YES;
        [self addSubview:_walletIcon];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (CGFloat) height
{
    return 47;
}

- (void)dealloc
{
    [_lbName release];
    [_lbPhone release];
    [avatar release];
    [mimgvBorderAvatar release];
    [super dealloc];
}
@end
