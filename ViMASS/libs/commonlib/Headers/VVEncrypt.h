//
//  VVEncrypt.h
//  ViMASS
//
//  Created by Chung NV on 4/25/13.
//
//

#import <Foundation/Foundation.h>

@interface VVEncrypt : NSObject

@property (nonatomic, assign) int min;
@property (nonatomic, assign) int max;
@property (nonatomic, assign) int layer;

-(id) initWithMin:(int) min
              max:(int) max
            layer:(int) layer;

+(NSString*) getAppToken;
+(NSString*) getAppToken:(NSString*) account timeOut:(long int) timeout;
-(NSString*) getEncrypt:(NSString*) strInput;

@end
