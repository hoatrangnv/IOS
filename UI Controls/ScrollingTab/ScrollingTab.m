    //
    //  ScrollPaginate.m
    //  Test
    //
    //  Created by Chung NV on 2/7/13.
    //  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
    //

#import "ScrollingTab.h"


#define kNUMBER_PAGE_FIRST_LOADED  2
#define kHEADER_HEIGHT             45

@implementation ScrollingTab
{
    CGFloat     headerHeight;
    bool abc;
    
    id<ScrollingTabDatasource> _datasource;
    id<ScrollingTabDelegate>   _delegate;
}

@synthesize delegate    = _delegate;
@synthesize datasource  = _datasource;
@synthesize currentPage = _currentPage;
@synthesize numberPages = _numberPages;

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
    }

    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        
    }
    return self;
}
-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}


#pragma mark - PUBLIC Method
-(void)goToTap:(NSUInteger)_pageNumber animated:(BOOL)animated
{
    if (_pageNumber >= _numberPages)
        _pageNumber = _numberPages - 1;
    
    CGPoint point = CGPointMake(_pageNumber * self.frame.size.width,
                                0);
    _currentPage = _pageNumber;
    [self loadNextPage];
    
    [scrollView setContentOffset:point 
                        animated:animated];
    
    [titleScroll setSelectedIndex:(int)_pageNumber
                         animated:animated];
}
-(void)goToTapView:(UIView *)_tapView 
          animated:(BOOL)_animated
{
    if (!pageViews || pageViews.count == 0)
        return;

    if (![pageViews containsObject:_tapView])
        return;
    int idxTap = (int)[pageViews indexOfObject:_tapView];
    [self goToTap:idxTap animated:_animated];
}


-(void)setFrame:(CGRect)frame
{
    if (CGRectEqualToRect(self.frame, frame))
        return;

    [super setFrame:frame];
}

-(UIView *)tapViewAtIndex:(NSUInteger)_indexPage
{
    if (_indexPage >= _numberPages)
        return nil;
    UIView *view = nil;    
    
        // if View is Loaded
    if (_indexPage <= pageViews.count)
        view = [pageViews objectAtIndex:_indexPage];
    
    else // else VIEW is NOT Loaded
        if (_datasource && [_datasource respondsToSelector:@selector(scrollPaginate:viewAtPage:)])
            view = [_datasource scrollingTab:self tapViewAtIndex:_indexPage];
    
    return view;
}

-(int) indexOfTap:(UIView*) pageView;
{
    if ([pageViews containsObject:pageView]) {
        return (int)[pageViews indexOfObject:pageView];
    }
    return -1;
}

-(void)insertTapView:(UIView *)_tapView
           tapHeader:(id)_tapHeader
             atIndex:(NSUInteger)_atIndex 
{
    /*   First : 0 1 2 3
     *  _atIndex = 0 ==> 0' 1  1 2  3  (add to first point)
     *  _atIndex = 1 ==> 0  1' 1 2  3
     *  _atIndex = 3 ==> 0  1  2 3' 3 
     *  _atIndex = 4 ==> 0  1  2 3  4 (add to last point)
     *  _atIndex > 4 ==> 0  1  2 3  4 (add to last point)
     *  1. Copy frame and origin
     *  2. Add view at Frame and origin
     */
    if (_atIndex > pageViews.count)
        _atIndex = pageViews.count;
    
    CGSize contentSize = scrollView.contentSize;
        // rect of View Insert when insert in LAST POINT
    CGRect rectInsert = CGRectMake(contentSize.width, 
                                   0, 
                                   scrollView.frame.size.width, 
                                   scrollView.frame.size.height
                                   );
    
    UIView *viewAtIndex = [self tapViewAtIndex:_atIndex];
    if (viewAtIndex)
        rectInsert.origin = viewAtIndex.frame.origin;
    
    for (int i = (int)_atIndex; i< pageViews.count; i++) {
        UIView *vi = [self tapViewAtIndex:i];
        if (vi == nil)
            continue;
        
        CGRect rectVI = vi.frame;
        
            // translate view at "i" a distance = with
        rectVI.origin.x += self.frame.size.width; 
        vi.frame = rectVI;
    }
    
    _tapView.frame = rectInsert;
    [scrollView addSubview:_tapView];
    [pageViews insertObject:_tapView atIndex:_atIndex];
        //increase _numberPages
    _numberPages +=1;
    
        // add ContentSize of scroll
    contentSize.width += self.frame.size.width;
    scrollView.contentSize = contentSize;
    
        //insert title
    [titleScroll insertItem:_tapHeader atIndex:(int)_atIndex];
}

