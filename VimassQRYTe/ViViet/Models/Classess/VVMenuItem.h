//
//  VVMenuItem.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 11/23/12.
//
//

#import <Foundation/Foundation.h>

@interface VVMenuItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) int qty;
@property (nonatomic, assign) BOOL selected;

-(id) initWithArray:(NSArray *)data;

+(NSMutableArray *)itemsFromArray:(NSArray *)data;

@end
