//
//  TheNapTien.h
//  ViViMASS
//
//  Created by DucBui on 4/20/15.
//
//

#import <Foundation/Foundation.h>

@interface TheNapTien : NSObject

@property (nonatomic, copy) NSString *idBank;
@property (nonatomic, copy) NSString *idTheBankNet;
@property (nonatomic, copy) NSString *linkAnh;
@property (nonatomic, copy) NSNumber *doDai;


- (id)initWithDictionary:(NSDictionary*)dict;

@end
