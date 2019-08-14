//
//  TableCategory.m
//  ViMASS
//
//  Created by Chung NV on 6/27/13.
//
//

#import "TableCategory.h"
#import "TreeTableCategoryCell.h"
#import "TableCategoryCell.h"
#import "TableCategoryCellSub.h"

#define kSUB_TABLE_WIDTH_SCALE (1.f-110.f/320.f)
#define kTABLE_PARENT_CELL_HEIGHT 50.0f
#define kTABLE_SUB_CELL_HEIGHT 44.0f

@implementation TableCategory
{
    UITableView *parentTable;
    UITableView *subTable;
    UIImageView *imgArrow;
    
    SVCategory * cateIsShown;
    
    NSInteger oldIndexSelected;
}

-(void)dealloc
{
    [parentTable release];
    [subTable release];
    [imgArrow release];
    [selected_parent release];
    [_categories release];
    [super dealloc];
}

-(NSArray *) selected_cate_IDs
{
    if (selected_parent == nil || selected_parent.count == 0)
        return nil;
    
    NSMutableArray * cate_IDs = [[NSMutableArray new] autorelease];
    for (SVCategory *c in selected_parent)
    {
        NSArray *arr = [c getSubsSelected];
        [cate_IDs addObjectsFromArray:arr];
    }
    return cate_IDs;
}

-(NSArray *)selected_categories
{
    if (selected_parent == nil || selected_parent.count == 0)
        return nil;
    NSMutableArray * cates = nil;
    for (SVCategory *c in selected_parent)
    {
        for (SVCategory *sub in c.subCates)
        {
            if (sub.selected)
            {
                if (cates == nil)
                {
                    cates = [[NSMutableArray new] autorelease];
                }
                [cates addObject:sub];
            }
        }
    }
    return cates;
}

- (NSDictionary *)getSelectedCategory {
    if (selected_parent == nil || selected_parent.count == 0)
        return nil;
    
    NSDictionary * catDict = nil;
    for (SVCategory *c in selected_parent)
    {
        catDict = [c getSubsSelectedDictionary];
    }
    return catDict;
}


-(NSMutableArray *)getSelectedCateIDs
{
//    NSString *cate_IDs = @"";
//    int i = 0;
    NSMutableArray * cateIDs = nil;
    for (SVCategory *c in selected_parent)
    {
        if (cateIDs == nil)
        {
            cateIDs = [NSMutableArray new];
        }
        NSArray *arr = [c getSelected];
        [cateIDs addObjectsFromArray:arr];
//        NSString *des = arr.description;
//        des = [des stringByReplacingOccurrencesOfString:@"[\n\\s()]"
//                                             withString:@""
//                                                options:NSRegularExpressionSearch
//                                                  range:NSMakeRange(0,des.length)];
//        if (i == selected_parent.count - 1)
//            cate_IDs = [cate_IDs stringByAppendingFormat:@"%@",des];
//        else
//            cate_IDs = [cate_IDs stringByAppendingFormat:@"%@,",des];
//        
//        i++;
    }
    return [cateIDs autorelease];
}


-(void)didSelectedChanged:(void (^)(TableCategory *))didChanged
{
    [_didSelectedChanged  release];
    _didSelectedChanged = [didChanged copy];
}

#pragma mark - Actions & Animate
-(void) didSelectCateParent:(SVCategory *) parent_cate
{
    if (cateIsShown == parent_cate)
    {
        cateIsShown = nil;
        return [self did_tapped_background];
    }
    else
        cateIsShown = parent_cate;
    
    [self sub_table_view_with_parent_cate:parent_cate];
}

-(void) didSelectCateSub:(SVCategory *) sub_cate
{
    NSInteger index = [cateIsShown.subCates indexOfObject:sub_cate];
    if(cateIsShown.catId == 18 || cateIsShown.catId == 19)
    {
        index -= 1;
    }
    if (index >=0 && index < cateIsShown.subCates.count)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        TableCategoryCellSub *cell = (TableCategoryCellSub *)[subTable cellForRowAtIndexPath:indexPath];

        if (sub_cate.selected)
            [self will_deselected:sub_cate isParent:NO];
        else
        {
            BOOL b = [self will_add_selected_category:sub_cate isParent:NO];
            if (b == NO)
                return;
        }
        
        sub_cate.selected = !sub_cate.selected;
        // sub-cell : re-set icon images again;
        [cell setTick];
        
        [self reload_cell_of_parent_cate:cateIsShown];
        if (_didSelectedChanged)
            _didSelectedChanged(self);
    }
    
}

