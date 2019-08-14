//
//  HomeProtocol.h
//  ViViMASS
//
//  Created by Mac Mini on 10/15/18.
//

#import <Foundation/Foundation.h>

@protocol RowSelectDelegate
- (void)didSelectRow:(int)row withTab:(int)tab;
@end
