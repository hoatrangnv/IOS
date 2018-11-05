    //
    //  VVGridView.m
    //  VVGridView
    //
    //  Created by Chung NV on 2/28/13.
    //  Copyright (c) 2013 ViViet. All rights reserved.
    //

#import "VVGridView.h"

#define kPADDING_LEFT      10
#define kPADDING_BOTTOM    10
#define kWRAPPER_VIEW_TAG  87

@implementation VVGridView
{
    UIScrollView         * wrapper;
    NSMutableArray       * dataViews;
    NSUInteger             numCellsInRow;
}
@synthesize delegate        = _delegate;
@synthesize datasource      = _datasource;
@synthesize selectedIndex   = _selectedIndex;
@synthesize selectedView    = _selectedView;

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        [self _init];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]){
        [self _init];        
    }
    return self;
}
-(id)init
{
    if (self = [super init]){
        [self _init];        
    }
    return self;
}
-(void) _init
{
    numCellsInRow    = kNUMBER_CELL_IN_ROW_DEFAULT;
}


#pragma mark - Override Method
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (wrapper) {
        wrapper.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self _addSubviews];
}

#pragma mark - Public Method
-(void)reloadGridView
{
    [self resetGridView];
    [self _addSubviews];
}


#pragma mark - Private Method
-(void) resetGridView
{
    if (!dataViews) {
        return;
    }
    for (UIView *v in [wrapper subviews]) {
        [v removeFromSuperview];
    }
}

-(void) _addSubviews
{
    CGRect rect = self.frame;
    if (!wrapper) {
        wrapper = [[UIScrollView alloc] init];
        wrapper.tag = kWRAPPER_VIEW_TAG;
        [self addSubview:wrapper];
    }
    wrapper.frame = CGRectMake(0, 0, rect.size.width,rect.size.height);
    
    if (!dataViews) {
        dataViews = [[NSMutableArray alloc] init];
    }else {
        [dataViews removeAllObjects];
    }
    
    if (!_datasource) {
        return;
    }
    
        // get Datasource
    int numberCells;
    if ([_datasource respondsToSelector:@selector(gridViewNumberCells:)]) {
        numberCells = (int)[_datasource gridViewNumberCells:self];
    }else {
        return;
    }
    
    if (![_datasource respondsToSelector:@selector(gridView:viewForCellAtIndex:)]) {
        return;
    }
    
    for (int i=0; i< numberCells; i++) {
        UIView *view = [_datasource gridView:self viewForCellAtIndex:i];
        if (![view isKindOfClass:[UIButton class]])
            continue;
        [((UIButton*)view) addTarget:self 
                              action:@selector(itemTouchUpInside:) 
                    forControlEvents:UIControlEventTouchUpInside];
        view.userInteractionEnabled = YES;
        
        [dataViews addObject:view];
    }
    
    numCellsInRow = kNUMBER_CELL_IN_ROW_DEFAULT;
    if ([_datasource respondsToSelector:@selector(gridViewNumberCellsInRow:)]) {
        numCellsInRow = [_datasource gridViewNumberCellsInRow:self];
    }
    
    CGFloat heightOfCell = kHEIGHT_OF_CELL_DEFAULT;
    if ([_datasource respondsToSelector:@selector(gridViewHeightOfCell:)]) {
        heightOfCell = [_datasource gridViewHeightOfCell:self];
    }
        // Draw views into Wrapper(UIScrollView) view
    CGFloat widthOfCell = rect.size.width - (numCellsInRow+1) * kPADDING_LEFT;
    widthOfCell = widthOfCell / numCellsInRow;
    
    CGSize contentSize = wrapper.frame.size;
    contentSize.height = 0.0f;
    
    
    CGRect rect_ = CGRectMake(0, 0, widthOfCell, heightOfCell);
    CGPoint  origin = CGPointZero;
    for (int i = 0; i<numberCells; i++) {
        UIView *view = [dataViews objectAtIndex:i];
        
        int column   = i % numCellsInRow;
        int row      = (int) i / numCellsInRow;
        
        if (column == 0) {
            origin.y  = (row + 1) * kPADDING_BOTTOM + row * heightOfCell;
            origin.x  = kPADDING_LEFT;
            contentSize.height = origin.y + heightOfCell;
        }else {
            origin.x = (column + 1) * kPADDING_LEFT + column * widthOfCell; 
        }
        rect_.origin = origin;
        view.frame = rect_;
        [wrapper addSubview:view];
        [wrapper bringSubviewToFront:view];
    }
    contentSize.height += 15;
    wrapper.contentSize = contentSize;
}
-(void)itemTouchUpInside:(UIButton*) button
{
    if (!button) {
        return;
    }
    if (!_delegate || ![_delegate respondsToSelector:@selector(gridView:didSelectCellAtIndex:)]) {
        return;
    }
    if (![dataViews containsObject:button]) {
        return;
    }
    
    _selectedIndex = [dataViews indexOfObject:button];
    _selectedView  = button;
    [_delegate gridView:self didSelectCellAtIndex:_selectedIndex];
}


-(void)dealloc
{
    if (wrapper) {
        [wrapper release];
    }
    if (dataViews) {
        [dataViews release];
    }
    [super dealloc];
}
@end