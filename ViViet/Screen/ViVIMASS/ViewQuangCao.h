//
//  ViewQuangCao.h
//  ViViMASS
//
//  Created by Tâm Nguyễn on 7/21/16.
//
//

#import <UIKit/UIKit.h>
#import "KASlideShow.h"
@protocol ViewQuangCaoDelegate <NSObject>
@optional
- (void)suKienChonQuangCao:(NSString *)sNameImage;
@end

@interface ViewQuangCao : UIView <KASlideShowDelegate>
@property (assign, nonatomic) id<ViewQuangCaoDelegate> mDelegate;
- (void)updateSizeQuangCao;
- (void)dungChayQuangCao;
@end
