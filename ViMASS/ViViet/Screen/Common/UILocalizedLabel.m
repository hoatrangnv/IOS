//
//  UILocalizedLabel.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 12/12/12.
//
//

#import "UILocalizedLabel.h"
#import "LocalizationSystem.h"

@implementation UILocalizedLabel

-(void) setText:(NSString *)text
{
    super.text = LocalizedString(text);
}

@end
