//
//  Quyen.m
//  ViViMASS
//
//  Created by DucBui on 6/2/15.
//
//

#import "Quyen.h"

#define KEY_QUYEN_FUNC_ID @"KEY_QUYEN_FUNC_ID"
#define KEY_NGUOI_DUYET_GIAO_DICH @"KEY_NGUOI_DUYET_GIAO_DICH"
#define KEY_NGUOI_LAP_GIAO_DICH @"KEY_NGUOI_LAP_GIAO_DICH"

@implementation Quyen

- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSNumber *nguoiLapGiaoDich = [dict valueForKey:@"nguoiLapGiaoDich"];
        if(nguoiLapGiaoDich)
            self.nguoiLapGiaoDich = nguoiLapGiaoDich;
        else
            self.nguoiLapGiaoDich = [NSNumber numberWithInt:0];
        NSNumber *nguoiDuyetGiaoDich = [dict valueForKey:@"nguoiDuyetGiaoDich"];
        if(nguoiDuyetGiaoDich)
            self.nguoiDuyetGiaoDich = nguoiDuyetGiaoDich;
        else
            self.nguoiDuyetGiaoDich = [NSNumber numberWithInt:0];
        NSNumber *funcId = [dict valueForKey:@"funcId"];
        if(funcId)
            self.funcId = funcId;
        else
            self.funcId = [NSNumber numberWithInt:-1];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self)
    {    
        self.funcId = [decoder decodeObjectForKey:KEY_QUYEN_FUNC_ID];
        self.nguoiDuyetGiaoDich = [decoder decodeObjectForKey:KEY_NGUOI_DUYET_GIAO_DICH];
        self.nguoiLapGiaoDich = [decoder decodeObjectForKey:KEY_NGUOI_LAP_GIAO_DICH];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.funcId forKey:KEY_QUYEN_FUNC_ID];
    [encoder encodeObject:self.nguoiDuyetGiaoDich forKey:KEY_NGUOI_DUYET_GIAO_DICH];
    [encoder encodeObject:self.nguoiLapGiaoDich forKey:KEY_NGUOI_LAP_GIAO_DICH];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)dealloc
{
    [_nguoiDuyetGiaoDich release];
    [_nguoiLapGiaoDich release];
    [_funcId release];
    [super dealloc];
}
@end
