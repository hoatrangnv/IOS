//
//  NumberTextField.m
//  ViMASS
//
//  Created by Chung NV on 8/9/13.
//
//

#import "NumberTextField.h"
@interface NumberTextField()
@property (nonatomic, copy) NSString *oldText;
@end;

@implementation NumberTextField
{
    NSMutableDictionary *   _validateBlocks;
    BOOL block_settext;
}
#pragma mark -
-(void)textFieldTextEditingChanged:(id)sender
{
    if (block_settext == YES)
        return;
    
    block_settext = YES;
    
    NSString *text = self.text;
    if (text.length > _oldText.length)
    {
        if ([self validate_internal] == NO)
        {
            self.text = _oldText;
            block_settext = NO;
            return;
        }
    }
    self.text = text;
    self.oldText = self.text;
    block_settext = NO;
    NSLog(@"double = %g",[self.text doubleValue]);
}

-(BOOL)validate_internal
{
    BOOL validate = [super validate_internal];
    if (validate == NO)
        return NO;
    
    if (_validateBlocks && _validateBlocks.count > 0)
    {
        for (NumberBlockValidate block in _validateBlocks)
        {
            BOOL validate = block([self.text doubleValue]);
            if (validate == NO)
            {
                NSString *messError = [_validateBlocks objectForKey:block];
                if (messError)
                    self.textError = messError;
                return NO;
            }
        }
    }
    
    return TRUE;
}
#pragma mark - Init
-(void)_initViews
{
    self.type = ExTextFieldTypeMoney;
    [self changePattern:@"^[0-9]+[.,]*[0-9]*$"];
    self.oldText = @"";
    [self addTarget:self
             action:@selector(textFieldTextEditingChanged:)
   forControlEvents:UIControlEventEditingChanged];
}
-(id) init
{
    if (self = [super init])
    {
        [self _initViews];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ([super initWithCoder:aDecoder])
    {
        [self _initViews];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _initViews];
    }
    return self;
}


-(void)dealloc
{
    [_validateBlocks release];
    _validateBlocks = nil;
    [_oldText release];
    _oldText = nil;
    [super dealloc];
    
}
@end
