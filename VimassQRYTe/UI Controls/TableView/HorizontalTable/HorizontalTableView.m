//
//  HorizontalTableView.m
//  Test_HorizontalTable
//
//  Created by Chung NV on 2/15/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//
#import "HorizontalTableView.h"
#import "HorizontalTableViewCell.h"

@implementation HorizontalTableView
{
    id<UITableViewDelegate> ext_delegate;
    void (^update_more_callback)(HorizontalTableView *table);
    BOOL is_loading;
    
    void (^_didSelectedRow)(id object);
    void (^_didEndDragging)(HorizontalTableView *table);
    void (^_willBeginDragging)(HorizontalTableView *table);
    void (^_didScrollEndAnimation)(HorizontalTableView *table);
}

-(void)dealloc
{
    printf("\n\n~~~~~~~~~~~~~~~ DEALLOCATED: %s\n\n", NSStringFromClass([self class]).UTF8String);
    if (update_more_callback)
        [update_more_callback release];
    
    [_didSelectedRow release];
    [_didEndDragging release];
    [_didScrollEndAnimation release];
    [_cellClass release];
    [_datas release];
    [super dealloc];
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    ext_delegate = delegate;
}

- (void)set_update_more_handle:(void (^)(HorizontalTableView *table))_update_more_callback;
{
    update_more_callback = [_update_more_callback copy];
}
//- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
//shouldRecognizeSimultaneouslyWithGestureRecognizer:
//(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]])
//    {
//        UIScrollView *scr = otherGestureRecognizer.view;
//        if (scr.contentOffset.x >= scr.contentSize.height - scr.bounds.size.height)
//        {
//            printf("yes1\n");
//            return YES;
//        }
//        
//        if (scr.contentOffset.y >= scr.contentSize.width - scr.bounds.size.width)
//        {
//            printf("yes2\n");
//            return YES;
//        }
//    }
//    return NO;
//}
-(void)didSelectedRow:(void (^)(id))didSelectedRow
{
    [_didSelectedRow release];
    _didSelectedRow = [didSelectedRow copy];
}
-(void)willBeginDragging:(void (^)(HorizontalTableView *))willBeginDragging
{
    [_willBeginDragging release];
    _willBeginDragging = [willBeginDragging copy];
}
-(void)didEndDragging:(void (^)(HorizontalTableView *table))didEndDragging
{
    [_didEndDragging release];
    _didEndDragging = [didEndDragging copy];
}
-(void)didScrollEndAnimation:(void (^)(HorizontalTableView *tbl))didScrollEndAnimation
{
    [_didScrollEndAnimation release];
    _didScrollEndAnimation = [didScrollEndAnimation copy];
}
#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder 
{	
	if (self = [super initWithCoder:aDecoder]) 
    {
		CGRect frame = self.frame;
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity,-M_PI_2);
		self.frame = frame;
        [self _init];
	}
	return self;
}

-(void) _init
{
    super.dataSource = self;
    super.delegate = self;
    _makeCellFull = YES;
}

-(void)setDatas:(NSMutableArray *)datas
{
    if (datas != _datas)
    {
        [_datas release];
        if ([datas isKindOfClass:[NSArray class]] && [datas isKindOfClass:[NSMutableArray class]] == NO)
            datas = [NSMutableArray arrayWithArray:datas];
        
        _datas = [datas retain];
    }
    
    [self reloadData];
}


#pragma mark - DATASOURCE && DELEGATE
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num_row = _datas ? _datas.count : 0;
    return num_row;
}
-(UITableViewCell*)tableView:(UITableView*)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class cellClass = NSClassFromString(_cellClass);
    if (cellClass == nil) {
        NSLog(@"CELL CLASS = NIL");
        return nil;
    }
    NSString *identify =[cellClass identify];
    HorizontalTableViewCell* cell = nil;
    cell = [_tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:_cellClass owner:nil options:nil];
        cell = (HorizontalTableViewCell*) [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    id data = [_datas objectAtIndex:indexPath.row];
    [cell setData:data];
    return cell;
}


-(CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class cellClass = NSClassFromString(_cellClass);
    if (cellClass == nil) {
        NSLog(@"CELL CLASS = NIL");
    }
    if ([cellClass respondsToSelector:@selector(heightWithData:)])
    {
        id data = [_datas objectAtIndex:indexPath.row];
        return [cellClass heightWithData:data];
    }
    if ([cellClass respondsToSelector:@selector(heightWithDatas:atIndexPath:)])
    {
        return [cellClass heightWithDatas:_datas atIndexPath:indexPath];
    }
    return [cellClass height];
}
-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didSelectedRow)
    {
        _didSelectedRow([_datas objectAtIndex:indexPath.row]);
    }
}
- (void)reloadData
{
    is_loading = NO;
    [super reloadData];
}
#pragma mark - UITableView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([ext_delegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [ext_delegate scrollViewDidScroll:scrollView];

    if (update_more_callback != nil && is_loading == NO && scrollView.contentOffset.y - scrollView.contentSize.height + self.frame.size.width + 50 >= 0)
    {
        is_loading = YES;
        update_more_callback (self);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_willBeginDragging)
    {
        _willBeginDragging(self);
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_didEndDragging)
    {
        _didEndDragging(self);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollViewDidScroll");
//}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                    withVelocity:(CGPoint)velocity
             targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (_makeCellFull == NO)
    {
        [self scrollingWithVelocity:velocity targetContentOffset:targetContentOffset];
        return;
    }
        
    HorizontalTableView *tbl = (HorizontalTableView *)scrollView;
    NSIndexPath* indexPath = [tbl indexPathForRowAtPoint:(*targetContentOffset)];
    
//    int number_rows_invisible = [tbl numberOfRowsInSection:0] - tbl.visibleCells.count;
    //    NSLog(@"%d - %d",indexPath.row,number_rows_invisible);
    if (tbl.contentSize.height - tbl.contentOffset.y > tbl.frame.size.width)
    {
        // Set new target
        (*targetContentOffset) = [tbl rectForRowAtIndexPath:indexPath].origin;
    }
    else
    {
        /*
         * SET ContentInset Bottom in file .xib
         **/
//        UIEdgeInsets edge = tbl.contentInset;
//        edge.bottom = 10;
//        tbl.contentInset = edge;
    }
    [self scrollingWithVelocity:velocity targetContentOffset:targetContentOffset];
}

-(void) scrollingWithVelocity:(CGPoint)velocity
          targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_didScrollEndAnimation)
    {
        _didScrollEndAnimation(self);
    }
}

-(void)insertMoreData:(NSArray *)moreData
{
    if (moreData != nil && moreData.count > 0)
    {
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        __block HorizontalTableView *weak = self;
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            [weak beginUpdates];
            for (id data in moreData)
            {
                [weak.datas addObject:data];
                [weak insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_datas.count-1 inSection:0]]
                            withRowAnimation:UITableViewRowAnimationBottom];
            }
            [weak endUpdates];
        });
    }
}

@end
