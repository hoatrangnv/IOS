//
//  ViewQuangCao.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 7/21/16.
//
//

#import "ViewQuangCao.h"
#import "JSONKit.h"

@implementation ViewQuangCao {
    NSMutableArray *arrQC;
//    NSTimer *timeQC;
    KASlideShow *viewQuangCao;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"%s - ===================> START : %f - %f", __FUNCTION__, self.frame.size.width, self.frame.size.height);

    viewQuangCao = [[KASlideShow alloc] initWithFrame:self.frame];
    [viewQuangCao setImageMode:UIViewContentModeScaleToFill];
    viewQuangCao.delegate = self;
    viewQuangCao.delay = 10.0f;
    viewQuangCao.transitionDuration = 1.0f;
    [viewQuangCao setTransitionType:KASlideShowTransitionSlide];
//    [viewQuangCao setImagesContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:viewQuangCao];
    [viewQuangCao addGestureOnline:KASlideShowGestureAll];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *sQC = [user stringForKey:@"QUANG_CAO_VI_VIMASS"];
//    NSLog(@"%s - sQC : %@", __FUNCTION__, sQC);
    NSArray *dict = [sQC objectFromJSONString];
//    arrQC = [[NSMutableArray alloc] init];
//    BOOL isWifi = [user boolForKey:@"QUANG_CAO_WIFI"];
    NSString *keyQC = @"nameSave";
//    if (!isWifi) {
//        keyQC = @"nameSave3g";
//    }
//    NSLog(@"%s - keyQC : %@", __FUNCTION__, keyQC);

    for (NSDictionary *dicTemp in dict) {
        int nVMApp = [[dicTemp objectForKey:@"VMApp"] intValue];
        if (nVMApp == 1) {
            [arrQC addObject:dicTemp];
        }
    }

//    NSLog(@"%s - arrQC.count : %ld", __FUNCTION__, (long)arrQC.count);
    NSMutableArray *arrLinkAnh = [[NSMutableArray alloc] init];
    for (NSDictionary *dicTemp in arrQC) {
        NSString *sName = [dicTemp objectForKey:keyQC];
        if (sName.isEmpty) {
            keyQC = @"nameSave";
            sName = [dicTemp objectForKey:keyQC];
        }
        [arrLinkAnh addObject:sName];
    }
    viewQuangCao.currentIndex = 0;
    [viewQuangCao setImagesDataSourceOnline:arrLinkAnh];
//    if (arrLinkAnh.count > 0) {
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        NSInteger *nIndex = [user integerForKey:@"KEY_INDEX_CLICK_QC"];
//        NSLog(@"%s - nIndex : %d", __FUNCTION__, (int)nIndex);
//        viewQuangCao.currentIndex = nIndex;
//        [viewQuangCao setImagesDataSourceOnline:arrLinkAnh];
//        [self performSelector:@selector(chaySlideQuangCao1) withObject:nil afterDelay:10];
//    }
    
}

- (void)updateSizeQuangCao {
    CGRect rectQC = viewQuangCao.frame;
    rectQC.size.width = self.frame.size.width;
    rectQC.size.height = self.frame.size.height;
    NSLog(@"%s - rectQC : %f", __FUNCTION__, rectQC.size.width);
    viewQuangCao.frame = rectQC;
}
-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
}

- (void)chaySlideQuangCao1{
    NSLog(@"%s - START", __FUNCTION__);
    if (viewQuangCao) {
        [viewQuangCao startOnline];
    }
}

- (void)chaySlideQuangCao:(NSTimer *)timer{
    NSLog(@"%s - START", __FUNCTION__);
    if (viewQuangCao) {
        [viewQuangCao startOnline];
    }
}

- (void)kaSlideShowTapOnImage:(NSUInteger)nIndex nViTriChon:(int)nIndexChon{
    NSLog(@"%s - nIndex : %d -  nIndexChon : %d", __FUNCTION__, (int)nIndex, nIndexChon);
    if (arrQC && arrQC.count - 1 >= (int)nIndex) {
        NSLog(@"%s - vao day roi", __FUNCTION__);
        NSDictionary *dic = [arrQC objectAtIndex:(int)nIndex];
        if (_mDelegate) {
            NSString *sTenAnh = [dic objectForKey:@"nameImage"];
            NSLog(@"%s - sTenAnh : %@", __FUNCTION__, sTenAnh);
            if ([sTenAnh hasPrefix:@"5"]) {
                NSArray *arrTenAnh = [sTenAnh componentsSeparatedByString:@"#"];
                if (arrTenAnh.count > nIndexChon + 1) {
                    NSString *sTenViTri = arrTenAnh[nIndexChon + 1];
                    NSLog(@"%s - sTenViTri : %@", __FUNCTION__, sTenViTri);
                    [_mDelegate suKienChonQuangCao:sTenViTri];
                }
            }
            else if([sTenAnh hasPrefix:@"4"]) {

                NSArray *arrTenAnh = [sTenAnh componentsSeparatedByString:@"#"];
                if (nIndexChon == 4) {
                    nIndexChon = 0;
                }
                if (arrTenAnh.count > nIndexChon + 1) {
                    NSString *sTenViTri = arrTenAnh[nIndexChon + 1];
                    NSLog(@"%s - sTenViTri : %@", __FUNCTION__, sTenViTri);
                    [_mDelegate suKienChonQuangCao:sTenViTri];
                }
            }
            else
                [_mDelegate suKienChonQuangCao:sTenAnh];
        }
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setInteger:nIndex forKey:@"KEY_INDEX_CLICK_QC"];
        [user synchronize];
    }
}


- (void)dungChayQuangCao {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [viewQuangCao stopOnline];
    viewQuangCao.delegate = nil;
    [viewQuangCao release];
}

- (void)dealloc {
    [self dungChayQuangCao];
    if (arrQC) {
        [arrQC release];
    }
    [super dealloc];
}
@end