-(void)insertTapView:(UIView *)_tapView 
           tapHeader:(id)_tapHeader 
            afterTap:(UIView *)afterTap
{
        // afterTap NOT in Scrolling
    if (![pageViews containsObject:afterTap])
        return;
    
        //if _tapView in Scrolling => added=> do NOT anything 
    if ([pageViews containsObject:_tapView]) {
        return;
    }
    
    int pageIdx = (int)[pageViews indexOfObject:afterTap] + 1;
    [self insertTapView:_tapView tapHeader:_tapHeader atIndex:pageIdx];
}

-(void)insertTapView:(UIView *)_tapView 
           tapHeader:(id)_tapHeader 
           beforeTap:(UIView *)beforeTap
{
    if (![pageViews containsObject:beforeTap])
        return;
        //if _tapView in Scrolling => added=> do NOT anything 
    if ([pageViews containsObject:_tapView]) {
        return;
    }

    int pageIdx = (int)[pageViews indexOfObject:beforeTap];
    [self insertTapView:_tapView tapHeader:_tapHeader atIndex:pageIdx];
}



-(BOOL) removePageAtIndex:(NSUInteger)_atIndex
{
    int numberPageLoaded = (int)[pageViews count];
    if (_atIndex > numberPageLoaded) // if VIEW is NOT Loaded ==> NOT REMOVE
        return FALSE;
    
    UIView *viewAtIndex = [self tapViewAtIndex:_atIndex];
    CGRect vRomoveFrame = viewAtIndex.frame;
    [viewAtIndex removeFromSuperview];
    for (int i=(int)_atIndex+1; i<numberPageLoaded; i++) {
        UIView *vi = [self tapViewAtIndex:i];
        if (!vi) {
            continue;
        }
        CGRect frameVI = vi.frame;
        frameVI.origin.x -= vRomoveFrame.size.width;
        vi.frame = frameVI;
    }
    
    [pageViews removeObjectAtIndex:_atIndex];
    _numberPages -=1;
    [titleScroll removeItemAtIndex:_atIndex];
    
    CGSize ctSize = scrollView.contentSize;
    ctSize.width -= vRomoveFrame.size.width;
    scrollView.contentSize = ctSize;
    return TRUE;
}

-(void)removeTapView:(UIView *)_tapView
{
    if (!pageViews || pageViews.count == 0)
        return;
    
    if (![pageViews containsObject:_tapView])
        return;
    int idxTap = (int)[pageViews indexOfObject:_tapView];
    [self removePageAtIndex:idxTap];
}

-(void)removeTapViews:(NSArray *)_tapViews
{
    if (!_tapViews || _tapViews.count == 0)
        return;
    
    for (id tapView in _tapViews) {
        if ([tapView isKindOfClass:[UIView class]])
            [self removeTapView:tapView];
    }
}

-(BOOL) removePageFromIndex:(NSUInteger)_fromIndex 
                    toIndex:(NSUInteger)_toIndex
{
    if (_toIndex >= pageViews.count)
        _toIndex = pageViews.count-1;
    
    if (_fromIndex > _toIndex)
        return FALSE;
    
    for (int i =(int)_toIndex; i >=(int)_fromIndex; i--) {
        [self removePageAtIndex:i];
    }
    
    return TRUE;
}
-(BOOL) removePageFromIndex:(NSUInteger)_fromIndex
{
    [self removePageFromIndex:_fromIndex toIndex:_numberPages];
    return TRUE;
}
-(BOOL) removePageToIndex:(NSUInteger)_toIndex
{
    [self removePageFromIndex:0 toIndex:_toIndex];
    return FALSE;
}


#pragma mark - Override Method
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (!abc)
    {
        [self _addViews];
        abc = true;
    }
}

#pragma mak - SEL(s)


#pragma mark - Private Method

