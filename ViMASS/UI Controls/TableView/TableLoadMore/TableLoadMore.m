//
//  TableLoadMore.m
//  ViMASS
//
//  Created by Chung NV on 6/10/13.
//
//

#import "TableLoadMore.h"
#import "SVPullToRefresh.h"

@implementation TableLoadMore

-(void)dealloc
{
    [didBeginReload release];
    [didBeginLoadMore release];
    [didSelectedRow release];
    [didScrolling release];
    
    [_cellClass release];
    [_datas release];
    
    [super dealloc];
}

#pragma mark - Public
-(void)stopAnimating_reload
{
    [self.pullToRefreshView performSelector:@selector(stopAnimating)
                                 withObject:nil afterDelay:0.0];
}
-(void)stopAnimating_load_more
{
    [self.infiniteScrollingView performSelector:@selector(stopAnimating)
                                     withObject:nil afterDelay:0.0];
}

-(void)didSelectedRow:(void (^)(id))selectedRow
{
    [didSelectedRow release];
    didSelectedRow = [selectedRow copy];
}
-(void)didBeginReload:(void (^)())beginReload
{
    [didBeginReload release];
    didBeginReload = [beginReload copy];
    
    if (didBeginReload)
    {
        __block TableLoadMore * weak = self;
        [self addPullToRefreshWithActionHandler:^
         {
             if (didBeginReload)
             {
                 didBeginReload();
                 [weak stopAnimating_reload];
             }
             else
                 [weak stopAnimating_reload];
         }];
    }
}
-(void)didBeginLoadMore:(void (^)())beginLoadMore
{
    [didBeginLoadMore release];
    didBeginLoadMore = [beginLoadMore copy];
    if (didBeginLoadMore)
    {
        __block TableLoadMore *weak = self;
        [self addInfiniteScrollingWithActionHandler:^
         {
             if (weak->didBeginLoadMore)
                 weak->didBeginLoadMore();
             else
                 [weak stopAnimating_load_more];
         }];
    }
}

-(void)didScrolling:(void (^)())didScrolling_
{
    [didScrolling  release];
    didScrolling = [didScrolling_ copy];
}

-(void)insertMoreData:(NSArray *)moreData animated:(BOOL)animated
{
    if (animated)
    {
        [self insertMoreData:moreData];
    }else
    {
        if (_datas)
        {
            [_datas addObjectsFromArray:moreData];
            [self reloadData];
        }else
        {
            NSMutableArray *muArray = nil;
            if ([moreData isKindOfClass:[NSMutableArray class]])
            {
                muArray = (NSMutableArray *)moreData;
            }else
            {
                muArray = [NSMutableArray arrayWithArray:moreData];
            }
            self.datas = muArray;
        }
    }
}

-(void)insertMoreData:(NSArray *)moreData
{
//    _datas = nil;
    if (moreData != nil && moreData.count > 0)
    {
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        __block TableLoadMore *weak = self;
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
            [weak stopAnimating_load_more];
        });
        return;
    }
    [self stopAnimating_load_more];
    return;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    if (didScrolling)
    {
        didScrolling();
    }
}

#pragma mark - DATASOURCE 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_datas)
    {
        return _datas.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class cell_class = NSClassFromString(_cellClass);
    if ([cell_class isSubclassOfClass:[TableLoadMoreCell class]])
    {
        NSString *identify = [cell_class identify];
        TableLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil)
        {
            /* 
             * Cell must be Init by NibName
             */
            cell = [[[NSBundle mainBundle] loadNibNamed:_cellClass owner:nil options:nil] objectAtIndex:0];
            if (_isSelectedBackground == NO)
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (_cellDelegate)
                cell.cellDelegate = _cellDelegate;
        }
        id data = [_datas objectAtIndex:indexPath.row];
        [cell setData:data];
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class cell_class = NSClassFromString(_cellClass);
    if ([cell_class respondsToSelector:@selector(heightWithData:)])
    {
        id data = [_datas objectAtIndex:indexPath.row];
        return [cell_class heightWithData:data];
    }
    
    if ([cell_class isSubclassOfClass:[TableLoadMoreCell class]])
    {
        return [cell_class height];
    }
    return 42.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (didSelectedRow)
    {
        id data = [_datas objectAtIndex:indexPath.row];
        didSelectedRow(data);
    }
}

#pragma mark - SETTER
-(void)setDatas:(NSMutableArray *)datas
{
    if (_datas)
    {
        [_datas release];
    }
    _datas = [datas retain];
    [self reloadData];
    
}

#pragma mark - Init
-(void)_init
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
-(id)init
{
    if (self = [super init])
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

@end
