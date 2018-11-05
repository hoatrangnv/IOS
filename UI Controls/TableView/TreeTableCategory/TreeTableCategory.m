//
//  TreeTableCategory.m
//  ViMASS
//
//  Created by Chung NV on 6/13/13.
//
//

#import "TreeTableCategory.h"
#import "TreeTableCategoryCell.h"
#import "SVCategory.h"

#import "Common.h"
@implementation TreeTableCategory
{
    NSMutableArray *header_views;
    void(^_didSelectedRow)(id object_selected);
}
-(void)setDatas:(NSArray *)datas
{
    if (datas != _datas)
    {
        [_datas release];
        _datas = [datas retain];
        [self reloadData];
    }
}

-(NSArray *)getSelectedCategories
{
    NSMutableArray * cates_selected = [NSMutableArray new];
    for (SVCategory *c in _datas)
    {
        NSArray *selected = [c getSelected];
        if (selected && selected.count > 0)
        {
            [cates_selected addObjectsFromArray:selected];
        }
    }
    return [cates_selected autorelease];
}
-(void)didSelectedRow:(void (^)(id))didSelectedRow
{
    [_didSelectedRow release];
    _didSelectedRow = [didSelectedRow copy];
}

#pragma mark - Header TICK : did clicked

-(void)bt_expanding_section:(UIButton *)bt
{
    SVCategory *cate = [_datas objectAtIndex:bt.tag];
    cate.showSubCate = !cate.showSubCate;
    [self reloadSections:[NSIndexSet indexSetWithIndex:bt.tag]
        withRowAnimation:UITableViewRowAnimationFade];
}
-(void)header_clicked:(UIButton *)bt
{
    UIView *v = [bt superview];
    UIImage *img_tick = nil;
    if (v && v.tag % 2 == 0)
    {
        img_tick = [UIImage imageNamed:@"left_untick"];
    }else
    {
        img_tick = [UIImage imageNamed:@"left_tick"];
    }
    if (v)
    {
        v.tag = v.tag +1;
    }
    [bt setImage:img_tick forState:UIControlStateNormal];
    
    SVCategory *cate = [_datas objectAtIndex:bt.tag];
    BOOL isSelected = cate.selected;
    cate.selected = !isSelected;
    [self reloadSections:[NSIndexSet indexSetWithIndex:bt.tag]
        withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - DataSource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _datas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SVCategory *cate = [_datas objectAtIndex:section];
    if (cate.showSubCate == NO || cate.subCates == nil)
        return 0;
    else
        return cate.subCates.count;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"TreeTableCategoryCell";
    TreeTableCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil)
    {
        cell = (TreeTableCategoryCell *)[[[NSBundle mainBundle] loadNibNamed:@"TreeTableCategoryCell" owner:nil options:nil] objectAtIndex:0];
    }
    SVCategory *cate = [_datas objectAtIndex:indexPath.section];
    
    NSArray *subs = cate.subCates;
    [cell setCategory:[subs objectAtIndex:indexPath.row]];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (header_views == nil)
        header_views = [[NSMutableArray alloc] initWithCapacity:1];
    
    if (section < header_views.count)
    {
        return [header_views objectAtIndex:section];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    v.tag = 1;
    
    v.backgroundColor = [UIColor clearColor];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:v.frame];
    bg.image = [Common stretchImage:@"cell_left_bg"];
    [v addSubview:bg];
    [bg release];
    
    CGRect r = v.frame;
    r.origin.x = 10;
    r.size.width -=10;
    UILabel *lbl = [[UILabel alloc] initWithFrame:r];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont boldSystemFontOfSize:14];
    lbl.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    
    SVCategory *cate = [_datas objectAtIndex:section];
    NSString * name = cate.name;
    lbl.text = name;
    [v addSubview:lbl];
    [lbl release];
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,v.frame.size.width - 40, v.frame.size.height)];
    bt.backgroundColor = [UIColor clearColor];
    bt.tag = section;
    [bt addTarget:self action:@selector(bt_expanding_section:) forControlEvents:UIControlEventTouchUpInside];
    
    [v addSubview:bt];
    [v bringSubviewToFront:bt];
    [bt release];
    
    bt = [[UIButton alloc] initWithFrame:CGRectMake(v.frame.size.width - 40, 0, 40, v.frame.size.height)];
    [bt setImage:[UIImage imageNamed:@"left_untick"] forState:UIControlStateNormal];
    bt.backgroundColor = [UIColor clearColor];
    bt.tag = section;
    [bt addTarget:self action:@selector(header_clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [v addSubview:bt];
    [v bringSubviewToFront:bt];
    [bt release];
    
    [header_views addObject:v];
    [v release];

    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didSelectedRow)
    {
        SVCategory *cate = [_datas objectAtIndex:indexPath.section];
        id object = [cate.subCates objectAtIndex:indexPath.row];
        _didSelectedRow(object);
    }
}

#pragma mark - Inherit


#pragma mark - Inherit
-(void) _init
{
    self.delegate = self;
    self.dataSource = self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self _init];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _init];
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        [self _init];
    }
    return self;
}

-(void)dealloc
{
    [_datas release];
    [super dealloc];
}
@end