-(void) _addViews
{
    
    if (!_datasource) 
        return;
    
    if ([_datasource respondsToSelector:@selector(heightForHeaderOfScrollingTab:)])
        headerHeight = [_datasource heightForHeaderOfScrollingTab:self];
    else
        headerHeight = kHEADER_HEIGHT;
    

    
    if (![_datasource respondsToSelector:@selector(numberTabOfScrollingTab:)])
        return;
    
    if (![_datasource respondsToSelector:@selector(scrollingTab:tapViewAtIndex:)])
        return;
    
    if (!pageViews)
        self->pageViews = [[NSMutableArray alloc] init];
    
    
    if (!scrollView)
    {
        scrollView = [[UIScrollView alloc] init];
        [self addSubview:scrollView];
        scrollView.delegate = self;
    }
    
    CGRect rectScroll =CGRectMake(0,
                                  headerHeight, 
                                  self.frame.size.width,
                                  self.frame.size.height - headerHeight);
    scrollView.frame = rectScroll;
//    scrollView.backgroundColor = [UIColor redColor];
    scrollView.clipsToBounds = YES;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleBottomMargin;
    scrollView.showsVerticalScrollIndicator     = NO;
    scrollView.showsHorizontalScrollIndicator   = NO;
    scrollView.bounces = NO;
    
    
    _numberPages = [_datasource numberTabOfScrollingTab:self];
    
    NSUInteger numPagesFirstLoaded = _numberPages > kNUMBER_PAGE_FIRST_LOADED ? kNUMBER_PAGE_FIRST_LOADED : _numberPages;
    
    CGRect titleScrollFrame = CGRectMake(0, 
                                         0, 
                                         self.frame.size.width,
                                         headerHeight);
    if (!titleScroll) 
    {
        titleScroll = [[ScrollingMenu alloc] initWithFrame:titleScrollFrame];
        titleScroll.scrollEnabled = YES;
        titleScroll.delegate = self;
    }
    titleScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    
    for (int i=0; i<numPagesFirstLoaded; i++) 
    {
        UIView *view = [_datasource scrollingTab:self tapViewAtIndex:i];
        [self addView:view AtPageIndex:i];
        [pageViews addObject:view];
    }
    
        // insert all title header view
    for (int i=0; i<_numberPages; i++) 
    {
        id title = [_datasource scrollingTab:self tapHeaderAtIndex:i];
        [titleScroll insertItem:title atIndex:10000];
    }
    
    
    [titleScroll setBackgroundColor:[UIColor clearColor]];
    [self addSubview:titleScroll];
    [titleScroll setSelectedIndex:0 animated:NO];
//    [self loadNextPage];
    [self goToTap:_currentPage animated:NO];
}

-(void) addView:(UIView*) _view AtPageIndex:(NSUInteger) _index
{
    CGSize contentSize  = scrollView.contentSize;
    contentSize.height  = self.frame.size.height - headerHeight;
    
    CGRect vRect        = CGRectZero;
    vRect.size          = scrollView.frame.size;
    vRect.origin.x      = contentSize.width;
    
    _view.frame = vRect;
    _view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [scrollView addSubview:_view];
    
    contentSize.width += self.frame.size.width;
    scrollView.contentSize = contentSize;
    scrollView.bounces = FALSE;
}

/*
 *  load more when you scroll to nextPage
 */
-(void) loadNextPage
{
    int nextViewIndex = (int)_currentPage + 1;
    if (nextViewIndex == pageViews.count && pageViews.count < _numberPages) 
    {
            // loading next View
        if (nextViewIndex < _numberPages) 
        {
            UIView *view = [_datasource scrollingTab:self tapViewAtIndex:nextViewIndex];
            [self addView:view AtPageIndex:nextViewIndex];
            [pageViews addObject:view];
        }
    }
}

    

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize sz = scrollView.contentSize;
    sz.width = self.bounds.size.width * pageViews.count;
    scrollView.contentSize = sz;
    
    CGRect r = self.bounds;
    UIView * v = [pageViews objectAtIndex:0];
    r = v.frame;
    r.origin.x = 0;
    
    for (UIView *v in pageViews) {
        v.frame = r;
        r.origin.x += r.size.width;
    }
}

#pragma mark - Scrollview delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_
{
    float page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (![_datasource respondsToSelector:@selector(scrollingTab:tapViewAtIndex:)])
        return;
    if (![_datasource respondsToSelector:@selector(scrollingTab:tapHeaderAtIndex:)])
        return;
    
    _currentPage = page;
    [self loadNextPage];
    [titleScroll setSelectedIndex:page animated:TRUE];
    
}
-(void)exScrollViewSelectedChanged:(ScrollingMenu *)exScrollView_
{
    NSInteger page = exScrollView_.currentIndex;
    page = page >= _numberPages ? _numberPages - 1 : page;
    
    if (pageViews.count <= page) {
        for (NSInteger i=pageViews.count; i<=page; i++) {
            UIView *view = [_datasource scrollingTab:self 
                                      tapViewAtIndex:i];
            [self addView:view AtPageIndex:i];
            [pageViews addObject:view];
        }
    }
    
    [self goToTap:page animated:TRUE];
}
-(NSMutableArray *)pageViews
{
    return pageViews;
}

-(void)dealloc
{
    if (pageViews)
        [pageViews release];
    
    if (scrollView)
        [scrollView release];

    if (titleScroll)
        [titleScroll release];

    [super dealloc];
}
@end
