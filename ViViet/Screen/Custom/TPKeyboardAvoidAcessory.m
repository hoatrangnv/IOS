//
//  HjTextFeilds.m
//  TextFields_Acccessory
//
//  Created by MAC on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TPKeyboardAvoidAcessory.h"

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

@interface TPKeyboardAvoidAcessory ()

- (UIView*)findFirstResponderBeneathView:(UIView*)view;
- (UIEdgeInsets)contentInsetForKeyboard;
- (CGFloat)idealOffsetForView:(UIView *)view withSpace:(CGFloat)space;
- (CGRect)keyboardRect;
@end

@implementation TPKeyboardAvoidAcessory
{
    UIToolbar * toolbar;
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
//    [self set_up_text_fields];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    [self set_up_text_fields];
}

- (void)setup {
    _priorInsetSaved = NO;
    if (CGSizeEqualToSize(self.contentSize, CGSizeZero))
    {
        self.contentSize = self.bounds.size;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _showToolBar = YES;
}

-(void)setShowToolBar:(BOOL)showToolBar
{
    _showToolBar = showToolBar;
    for (int i=0; i< [_textFields count]; i++)
    {
        // UITextField || UITextView
        UITextField *txtF = [_textFields objectAtIndex:i];
        txtF.inputAccessoryView = _showToolBar ? toolbar : nil;
    }
}
-(void) init_tool_bar
{
    if (toolbar)
        return;

    /*
     * init toolbar Next,Prev,Done
     */
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width,44)];
    UIBarButtonItem *btNext = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonSystemItemAction target:self action:@selector(barButtonItemAction:)];
    btNext.tag = 1;
    UIBarButtonItem *btPrev = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonSystemItemAction target:self action:@selector(barButtonItemAction:)];
    btPrev.tag = 2;
    UIBarButtonItem *btDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(barButtonItemAction:)];
    btDone.tag = 0;
    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = [NSArray arrayWithObjects:btPrev,btNext,space,btDone,nil];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    
    [space release];
    [btDone release];
    [btNext release];
    [btPrev release];
}

/*
 * Find TextField & TextView
 */
-(void) set_up_text_fields
{
    if (_textFields == nil)
        self.textFields  = [[[NSMutableArray alloc] init] autorelease];
    else
        [self.textFields removeAllObjects];
    
    [self findTextViewsFromView:self];
    
    /*
     * Sort textViews
     */
    __block TPKeyboardAvoidAcessory *weak = self;
    NSArray * sorted = [self.textFields sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        UIView * txt1 = (UIView*)obj1;
        UIView * txt2 = (UIView*)obj2;
        CGPoint origin1 = [txt1.superview convertPoint:txt1.frame.origin toView:weak];
        CGPoint origin2 = [txt2.superview convertPoint:txt2.frame.origin toView:weak];
        
        NSComparisonResult result ;
        if (origin1.y < origin2.y) {
            result = NSOrderedAscending;
        }else if (origin1.y > origin2.y) {
            result = NSOrderedDescending;
        }else
        {
            // y1 == y2
            if (origin1.x < origin2.x) {
                result = NSOrderedAscending;
            }else if (origin1.x > origin2.x) {
                result = NSOrderedAscending;
            }else{
                result = NSOrderedSame;
            }
        }
        return result;
    }];
    self.textFields = [NSMutableArray arrayWithArray:sorted];
    /*
     * add Input accessory view for TextFields
     */
    
    [self init_tool_bar];
    for (int i=0; i< [_textFields count]; i++)
    {
        // UITextField || UITextView
        UITextField *txtF = [_textFields objectAtIndex:i];
        if (txtF.inputView == nil)
        {
            txtF.inputAccessoryView = _showToolBar ? toolbar : nil;
        }
        txtF.tag = i;
    }
}

/* Find all Subview in SELF
 *   if:
 *       1. UITextField or UITextView .
 *       2. Can : focus , editting .
 *       3. Visible : NOT hidden.
 *   ====> add into textFields
 *   else NOT do.
 */
-(void) findTextViewsFromView:(UIView *) view
{
    if ([view isKindOfClass:[UITextField class]]
        || [view isKindOfClass:[UITextView class]])
    {
        if ([self focus_able:view] && [self isVisible:view])
            [self.textFields addObject:view];
        
        return;
    }
    for (UIView *v in [view subviews])
        [self findTextViewsFromView:v];
}

/*
 * Check View CAN : focus , editting.
 */
