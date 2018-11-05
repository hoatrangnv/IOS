//
//  UILabel+Helpers.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 4/12/13.
//
//

#import "UILabel+Helpers.h"

@implementation UILabel (Helpers)

- (void)adjustCurrentFontSize:(CGFloat)min_size;
{
    if (min_size <= 0)
        min_size = 1;
    
    CGFloat font_size = self.font.pointSize;
    CGSize limit = self.frame.size;
    limit.height = 99999;
    
    for (; font_size >= min_size; font_size--)
    {
        UIFont *font = [UIFont fontWithName:self.font.fontName size:font_size];
        CGSize sz = [self.text sizeWithFont:font constrainedToSize:limit lineBreakMode:self.lineBreakMode];
        sz = CGSizeMake(roundf(sz.width), roundf(sz.height));
        if (sz.width <= limit.width && sz.height <= self.frame.size.height)
            break;
    }
    font_size = MAX(font_size, min_size);
    if (self.font.pointSize != font_size)
        self.font = [UIFont fontWithName:self.font.fontName size:font_size];
}

-(CGRect) fit_text
{
    CGSize sz = [self.text sizeWithFont:self.font];
    CGRect fr = self.frame;
    fr.size.width = sz.width;
    self.frame = fr;
    
    return fr;
}

-(CGRect) wrap_text
{
    CGSize limit = self.bounds.size;
    limit.height = 99999;
    self.numberOfLines = 0;
    
    CGSize sz = [self.text sizeWithFont:self.font
                      constrainedToSize:limit
                          lineBreakMode:NSLineBreakByWordWrapping];
    //33.403999
    CGRect fr = self.frame;
    fr.size.height = roundf(sz.height) + 1;
    self.frame = fr;
    return fr;
}
-(CGRect) wrap_text:(int) numberLines
{
    CGSize limit = self.bounds.size;
    limit.height = 99999;
    self.numberOfLines = numberLines;
    
    CGSize sz = [self.text sizeWithFont:self.font constrainedToSize:limit lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect fr = self.frame;
    fr.size.height = roundf(sz.height) + 1;
    self.frame = fr;
    return fr;
}

- (CGRect)adjust_height;
{
    CGSize limit = self.bounds.size;
    limit.height = 99999;
    self.numberOfLines = 0;
    CGSize sz = [self.text sizeWithFont:self.font constrainedToSize:limit lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect fr = self.frame;
    fr.size.height = sz.height;
    self.frame = fr;
    return fr;
}

-(void)display_justify
{
    NSString *text = self.text.trim;
    CGSize sz = [text sizeWithFont:self.font];
    
    int num_row = (int)ceilf(sz.width / self.frame.size.width);
    if (num_row < 2)
    {
        self.text = text;
        return;
    }
    while (TRUE)
    {
        if ([self _display_justify:num_row] == NO)
        {
            num_row = num_row + 1;
        }else
        {
            break;
        }
    }
}
-(BOOL) _display_justify:(int) num_row
{
    NSString *text = self.text.trim;
    CGSize sz = [text sizeWithFont:self.font];
    
    float width_i = round(sz.width / num_row);
    
    NSArray * a = [text componentsSeparatedByString:@" "];
    NSMutableArray *words = [NSMutableArray arrayWithArray:a];
    
    int curent_row = 1;
    int start = 0;
    int i;
    for (i = 0; i< words.count; i++)
    {
        NSArray * words_sub = [words subarrayWithRange:NSMakeRange(start,i - start)];
        float width_words_sub = [self width_of_words:words_sub];
        if (width_i <= width_words_sub)
        {
            curent_row ++;
            int index = i;
            if (i >= 1)
            {
                if(width_words_sub <= self.frame.size.width)
                {
                    float offSet_i = width_words_sub - width_i;
                    // calc "dw"(delta width) at : i-1
                    NSArray * words_sub_i_1 = [words subarrayWithRange:NSMakeRange(0,i-1)];
                    float width_words_sub_i_1 = [self width_of_words:words_sub_i_1];
                    float offSet_i_1 = fabsf(width_i - width_words_sub_i_1);
                    
                    index = offSet_i > offSet_i_1 ? (i-1) : i;
                }else
                {
                    index = i - 1;
                }
               
            }
            i = index;
            start = index;
            [words insertObject:@"_\n_" atIndex:index];
            if (curent_row == num_row)
            {
                break;
            }
        }
    }
    
    // calc width of last-line
    NSArray * words_sub_end = [words subarrayWithRange:NSMakeRange(start,words.count - i)];
    float width_words_sub_end = [self width_of_words:words_sub_end];
    if (width_words_sub_end > self.frame.size.width)
    {
        return NO;
    }
    
    NSString * text_just = [words componentsJoinedByString:@" "];
    text_just = [text_just stringByReplacingOccurrencesOfString:@" _\n_ " withString:@"\n"];
    
    self.text = text_just;
    return YES;
}

-(float) width_of_words:(NSArray *)words
{
    NSString *text = [words componentsJoinedByString:@" "];
    CGSize sz = [text sizeWithFont:self.font];
    return sz.width;
}
@end
