//
//  EXTextView.m
//  ViMASS
//
//  Created by Chung NV on 4/4/13.
//
//

#define kTEXT_FIELDS_BACKGOUND_CUSTOM @"text-field-bg"
#define kTEXT_VIEW_MAX_LENGTH 1000
#define kLABEL_REMAINING_TAG 204
#import "EXTextView.h"
#import "Common.h"

#import <QuartzCore/QuartzCore.h>



@interface UITextViewDelegateImpl : NSObject <UITextViewDelegate>
{
    EXTextView *txtView;
}
-(id)initWithTextView:(EXTextView *)txtView;

@end

@implementation UITextViewDelegateImpl

-(id)initWithTextView:(EXTextView *)tv;
{
    if (self = [super init])
    {
        self->txtView = tv;
    }
    return self;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    if ([txtView respondsToSelector:@selector(textViewShouldBeginEditing:)])
    {
        return [txtView textViewShouldBeginEditing:textView];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
{
    if ([txtView respondsToSelector:@selector(textViewShouldEndEditing:)])
    {
        return [txtView textViewShouldEndEditing:textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView;
{
    if ([txtView respondsToSelector:@selector(textViewDidBeginEditing:)])
    {
        return [txtView textViewDidBeginEditing:textView];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView;
{
    if ([txtView respondsToSelector:@selector(textViewDidEndEditing:)])
    {
        return [txtView textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if ([txtView respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)])
    {
        return [txtView textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView;
{
    if ([txtView respondsToSelector:@selector(textViewDidChange:)])
    {
        return [txtView textViewDidChange:textView];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView;
{
    if ([txtView respondsToSelector:@selector(textViewDidChangeSelection:)])
    {
        return [txtView textViewDidChangeSelection:textView];
    }
}

@end



@implementation EXTextView
{
    BOOL showPlaceHolder;
    BOOL setTextFlag;
    
    UITextViewDelegateImpl * proxy_delegate;
}

@synthesize placeHolder = _placeHolder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _init];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self _init];
    }
    return self;
}
-(id)init
{
    if (self = [super init])
    {
        [self _init];
    }
    return self;
}

-(void)_init
{
    proxy_delegate = [[UITextViewDelegateImpl alloc] initWithTextView:self];
    super.delegate = proxy_delegate;
//    self.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
}
-(void)awakeFromNib
{
    [super awakeFromNib];
}
//-(void)didMoveToSuperview
//{
//    [super didMoveToSuperview];
//    CGSize size;
//    size.width = self.frame.size.width - 4;
//    size.height = self.frame.size.height - 4;
//    self.contentSize = size;
//    
//}
-(NSString *)text
{
    if (showPlaceHolder)
        return @"";
    else
        return [super text];
}
-(void)setText:(NSString *)text
{
    setTextFlag = YES;
    [super setText:text];
}
-(void)setPlaceHolder:(NSString *)placeHolder
{
    if (placeHolder != _placeHolder)
    {
        [_placeHolder release];
        _placeHolder = [placeHolder copy];
    }
    self.text = _placeHolder;
//    [self setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self setTextColor:[UIColor lightGrayColor]];
    
    showPlaceHolder = YES;
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.backgroundColor = [UIColor clearColor];
    [[Common stretchImage:kTEXT_FIELDS_BACKGOUND_CUSTOM] drawInRect:rect];
    
    if (self.placeHolder == nil)
        return;
    
    UILabel * remaining = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    self.frame.size.height - 15,
                                                                    self.frame.size.width - 20,
                                                                    15.0)];
    remaining.backgroundColor = [UIColor clearColor];
    remaining.font = [UIFont fontWithName:@"Helvetica" size:15];
    remaining.textColor = [UIColor darkGrayColor];
    remaining.tag = kLABEL_REMAINING_TAG;

    [self addSubview:remaining];
    [remaining release];
    [self setTextRemaining];
    self.contentInset = UIEdgeInsetsMake(0.0, 0.0, 15.0, 0.0);

}

-(void)setTextRemaining
{
    UILabel *remaining = (UILabel*)[self viewWithTag:kLABEL_REMAINING_TAG];
    if (remaining != nil && [remaining isKindOfClass:[UILabel class]])
    {
//        int remaining_length = showPlaceHolder ? kTEXT_VIEW_MAX_LENGTH : kTEXT_VIEW_MAX_LENGTH - self.text.length;
//        remaining.text = [NSString stringWithFormat:@"%d/%d",remaining_length,kTEXT_VIEW_MAX_LENGTH];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (showPlaceHolder)
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

-(void) textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length == 0)
        [self setPlaceHolder:self.placeHolder];
    else
        showPlaceHolder = NO;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.text.length >= kTEXT_VIEW_MAX_LENGTH
        && [text isEqualToString:@""] == NO
        && [text isEqualToString:@"\n"] == NO)
    {
        return NO;
    }
    showPlaceHolder = NO;
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        
        if(textView.text.length == 0)
            [self setPlaceHolder:self.placeHolder];
        return NO;
    }
    
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    [self setTextRemaining];
}

-(void)dealloc
{
    [_placeHolder release];
    [proxy_delegate release];
    [super dealloc];
}

@end