-(BOOL) focus_able:(UIView *) view
{
    if ([view isKindOfClass:[UITextField class]])
    {
        UITextField *tf = (UITextField*)view;
        if (tf.enabled == NO)
        {
            return NO;
        }
        if (tf.delegate && [tf.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
            return [tf.delegate textFieldShouldBeginEditing:tf];
        else
            return TRUE;
    }
    if ([view isKindOfClass:[UITextView class]])
    {
        UITextView *tv = (UITextView *) view;
        if (tv.delegate && [tv.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)])
            return [tv.delegate textViewShouldBeginEditing:tv];
        else
            return TRUE;
    }
    return NO;
}

/*
 * Check view isVisible
 */
-(BOOL) isVisible:(UIView*) view
{
    if (view == self)
        return TRUE;
    if (view == nil)
        return NO;
    
    if (view.hidden == YES)
        return NO;
    else
        return [self isVisible:view.superview];
    
    return NO;
}


-(void)barButtonItemAction:(UIBarButtonItem*)bt
{
    UIView *txt = (UITextField*)[self findFirstResponderBeneathView:self];
    if ( txt  == nil)
        // No child view is the first responder - nothing to do here
        return;
    
    if (txt.tag > _textFields.count)
        return;
    
    if (bt.tag == 0)
    {               // Button Done
        [txt resignFirstResponder];
        return;
    }
    int index = 0;
    
    
    switch (bt.tag) {
            // next
        case 1:
        {
            index = txt.tag == (int)[_textFields count] - 1 ? 0 : (int)txt.tag+1;
            break;
        }
            //prev
        case 2:
        {
            index = txt.tag == 0 ?  (int)[_textFields count] - 1 : (int)txt.tag - 1;
            break;
        }
        default:
            break;
    }
    
    UIResponder *newTxt = [_textFields objectAtIndex:index];
    [newTxt becomeFirstResponder];
}

-(id)initWithFrame:(CGRect)frame
{
    if ( !(self = [super initWithFrame:frame]) ) return nil;
    [self setup];
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
    [self set_up_text_fields];
}

-(void)dealloc {
    [toolbar release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.textFields = nil;
#if !__has_feature(objc_arc) 
    [super dealloc];
    
#endif
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGSize contentSize = _originalContentSize;
    contentSize.width = MAX(contentSize.width, self.frame.size.width);
    contentSize.height = MAX(contentSize.height, self.frame.size.height);
    [super setContentSize:contentSize];
    
    if ( _keyboardVisible ) {
        self.contentInset = [self contentInsetForKeyboard];
    }
}

-(void)setContentSize:(CGSize)contentSize
{
    _originalContentSize = contentSize;
    
    contentSize.width = MAX(contentSize.width, self.frame.size.width);
    contentSize.height = MAX(contentSize.height, self.frame.size.height);
    [super setContentSize:contentSize];
    
    if ( _keyboardVisible ) {
        self.contentInset = [self contentInsetForKeyboard];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__FUNCTION__);
    [[self findFirstResponderBeneathView:self] resignFirstResponder];
    [super touchesEnded:touches withEvent:event];
} 

- (void)keyboardWillShow:(NSNotification*)notification
{
    _keyboardRect = [[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardVisible = YES;
    
    UIView *firstResponder = [self findFirstResponderBeneathView:self];
    if ( !firstResponder ) {
        // No child view is the first responder - nothing to do here
        return;
    }
    
    
    if (!_priorInsetSaved) {
        _priorInset = self.contentInset;
        _priorInsetSaved = YES;
    }
    CGRect r = toolbar.frame;
    r.size.width = [self keyboardRect].size.width;
    toolbar.frame = r;

    UIEdgeInsets contentInset = [self contentInsetForKeyboard];
    CGFloat space = [self keyboardRect].origin.y - self.bounds.origin.y;
    CGPoint theOff = CGPointMake(self.contentOffset.x, [self idealOffsetForView:firstResponder withSpace:space]);
    
    // Shrink view's inset by the keyboard's height, and scroll to show the text field/view being edited
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    self.contentInset = contentInset;
    [self setContentOffset:theOff animated:YES];
    
    [self setScrollIndicatorInsets:self.contentInset];
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    _keyboardRect = CGRectZero;
    _keyboardVisible = NO;
    
    // Restore dimensions to prior size
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    self.contentInset = _priorInset;
    [self setScrollIndicatorInsets:self.contentInset];
    _priorInsetSaved = NO;
    [UIView commitAnimations];
}

- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result ) return result;
    }
    return nil;
}

- (UIEdgeInsets)contentInsetForKeyboard
{
    UIEdgeInsets newInset = self.contentInset;
    CGRect keyboardRect = [self keyboardRect];
    newInset.bottom = keyboardRect.size.height - ((keyboardRect.origin.y+keyboardRect.size.height) - (self.bounds.origin.y+self.bounds.size.height));
    return newInset;
}

-(CGFloat)idealOffsetForView:(UIView *)view withSpace:(CGFloat)space
{
    // Convert the rect to get the view's distance from the top of the scrollView.
    CGRect rect = [view convertRect:view.bounds toView:self];
    
    CGFloat off = rect.origin.y + rect.size.height - space + 44;
    if (off < 0)
        off = 0;
    if (off + self.frame.size.height - space > self.contentSize.height)
    {
        off = self.contentSize.height - self.contentSize.height + space;
    }
    return off;
    
    // Set starting offset to that point
    CGFloat offset = rect.origin.y;
    
    if ( self.contentSize.height - offset < space)
    {
        // Scroll to the bottom
        offset = self.contentSize.height - space;        
    }
    else
    {
        if ( view.bounds.size.height < space )
        {
            // Center vertically if there's room
            offset -= floor((space-view.bounds.size.height)/2.0);
        }
        if ( offset + space > self.contentSize.height )
        {
            // Clamp to content size
            offset = self.contentSize.height - space;
        }
    }
    
    if (offset < 0) offset = 0;
    
    return offset;
}

-(void)adjustOffsetToIdealIfNeeded
{
    // Only do this if the keyboard is already visible
    if ( !_keyboardVisible ) return;
    
    CGFloat visibleSpace = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom;
    
    CGPoint idealOffset = CGPointMake(0, [self idealOffsetForView:[self findFirstResponderBeneathView:self] withSpace:visibleSpace]); 
    
    [self setContentOffset:idealOffset animated:YES];                
}

- (CGRect)keyboardRect
{
    CGRect keyboardRect = [self convertRect:_keyboardRect fromView:nil];
    if ( keyboardRect.origin.y == 0 ) {
        CGRect screenBounds = [self convertRect:[UIScreen mainScreen].bounds fromView:nil];
        keyboardRect.origin = CGPointMake(0, screenBounds.size.height - keyboardRect.size.height);
    }
    return keyboardRect;
}

@end

