//
//  QuyenCuaTaiKhoan.m
//  ViViMASS
//
//  Created by DucBui on 6/2/15.
//
//

#import "QuyenCuaTaiKhoan.h"

#define KEY_ADMINISTRATOR @"KEY_ADMINISTRATOR"
#define KEY_LIST_QUYEN @"KEY_LIST_QUYEN"

@implementation QuyenCuaTaiKhoan

- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        NSNumber *administrator = [dict valueForKey:@"administrator"];
        if(administrator)
            self.administrator = administrator;
        else
            self.administrator = [NSNumber numberWithInt:0];
        NSArray *list = [dict valueForKey:@"list"];
        if(list)
        {
            NSMutableArray *arrtemp = [[NSMutableArray alloc] initWithCapacity:list.count];
            for(NSDictionary *dictQuyen in list)
            {
                Quyen *quyen = [[Quyen alloc] initWithDict:dictQuyen];
                [arrtemp addObject:quyen];
                [quyen release];
            }
            self.list = arrtemp;
            [arrtemp release];
        }
        else
        {
            self.list = [NSArray new];
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.administrator = [decoder decodeObjectForKey:KEY_ADMINISTRATOR];
        NSSet *classes = [NSSet setWithObjects:[NSArray class], [Quyen class], nil];
        self.list = [decoder decodeObjectOfClasses:classes forKey:KEY_LIST_QUYEN];
//        self.list = [decoder decodeObjectOfClass:[NSArray class] forKey:KEY_LIST_QUYEN];
//        self.list = [decoder decodeObjectForKey:KEY_LIST_QUYEN];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.administrator forKey:KEY_ADMINISTRATOR];
    [encoder encodeObject:self.list forKey:KEY_LIST_QUYEN];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)dealloc
{
    [_administrator release];
    [_list release];
    [super dealloc];
}
@end
