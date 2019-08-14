//
//  TreeCategory.m
//  ViMASS
//
//  Created by Chung NV on 6/13/13.
//
//

#import "SVCategory.h"
#import "JSONKit.h"
@implementation SVCategory
-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.showSubCate = NO;
        self.selected = NO;
        
        self.catId = [[dict objectForKey:@"catId"] intValue];
        
        NSString *temp = [dict objectForKey:@"name"];
        self.name = [temp isKindOfClass:[NSNull class]] ? nil : temp;
        
        NSArray * subs_arr = [dict objectForKey:@"childs"];
        if (subs_arr != nil && subs_arr.count > 0)
        {
            NSMutableArray *subs = [NSMutableArray new];
            for (NSDictionary *sub_dict in subs_arr)
            {
                SVCategory *sub_cate = [[SVCategory alloc] initWithDictionary:sub_dict];
                sub_cate.parentCate = self;
                [subs addObject:sub_cate];
                [sub_cate release];
            }
            self.subCates = subs;
            [subs release];
        }
    }
    return self;
}
-(NSArray *) getSubsSelected
{
    NSMutableArray *selected = [NSMutableArray new];
    
    for (SVCategory * cate in _subCates)
    {
        if (cate.selected)
        {
            [selected addObject:[NSString stringWithFormat:@"%d",cate.catId]];
        }
    }
    if (selected.count > 0)
    {
        return [selected autorelease];
    }else
    {
        [selected release];
        return nil;
    }
}

//TAG: HOANGPH 28/08/2013
-(NSDictionary *) getSubsSelectedDictionary {
    NSMutableDictionary *selected = [NSMutableDictionary new];
    for (SVCategory * cate in _subCates) {
        if (cate.selected) {
            [selected setObject:cate.name forKey:[NSString stringWithFormat:@"%d",cate.catId]];
        }
    }
    if (selected.count > 0) {
        return [selected autorelease];
    } else {
        [selected release];
        return nil;
    }
}

-(NSArray *)getSelected
{
    NSMutableArray *selected = [NSMutableArray new];
    
    for (SVCategory * cate in _subCates)
    {
        if (cate.selected)
        {
            [selected addObject:[NSString stringWithFormat:@"%d",cate.catId]];
        }
    }
    if (selected.count > 0)
    {
//        [selected addObject:[NSString stringWithFormat:@"%d",self.catId]];
        return [selected autorelease];
    }else
    {
        [selected release];
        return nil;
    }
}

/*Sửa load danh sách BDS + Việc làm (bỏ item tất cả ở danh sách trong searchview)*/
-(NSString *) subCateIDs
{
    NSMutableArray *cateIDs = [NSMutableArray new];
//    if(_catId == 19 || _catId == 18)
//       [_subCates removeObjectAtIndex:0];
    for (SVCategory * cate in _subCates)
    {
        [cateIDs addObject:[NSString stringWithFormat:@"%d",cate.catId]];
    }
    [cateIDs addObject:[NSString stringWithFormat:@"%d",self.catId]];
    NSString *ids = [cateIDs JSONString];
    [cateIDs release];
    return ids;
}
-(void)setSelected:(BOOL)selected
{
    _selected = selected;
    for (SVCategory *c in self.subCates)
    {
        c.selected = selected;
    }
}
@end
