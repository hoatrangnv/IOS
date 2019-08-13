//
//  UIView+Localization.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 8/7/13.
//
//

#import "UIView+Localization.h"
#import "BPButton.h"
#import "Static.h"
#import "LocalizationSystem.h"
#import "Alert+Block.h"
#import "Common.h"
#import <objc/runtime.h>
#pragma mark - ViewToTextInfo2

@interface ViewToTextInfo2 : NSObject
{
@public
    void *p;
    int type;
    NSString *text;
    NSArray *texts;
}
+ (ViewToTextInfo2*)infoWithPointer:(void*)p type:(int)type text:(NSString *)text;
@end

@implementation ViewToTextInfo2

+ (ViewToTextInfo2*)infoWithPointer:(void*)p type:(int)type text:(NSString *)text
{
    ViewToTextInfo2 *o = [[ViewToTextInfo2 new] autorelease];
    o->p = p;
    o->type = type;
    o->text = [text copy];
    return o;
}
- (void)dealloc
{
    [text release];
    [texts release];
    [super dealloc];
}
@end

@implementation UIView (Localization)

#pragma mark - Auto localize view

- (BOOL)isAutoLocalizeViewText:(NSString *)str
{
    return (str.length > 1 && [str rangeOfString:@"@"].location == 0);
}
- (NSString *)getLocalizeViewText:(NSString *)str
{
    return [str substringFromIndex:1];
}

- (void)localizeViews
{
    for (int i = 0; i < self.viewToText.count; i++)
    {
        ViewToTextInfo2 *inf = [self.viewToText objectAtIndex:i];
        @try
        {
            switch (inf->type)
            {
                case 0:
                    ((UILabel *)inf->p).text = LocalizedString(inf->text);
                    break;
                case 1:
                    [((UIButton *)inf->p) setTitle:LocalizedString(inf->text) forState:UIControlStateNormal];
                    break;
                case 2:
                    ((UITextField *)inf->p).placeholder = LocalizedString(inf->text);
                    break;
                case 3:
                    for (int i = 0; i < ((UISegmentedControl *)inf->p).numberOfSegments; i++)
                    {
                        if (i < inf->texts.count)
                        {
                            NSString *str = [inf->texts objectAtIndex:i];
                            if (str != nil && str.length > 0)
                            {
                                [((UISegmentedControl *)inf->p) setTitle:LocalizedString(str) forSegmentAtIndex:i];
                            }
                        }
                    }
                    break;
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"auto localized error");
            [self.viewToText removeObject:inf];
            i--;
        }
    }
}

-(void)setViewToText:(NSMutableArray *)viewToText
{
    if (viewToText)
    {
        objc_setAssociatedObject(self, "viewToText",viewToText, OBJC_ASSOCIATION_RETAIN);
    }
}
-(NSMutableArray *)viewToText
{
    return (NSMutableArray *)objc_getAssociatedObject(self,"viewToText");
}

- (void)initAutoLocalizeView
{
    self.viewToText = [[[NSMutableArray alloc] init] autorelease];
    [self localizeView:self];
}

- (void)localizeView:(UIView *)parentView
{
    for (UIView *v in parentView.subviews)
    {
        if ([v isKindOfClass:[UILabel class]])
        {
            NSString *txt = ((UILabel *)v).text;
            if (txt.length > 1 && [txt rangeOfString:@"@"].location == 0)
            {
                txt = [txt substringFromIndex:1];
                [self.viewToText addObject:[ViewToTextInfo2 infoWithPointer:(void *)v type:0 text:txt]];
            }
        }
        else if ([v isKindOfClass:[UIButton class]])
        {
            NSString *txt = [((UIButton *)v) titleForState:UIControlStateNormal];
            if (txt.length > 1 && [txt rangeOfString:@"@"].location == 0)
            {
                txt = [txt substringFromIndex:1];
                [self.viewToText addObject:[ViewToTextInfo2 infoWithPointer:(void *)v type:1 text:txt]];
            }
        }
        else if ([v isKindOfClass:[UITextField class]])
        {
            NSString *txt = ((UITextField *)v).placeholder;
            if (txt.length > 1 && [txt rangeOfString:@"@"].location == 0)
            {
                txt = [txt substringFromIndex:1];
                [self.viewToText addObject:[ViewToTextInfo2 infoWithPointer:(void *)v type:2 text:txt]];
            }
        }
        else if ([v isKindOfClass:[UISegmentedControl class]])
        {
            UISegmentedControl *seg = (UISegmentedControl *)v;
            NSMutableArray *texts = [[NSMutableArray alloc] initWithCapacity:1];
            BOOL shouldAdd = NO;
            for (int i = 0; i < seg.numberOfSegments; i++)
            {
                NSString *txt = [seg titleForSegmentAtIndex:i];
                if ([self isAutoLocalizeViewText:txt])
                {
                    txt = [self getLocalizeViewText:txt];
                    shouldAdd = YES;
                }
                else
                {
                    txt = @"";
                }
                [texts addObject:txt];
            }
            if (shouldAdd == NO)
            {
                [texts release];
            }
            else
            {
                ViewToTextInfo2 *inf = [ViewToTextInfo2 infoWithPointer:(void *)v type:3 text:nil];
                inf->texts = texts;
                [self.viewToText addObject:inf];
            }
        }
        else
        {
            [self localizeView:v];
        }
    }
}

@dynamic viewToText;


@end
