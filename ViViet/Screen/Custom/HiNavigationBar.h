//
//  HiNavigationBar.h
//  ViMASS
//
//  Created by QUANGHIEP on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationViewControllerEx : UINavigationController

@end

@interface HiNavigationBar : UINavigationBar
+ (UINavigationController*)navigationControllerWithRootViewController:(UIViewController*)aRootViewController;
@end
