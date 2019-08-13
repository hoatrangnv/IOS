//
//  AmountTextField.m
//  ViMASS
//
//  Created by Chung NV on 3/29/13.
//
//

#import "AmountTextField.h"
#import "Currency.h"
#import "UIView+EmphasizeShaking.h"

@implementation AmountTextField
{
    NSString *              oldText;
    NSMutableDictionary *   _validateBlocks;
    BOOL block_settext;
}

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame])
    {
        [self _initViews];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self _initViews];
    }
    return self;
}
- (id)init
{
    if (self = [super init])
    {
        [self _initViews];
    }
    return self;
}
- (void) _initViews
{
    [self setOldText:@""];
    [self addTarget:self
             action:@selector(textFieldTextEditingChanged:)
   forControlEvents:UIControlEventEditingChanged];
}
-(NSString *)getAmount
{
    NSString *txt = [self.text stringByReplacingOccurrencesOfString:@"[.,]"
                                                         withString:@""
                                                            options:NSRegularExpressionSearch
                                                              range:NSMakeRange(0, self.text.length)];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    fmt.numberStyle = NSNumberFormatterDecimalStyle;
    fmt.maximumFractionDigits = 0;
    fmt.formatterBehavior = NSNumberFormatterBehaviorDefault;
    
    NSNumber *num = [fmt numberFromString:txt];
    [fmt release];
    return num == nil ? nil : [NSString stringWithFormat:@"%@",num];
}

-(void)addAmountConstraintWithBlock:(AmountBlockValidate)amountValidate
             withErrorMessage:(NSString *)messageError
{
    if (!_validateBlocks)
        _validateBlocks = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    [_validateBlocks setObject:messageError forKey:[amountValidate copy]];
    
    return;
}
-(BOOL)validate
{
    if ([super validate] == NO)
        return NO;
    if (_validateBlocks && _validateBlocks.count > 0)
    {
        for (AmountBlockValidate block in _validateBlocks)
        {
            BOOL validate = block([self.getAmount doubleValue]);
            if (validate == NO)
            {
                UIView *iconError = [self iconError];
                iconError.hidden = NO;
                NSString *messError = [_validateBlocks objectForKey:block];
                if (messError)
                    self.textError = messError;
                [self shakingHorizontalInDuration:0.5 withAmplitude:10 andRepeat:3];
                return NO;
            }
        }
    }
    
    return TRUE;
}

-(void)setText:(NSString *)text
{
    NSString *txt = [text stringByReplacingOccurrencesOfString:@"[.,]"
                                                    withString:@""
                                                       options:NSRegularExpressionSearch
                                                         range:NSMakeRange(0, text.length)];
    NSString *t =[Currency formatNumber:txt];
    
    [super setText:t];
}

-(void)textFieldTextEditingChanged:(id)sender
{
//    if (block_settext && SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"5.1"))
//    {
//        block_settext = NO;
//        return;
//    }
    if (block_settext == YES)
        return;
    
    block_settext = YES;
    
    NSString *text = self.text;
    if (text.length > oldText.length)
    {
        // add new character
        if ([self isNumberic:text] == NO)
        {
            /// vao day
            self.text = oldText;
            block_settext = NO;
            return;
        }
    }
    self.text = text;
    [self setOldText:self.text];
    block_settext = NO;
}

-(BOOL) isNumberic:(NSString *) str
{
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"^[0-9]+([.,][0-9]+)*$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *found = [regex firstMatchInString:str options:0 range:NSMakeRange(0, str.length)];
    BOOL c = FALSE;
    if (found)
        c = TRUE;
    
    [regex release];
    return c;
}

-(void) setOldText:(NSString *)string
{
    if(oldText != string)
    {
        [oldText release];
        oldText = [string copy];
    }
}
-(void)dealloc
{
    if (oldText)
        [oldText release];
    
    if (_validateBlocks)
        [_validateBlocks release];
    
    [super dealloc];
}
@end
