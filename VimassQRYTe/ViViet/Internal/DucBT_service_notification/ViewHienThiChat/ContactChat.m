//
//  ContactChat.m
//  ViMASS
//
//  Created by DucBT on 10/20/14.
//
//

#import "ContactChat.h"

@implementation ContactChat

- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSString *idChat = [dict valueForKey:@"idChat"];
        NSString *mess = [dict valueForKey:@"mess"];
        NSString *nameAlias = [dict valueForKey:@"nameAlias"];
        NSTimeInterval time = [[dict valueForKey:@"time"] doubleValue];
        NSNumber *slTinChuaDoc = [dict valueForKey:@"slTinChuaDoc"];
        self.idChat = idChat;
        self.mess = mess;
        self.nameAlias = nameAlias;
        self.mTime = time;
        self.slTinChuaDoc = slTinChuaDoc;
    }
    return self;
}

- (void)dealloc
{
    [_idChat release];
    [_mess release];
    [_nameAlias release];
    [_slTinChuaDoc release];
    [super dealloc];
}
@end
