//
//  VSelectItemView.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 11/23/13.
//
//

#import "VSelectItemView.h"
#import "VSelectItemViewCell.h"

@implementation VSelectItemView
{
    IBOutlet UITableView *v_tb;
    NSMutableArray *data;
}

+ (VSelectItemView *)create;
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VSelectItemView" owner:nil options:nil];
    return (VSelectItemView *)[nib objectAtIndex:0];
}

- (void)setData:(NSArray *)data1
{
    if (data != data1)
    {
        [data release];
        data = [data1 copy];
    }
    
    [v_tb reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    VSelectItemViewCell *ce = [tableView dequeueReusableCellWithIdentifier:@"x"];
    if (ce == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VSelectItemViewCell" owner:nil options:nil];
        ce = (VSelectItemViewCell *)[nib objectAtIndex:0];
    }
    NSObject *item = [data objectAtIndex:indexPath.row];
    NSString *tit = [item isKindOfClass:[NSString class]] ? (NSString *)item : @"WTF";
    ce.lblText.text = tit;
    
    return ce;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


- (void)dealloc
{
    self.data = nil;
    [v_tb release];
    [super dealloc];
}

@synthesize data = data;
@synthesize table = v_tb;

@end
