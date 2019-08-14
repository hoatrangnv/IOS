//
//  ItemQuaTang.m
//  ViViMASS
//
//  Created by DucBT on 2/27/15.
//
//

#import "ItemQuaTang.h"

@implementation ItemQuaTang

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        int Id = [[dict valueForKey:@"id"] intValue];
        NSNumber *nId = [NSNumber numberWithInt:Id];
        NSNumber *nType = [dict valueForKey:@"type"];
        NSString *sImage = [dict valueForKey:@"image"];
        NSDictionary *dictName = [dict valueForKey:@"name"];
        ThuocTinhQuaTang *thuocTinName = [[ThuocTinhQuaTang alloc] initWithDict:dictName];
        NSDictionary *dictMessage = [dict valueForKey:@"message"];
        ThuocTinhQuaTang *thuocTinMessage = [[ThuocTinhQuaTang alloc] initWithDict:dictMessage];
        NSDictionary *dictAmount = [dict valueForKey:@"amount"];
        ThuocTinhQuaTang *thuocTinAmount = [[ThuocTinhQuaTang alloc] initWithDict:dictAmount];
        NSNumber *nStatus = [dict valueForKey:@"status"];
        NSNumber *nPos = [dict valueForKey:@"pos"];
        self.mId = nId;
        self.mType = nType;
        self.mImage = sImage;
        self.mName = thuocTinName;
        self.mMessage = thuocTinMessage;
        self.mAmount = thuocTinAmount;
        self.mStatus = nStatus;
        self.mPos = nPos;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ItemQuaTang *another = [[ItemQuaTang alloc] init];
    another.mId = [_mId copy];
    another.mType = [_mType copy];
    another.mImage = [_mImage copy];
    another.mName = [_mName copy];
    another.mMessage = [_mMessage copy];
    another.mAmount = [_mAmount copy];
    another.mStatus = [_mStatus copy];
    another.mPos = [_mPos copy];
    return another;
}

- (void)dealloc
{
    [_mId release];
    [_mType release];
    [_mImage release];
    [_mName release];
    [_mMessage release];
    [_mAmount release];
    [_mStatus release];
    [_mPos release];
    [super dealloc];
}
@end
