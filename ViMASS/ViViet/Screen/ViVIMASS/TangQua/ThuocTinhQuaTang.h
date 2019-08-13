//
//  ThuocTinhQuaTang.h
//  ViViMASS
//
//  Created by DucBT on 2/27/15.
//
//

#import <Foundation/Foundation.h>

@interface ThuocTinhQuaTang : NSObject <NSCopying>

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *font;
@property (nonatomic, copy) NSNumber *size;
@property (nonatomic, copy) NSNumber *line;
@property (nonatomic, copy) NSNumber *style;
@property (nonatomic, copy) NSString *css;

- (id)initWithDict:(NSDictionary*)dict;

@end
