

#import "ChonAnSauDtTableViewCell.h"

@implementation ChonAnSauDtTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnSelect setBackgroundImage:[UIImage imageNamed:@"radio-unselected"] forState:UIControlStateNormal];
    [self.btnSelect setBackgroundImage:[UIImage imageNamed:@"radio-selected"] forState:UIControlStateSelected];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataForCell:(NSDictionary*)dic {
    _dicData = dic;
    _lblTitle.text = [self getMappingName:[dic[@"loaiMapping"]intValue] andManganhang:dic[@"maNganHang"]];
    int loaimaping = [[dic objectForKey:@"loaiMapping"]intValue];
    NSString *manganhang = [[dic objectForKey:@"maNganHang"] stringValue];
    _lblLogo.image = [self getImageFromVi:loaimaping andManganhang:manganhang];

}
- (void)dataSelected:(BOOL)selected {
    [_btnSelect setSelected:selected];
    self.backgroundColor = selected ? [UIColor colorWithRed:168.0/255.0 green:200.0/255.0 blue:193.0/255.0 alpha:1.0] : [UIColor whiteColor];
}
- (IBAction)doSelect:(id)sender {
    if (_delegate) {
        [_delegate actionSelect:_dicData];
    }
}
#pragma mark - Others
-(UIImage*)getImageFromVi:(int)loaiMaping andManganhang:(NSString*)manganhang{
    switch (loaiMaping) {
        case 0:
            return [UIImage imageNamed:@"vimass"];
            break;
        case 1:
            return [UIImage imageNamed:@"air"];
            break;
        case 2:
            return [UIImage imageNamed:@"momo"];
            break;
        case 3:
            return [UIImage imageNamed:@"nganluong"];
            break;
        case 4:
            return [UIImage imageNamed:@"payoo"];
            break;
        case 5:
            return [UIImage imageNamed:@"viettel"];
            break;
        case 6:
            return [UIImage imageNamed:@"vimo"];
            break;
        case 7:
            return [UIImage imageNamed:@"viviet"];
            break;
        case 8:
            return [UIImage imageNamed:@"vnpt"];
            break;
        case 9:
            return [UIImage imageNamed:@"vtc"];
            break;
        case 10:
            return [UIImage imageNamed:@"zalo"];
            break;
        case 11:{
            NSString *imgName = [NSString stringWithFormat:@"%@-nh",manganhang];
            UIImage *img = [UIImage imageNamed:[imgName lowercaseString]];
            if(img == nil){
                img =[UIImage imageNamed:[imgName uppercaseString]];
            }
            return img;
        }
            break;
        case 12:{
            NSString *imgName = [NSString stringWithFormat:@"%@-the",manganhang];
            UIImage *img = [UIImage imageNamed:[imgName lowercaseString]];
            if(img == nil){
                img =[UIImage imageNamed:[imgName uppercaseString]];
            }
            return img;

        }
            break;
        case 13:
            return [UIImage imageNamed:[manganhang lowercaseString]];
            break;
        default:
            return nil;
            break;
    }
}
- (NSString*)getMappingName:(int)loaiMaping andManganhang:(NSString*)manganhang {
    switch (loaiMaping) {
        case 0:
            return @"Ví Vimass";
        case 1:
            return @"Ví Airpay";
        case 2:
            return @"Ví Momo";
        case 3:
            return @"Ví Ngân lượng";
            break;
        case 4:
            return @"Ví Payoo";
        case 5:
            return @"Ví Vietel Pay";
        case 6:
            return @"Ví Vimo";
        case 7:
            return @"Ví Việt";
        case 8:
            return @"Ví VNPT Pay";
        case 9:
            return @"Ví VTC Pay";
        case 10:
            return @"Ví Zalo Pay";
        case 11:
            return [NSString stringWithFormat:@"Tài khoản %@",manganhang];
        case 12:
            return [NSString stringWithFormat:@"Thẻ %@",manganhang];;
        case 13:
            return [NSString stringWithFormat:@"%@Card",[[manganhang lowercaseString]upperCaseFirstChar]];
        default:
            return nil;
    }
    
}

- (void)dealloc {
    [_lblTitle release];
    [_lblLogo release];
    [_btnSelect release];
    [super dealloc];
}
@end
