//
//  ContactChat.h
//  ViMASS
//
//  Created by DucBT on 10/20/14.
//
//

#import <Foundation/Foundation.h>

@interface ContactChat : NSObject
@property (nonatomic, copy) NSString *idChat;
@property (nonatomic, copy) NSString *mess;
@property (nonatomic, copy) NSString *nameAlias;
@property (nonatomic, assign) double mTime;
@property (nonatomic, copy) NSNumber *slTinChuaDoc;

- (id)initWithDict:(NSDictionary*)dict;

@end
