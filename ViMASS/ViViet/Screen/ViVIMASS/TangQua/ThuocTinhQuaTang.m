//
//  ThuocTinhQuaTang.m
//  ViViMASS
//
//  Created by DucBT on 2/27/15.
//
//

#import "ThuocTinhQuaTang.h"

@implementation ThuocTinhQuaTang

- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSString *content = [dict valueForKey:@"content"];
        NSString *color = [dict valueForKey:@"color"];
        NSString *font = [dict valueForKey:@"font"];
        NSNumber *size = [dict valueForKey:@"size"];
        NSNumber *line = [dict valueForKey:@"line"];
        NSNumber *style = [dict valueForKey:@"style"];
        NSString *css = [dict valueForKey:@"css"];
        self.content = content;
        self.color = color;
        self.font = font;
        self.size = size;
        self.line = line;
        self.style = style;
        self.css = css;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ThuocTinhQuaTang *another = [[ThuocTinhQuaTang alloc] init];
    another.content = _content;
    another.color = _color;
    another.font = _font;
    another.size = _size;
    another.line = _line;
    another.style = _style;
    another.css = _css;
    return another;
}

- (void)dealloc
{
    [_content release];
    [_color release];
    [_font release];
    [_size release];
    [_line release];
    [_style release];
    [_css release];
    [super dealloc];
}

@end
