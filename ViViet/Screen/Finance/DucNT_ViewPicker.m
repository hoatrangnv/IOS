//
//  DucNT_ViewPicker.m
//  ViMASS
//
//  Created by MacBookPro on 7/29/14.
//
//

#import "DucNT_ViewPicker.h"

@implementation DucNT_ViewPicker
{
    CapNhatGiaTriPicker blockCapNhat;
}

@synthesize btnDone;
@synthesize btnCancel;
@synthesize viewPicker;
@synthesize dsDuLieu;
@synthesize nViTriDuocChon;

-(id)initWithNib
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"DucNT_ViewPicker" owner:self options:nil] objectAtIndex:0] retain];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self khoiTao];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self khoiTao];
}

- (void)dealloc {
    if(btnDone)
        [btnDone release];
    if(btnCancel)
        [btnCancel release];
    if(viewPicker)
        [viewPicker release];
    if(dsDuLieu)
        [dsDuLieu release];
    if(blockCapNhat)
        [blockCapNhat release];
    NSLog(@"%s >> %s line: %d >> DEALLOC VIEW PICKER ",__FILE__,__FUNCTION__ ,__LINE__);
    [super dealloc];
}

#pragma mark - khoi tao du lieu
-(void)khoiTaoDuLieu:(NSArray *)dicDuLieu
{
    if(dsDuLieu != nil)
        [dsDuLieu release];
    dsDuLieu = [dicDuLieu retain];
    nViTriDuocChon = -1;
    [viewPicker reloadAllComponents];
    [viewPicker selectRow:0 inComponent:0 animated:YES];
}

-(void)khoiTao
{
    viewPicker.delegate = self;
    viewPicker.dataSource = self;
    viewPicker.showsSelectionIndicator = YES;
    [btnDone setTitle:[@"Done" localizableString] forState:UIControlStateNormal];
    [btnCancel setTitle:[@"Cancel" localizableString] forState:UIControlStateNormal];
}

#pragma mark - picker delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(dsDuLieu != nil)
        return dsDuLieu.count;
    return 0;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    nViTriDuocChon = (int)row;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return dsDuLieu[row];
}

/*Càn custom thì mở ra*/ 
//-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    return 0;
//}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if(view == nil)
    {
        int width = self.frame.size.width;
        view = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, width - 5 , 45)];
    }
    UILabel *lb = (UILabel *)view;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = [dsDuLieu objectAtIndex:row];
    lb.font = [UIFont systemFontOfSize:18.0f];
    NSString *sBank = @"AGR,BID,CTG,VCB,ABB,ACB,BAB,BVB,EAB,EIB,HDB,KLB,LPB,MB,MSB,NAB,NCB,OCB,PVB,SCB,SEAB,SGB,SHB,STB,TCB,TPB,VAB,VCCB,VIB,VPB";
    NSArray *arrTemp = [sBank componentsSeparatedByString:@","];
    for (NSString *sTemp in arrTemp) {
        if ([lb.text hasPrefix:sTemp]) {
            lb.font = [UIFont boldSystemFontOfSize:18.0f];
            break;
        }
    }
    return view;
}

#pragma mark -click
- (IBAction)suKienDone:(id)sender {
    if(blockCapNhat)
    {
        if(dsDuLieu.count > 0)
        {
            if(nViTriDuocChon == -1)
                blockCapNhat(0);
            else
                blockCapNhat(nViTriDuocChon);
        }
    }
}

- (IBAction)suKienCancel:(id)sender {
    if(blockCapNhat)
        blockCapNhat(-1);
}

-(void)capNhatKetQuaLuaChon:(CapNhatGiaTriPicker) capNhatGiaTri
{
    if(blockCapNhat)
        [blockCapNhat release];
    blockCapNhat = [capNhatGiaTri copy];
}
@end