-(void) reload_cell_of_parent_cate:(SVCategory *) pCate
{
    NSInteger index = [_categories indexOfObject:pCate];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    TableCategoryCell * cell_parent = (TableCategoryCell *)[parentTable cellForRowAtIndexPath:indexPath];
    
    // parent-cell : re-set icon images again;
    [cell_parent setTick];
}
-(void) reload_cell_of_sub_cate:(SVCategory *) subCate
{
    SVCategory *pCate = subCate.parentCate;
    if (pCate == cateIsShown)
    {
        if ([pCate.subCates containsObject:subCate])
        {
            NSInteger index = [pCate.subCates indexOfObject:subCate];
            if (subTable.hidden == NO)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                TableCategoryCellSub *cell = (TableCategoryCellSub *)[subTable cellForRowAtIndexPath:indexPath];
                [cell setTick];
            }
        }
    }
}

#define kMAX_CATEGORY_ALLOW 10
-(void) notify
{
    NSString *mes =  @"chon_nhieu_dm_qua_muc_roi_em_oi".localizableString;
    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:LocalizedString(@"Notification")
                                                     message:mes delegate:nil
                                           cancelButtonTitle:LocalizedString(@"OK")
                                           otherButtonTitles:nil, nil] autorelease];
    [alert show];
}
-(void) notify_bds
{
    NSString *mes =  @"Bạn đang chọn các danh mục của Bất động sản .Để lựa chọn danh mục khác, bạn vui lòng bỏ chọn tất cả các danh mục của Bất đông sản.";
    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:LocalizedString(@"Notification")
                                                      message:mes delegate:nil
                                            cancelButtonTitle:LocalizedString(@"OK")
                                            otherButtonTitles:nil, nil] autorelease];
    [alert show];
}
-(void) will_deselected:(SVCategory *)cate
               isParent:(BOOL) isParent
{
    if (isParent)
    {
        if ([selected_parent containsObject:cate])
        {
            [selected_parent removeObject:cate];
        }
    }else
    {
        SVCategory *parent = cate.parentCate;
        if (parent.getSubsSelected.count == 1)
        {
            if ([selected_parent containsObject:parent])
            {
                [selected_parent removeObject:parent];
            }
        }
    }
//    NSLog(@"selected_parent.count = %d",selected_parent.count);
}
-(BOOL) will_add_selected_category:(SVCategory *)cate
                          isParent:(BOOL) isParent
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(tableCategory:willSelectCategory:)])
    {
        BOOL allow = [_delegate tableCategory:self willSelectCategory:cate];
        if (allow == NO)
        {
            return NO;
        }
    }
    
    if (selected_parent == nil)
        selected_parent = [NSMutableArray new];
    if (_isSingleSelection)
    {
        for (SVCategory *cate in selected_parent)
        {
            for (SVCategory *c in cate.subCates)
            {
                if (c.selected)
                {
                    c.selected = NO;
                    [self reload_cell_of_sub_cate:c];
                }
            }
            [self reload_cell_of_parent_cate:cate];
        }
        [selected_parent removeAllObjects];
        
        SVCategory *parent_cate = isParent ? cate : cate.parentCate;
        [selected_parent addObject:parent_cate];
        return YES;
    }
    
    int maxSelected = kMAX_CATEGORY_ALLOW;
    BOOL allow_selected =  NO;
    if (selected_parent.count > 0)
    {
        // nếu đã chọn 1 vài danh mục
        int count = 0;
        for (SVCategory *c  in selected_parent)
        {
            count += c.getSubsSelected.count;
        }
        if (isParent)
        {
            // did tick all
            allow_selected = count + cate.subCates.count <= maxSelected;
        }else
        {
            // did tick a sub cate
            allow_selected = count < maxSelected;
        }
    }else
    {
        // nếu chưa chọn danh mục nào
        allow_selected = YES;
    }
    
    
    if (allow_selected)
    {
        SVCategory *parent_cate = isParent ? cate : cate.parentCate;
        if ([selected_parent containsObject:parent_cate] == NO)
            [selected_parent addObject:parent_cate];
    
    }else if (_isSingleSelection == NO)
    {
        [self notify];
    }
    return allow_selected;
}
#pragma mark - SEL(s)
-(void)did_table_parent_ticked_clicked:(UIButton *)bt
{
    UIView *cell = bt.superview;
    while (cell != nil && [cell isKindOfClass:[TableCategoryCell class]] == NO)
    {
        cell = cell.superview;
    }
    if ([cell isKindOfClass:[TableCategoryCell class]])
    {
        SVCategory *cate = ((TableCategoryCell *)cell).category;
        
        BOOL b = [self will_add_selected_category:cate
                                         isParent:YES];
        if (b == NO)
            return;
        cate.selected = YES;
        
        // re-set icon images again;
        [((TableCategoryCell *)cell) setTick];
        if (_didSelectedChanged)
            _didSelectedChanged(self);
    }
    
}
-(void)did_table_parent_remove_clicked:(UIButton *)bt
{
    UIView *cell = bt.superview;
    while (cell != nil && [cell isKindOfClass:[TableCategoryCell class]] == NO)
    {
        cell = cell.superview;
    }
    BOOL didChanged = NO;
    if ([cell isKindOfClass:[TableCategoryCell class]])
    {
        SVCategory *cate = ((TableCategoryCell *)cell).category;
        [self will_deselected:cate isParent:YES];
        didChanged = YES;
        cate.selected = NO;
        
        // re-set icon images again;
        [((TableCategoryCell *)cell) setTick];
    }
    if (didChanged)
        _didSelectedChanged(self);
}


#pragma mark - Datasource & Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == parentTable)
    {
        if(self.mKieuHienThiTimKiem == 18 || self.mKieuHienThiTimKiem == 19)
        {
            int nViTri = [self layViTriCuaCateID:self.mKieuHienThiTimKiem];
            SVCategory *cate = [_categories objectAtIndex:nViTri];
            if(indexPath.row == 0)
            {
                for(SVCategory *c in cate.subCates)
                {
                    [c setSelected:YES];
                }
            }
            else
            {
                for(int i = 0; i < cate.subCates.count; i ++)
                {
                    SVCategory *c = [cate.subCates objectAtIndex:i];
                    if(i == indexPath.row)
                        [c setSelected:YES];
                    else
                        [c setSelected:NO];
                }
            }

        }
        else
        {
            SVCategory *parent_cate = [_categories objectAtIndex:indexPath.row];
            [self didSelectCateParent:parent_cate];
        }
    }else
    {
        NSInteger nIndex = indexPath.row;
        if(cateIsShown.catId == 18 || cateIsShown.catId == 19)
        {
            nIndex += 1;
        }
        if (cateIsShown == nil  || cateIsShown.subCates == nil || cateIsShown.subCates.count <= nIndex)
            NSLog(@"ERROR %s",__FUNCTION__);

        SVCategory *sub_cate = [cateIsShown.subCates objectAtIndex:nIndex];
        [self didSelectCateSub:sub_cate];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_categories)
    {
        if (tableView == parentTable)
        {
            if(self.mKieuHienThiTimKiem == 18 || self.mKieuHienThiTimKiem == 19)
            {
                int nViTri = [self layViTriCuaCateID:self.mKieuHienThiTimKiem];
                SVCategory *cate = [_categories objectAtIndex:nViTri];
                if(cate.subCates)
                    return cate.subCates.count;
                return 0;
            }
            return _categories.count;
        }
        else
        {
            if (cateIsShown && cateIsShown.subCates)
            {
                if(cateIsShown.catId == 18 || cateIsShown.catId == 19)
                    //Neu ma la bat dong san va viec lam se bo 1 dong.
                    return cateIsShown.subCates.count - 1;
                else

                    return cateIsShown.subCates.count;
            }
            else
                return 0;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == parentTable)
    {
        static NSString * ID = @"TableCategoryCell";
        TableCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil)
        {
            cell = (TableCategoryCell *)[[[NSBundle mainBundle] loadNibNamed:@"TableCategoryCell" owner:nil options:nil] objectAtIndex:0];
            
            [cell->btTick addTarget:self action:@selector(did_table_parent_ticked_clicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell->btRemove addTarget:self action:@selector(did_table_parent_remove_clicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell->btTick.tag = indexPath.row;
        cell->btRemove.tag = indexPath.row;
        if (_isSingleSelection)
            [cell->btTick removeFromSuperview];
        if(self.mKieuHienThiTimKiem == 18 || self.mKieuHienThiTimKiem == 19)
        {

            int nViTri = [self layViTriCuaCateID:self.mKieuHienThiTimKiem];
            SVCategory *cate = [_categories objectAtIndex:nViTri];
            SVCategory *subCate = [cate.subCates objectAtIndex:indexPath.row];
            [cell setCategory:subCate];
            
            [cell->btCount setHidden:YES];
            [cell->btTick setHidden:YES];
            [cell->btRemove setHidden:YES];
        }
        else
        {
            cell->btCount.hidden = NO;
            cell->btTick.hidden = NO;
            cell->btRemove.hidden = NO;
            SVCategory *cate = [_categories objectAtIndex:indexPath.row];
            [cell setCategory:cate];
        }

        
        return cell;

    }else
    {
        static NSString * ID = @"TableCategoryCellSub";
        TableCategoryCellSub *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil)
        {
            cell = (TableCategoryCellSub *)[[[NSBundle mainBundle] loadNibNamed:@"TableCategoryCellSub" owner:nil options:nil] objectAtIndex:0];
        }
        
        NSInteger nIndex = indexPath.row;
        if(cateIsShown.catId == 18 || cateIsShown.catId == 19)
        {
            nIndex += 1;
        }
        
        SVCategory *sub = [cateIsShown.subCates objectAtIndex:nIndex];
        [cell setCategory:sub];
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == parentTable)
    {
        return kTABLE_PARENT_CELL_HEIGHT;
    }
    else
    {
        NSInteger nIndex = indexPath.row;
        if(cateIsShown.catId == 18 || cateIsShown.catId == 19)
        {
            nIndex += 1;
        }
        SVCategory *sub = [cateIsShown.subCates objectAtIndex:nIndex];
        NSString *name = sub.name;
        UIFont *font = [UIFont systemFontOfSize:16];
        CGSize limit = CGSizeMake(self.frame.size.width * kSUB_TABLE_WIDTH_SCALE, 99999);
        
        CGSize sz = [name sizeWithFont:font constrainedToSize:limit lineBreakMode:NSLineBreakByWordWrapping];
        
        float height = sz.height + 20;
        if (height < kTABLE_PARENT_CELL_HEIGHT)
        {
            height = kTABLE_PARENT_CELL_HEIGHT;
        }
        return height;
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == parentTable)
    {
        [self did_tapped_background];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == parentTable)
    {
        [self did_tapped_background];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == parentTable)
    {
        [self did_tapped_background];
    }
}

#pragma mark - private method
- (int)layViTriCuaCateID:(int)nCateID
{
    for(int i = 0; i < _categories.count; i ++)
    {
        SVCategory *cate = [_categories objectAtIndex:i];
        if(cate.catId == nCateID)
            return i;
    }
    return 0;
}

#pragma mark - Public Method
-(void)setCategories:(NSArray *)categories
{
    if (categories != _categories)
    {
        [_categories release];
        _categories = [categories retain];
        for (SVCategory *cate in _categories)
        {
            if (cate.getSelected.count > 0)
            {
                if (selected_parent == nil)
                    selected_parent = [NSMutableArray new];
                [selected_parent addObject:cate];
            }
        }
        [parentTable reloadData];
    }
}

#pragma mark - Init Views
-(void)did_tapped_background
{
    if (oldIndexSelected >= 0 && oldIndexSelected < _categories.count)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:oldIndexSelected inSection:0];
        [parentTable deselectRowAtIndexPath:indexPath animated:NO];
        oldIndexSelected = -1;
    }
    
    if (subTable)
    {
        subTable.hidden = YES;
    }
    if (imgArrow)
    {
        imgArrow.hidden = YES;
    }
}
-(void) sub_table_view_with_parent_cate:(SVCategory *) parent_cate
{
    if (parent_cate == nil)
        return;
    
    CGRect sFrame = self.frame;
    if (oldIndexSelected >= 0 && oldIndexSelected < _categories.count)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:oldIndexSelected inSection:0];
        [parentTable deselectRowAtIndexPath:indexPath animated:YES];
        
        /*TableCategoryCell *cell = (TableCategoryCell *)[parentTable cellForRowAtIndexPath:indexPath];
        if (cell)
            cell->wrapper.backgroundColor = [UIColor whiteColor];
         */
    }
    NSInteger index = [_categories indexOfObject:parent_cate];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    TableCategoryCell *cell = (TableCategoryCell *)[parentTable cellForRowAtIndexPath:indexPath];
    
    if (index != oldIndexSelected)
    {
        oldIndexSelected = index;
        [parentTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    if (parent_cate.subCates == nil || parent_cate.subCates.count == 0)
    {
        subTable.hidden = YES;
        return;
    }
    
    float originY,originX;
    float width = sFrame.size.width * kSUB_TABLE_WIDTH_SCALE;
    
    originX = sFrame.size.width - width;
    
    CGSize subTable_size;
    if (subTable == nil)
    {
        subTable = [[UITableView alloc] initWithFrame:CGRectMake(originX, 0, width, 500)
                                                style:UITableViewStylePlain];
        [self addSubview:subTable];
        
        subTable.delegate = self;
        subTable.dataSource = self;
        [subTable reloadData];
        subTable.bounces = NO;
        subTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        subTable.backgroundColor = [UIColor clearColor];
        subTable.showsHorizontalScrollIndicator = NO;
        subTable.showsVerticalScrollIndicator = NO;
        subTable.hidden = YES;
        subTable_size = subTable.contentSize;
    }
    else
    {
        [subTable reloadData];
        subTable_size = subTable.contentSize;
        parentTable.userInteractionEnabled = NO;
    }
    
    CGRect cellFrame = cell.frame;
    float height = subTable_size.height;//parent_cate.subCates.count * kTABLE_SUB_CELL_HEIGHT;
    
    if (height == 0)
        return;
    
    height = height > sFrame.size.height ? sFrame.size.height : height;
    
    CGFloat dCell_to_top = cellFrame.origin.y - parentTable.contentOffset.y;
    CGFloat dCell_to_bottom = parentTable.frame.size.height - dCell_to_top;
    if (height > dCell_to_bottom)
        originY = sFrame.size.height - height;
    else
        originY = dCell_to_top;
    originY = originY > 0 ? originY : 0;
    CGRect sub_frame = CGRectMake(originX, originY, width, height);
    
    [UIView animateWithDuration:0.3 animations:^
    {
        subTable.frame = sub_frame;
        subTable.hidden = NO;
    } completion:^(BOOL finished)
    {
        parentTable.userInteractionEnabled = YES;
    }];
}

#pragma mark - 
-(void)setSelectedCateIDs:(NSString *)cateIds
{
    for (SVCategory *pCate in _categories)
    {
        pCate.selected = NO;
    }
    if (selected_parent)
    {
        [selected_parent removeAllObjects];
    }else
    {
        selected_parent = [NSMutableArray new];
    }
    for (SVCategory *pCate in _categories)
    {
        for (SVCategory *sCate in pCate.subCates)
        {
            NSString *cID = [NSString stringWithFormat:@",%d,",sCate.catId];
            if ([cateIds likeString:cID])
            {
                sCate.selected = YES;
                if ([selected_parent containsObject:pCate] == NO)
                {
                    [selected_parent addObject:pCate];
                }
            }
        }
    }
    [parentTable reloadData];
//    [self did_tapped_background];
}
#pragma mark - Init
-(void) _init
{
    CGRect r = self.frame;
    r.origin = CGPointZero;
    parentTable = [[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    parentTable.autoresizingMask =
                                UIViewAutoresizingFlexibleWidth
                                | UIViewAutoresizingFlexibleHeight
                                | UIViewAutoresizingFlexibleLeftMargin
                                | UIViewAutoresizingFlexibleRightMargin
                                | UIViewAutoresizingFlexibleTopMargin
                                | UIViewAutoresizingFlexibleBottomMargin;
    parentTable.delegate = self;
    parentTable.dataSource = self;
    parentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    parentTable.separatorColor = [UIColor colorWithRed:171.0/255 green:171.0/255 blue:172.0/255 alpha:1];
    [self addSubview:parentTable];
    oldIndexSelected = -1;
}
-(TableCategory *) initWithFrame:(CGRect)rect
               isSingleSelection:(BOOL)singleSelection
{
    if (self = [self initWithFrame:rect])
    {
        _isSingleSelection = singleSelection;
    }
    return self;
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
    if (self = [super initWithFrame:frame])
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
@end
