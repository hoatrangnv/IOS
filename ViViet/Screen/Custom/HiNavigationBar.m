//
//  HiNavigationBar.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 7/25/12.
//  Copyright (c) 2012 CMC. All rights reserved.
//

#import "HiNavigationBar.h"
#import "Common.h"

@implementation NavigationViewControllerEx

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//}

//-(void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//}
@end


@implementation HiNavigationBar
{
//    UIImage *bgImage;
}

+ (UINavigationController*)navigationControllerWithRootViewController:(UIViewController*)aRootViewController
{
    //! load nib named the same as our custom class
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    
    //! get navigation controller from our xib and pass it the root view controller
    UINavigationController *navigationController = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    [navigationController setViewControllers:[NSArray arrayWithObject:aRootViewController] animated:NO];
//    navigationController.navigationItem.backBarButtonItem.tintColor = [UIColor brownColor];
//
//    [[navigationController navigationBar] setBarTintColor:[UIColor whiteColor]];

//    navigationController.navigationBar.clipsToBounds = NO;
//    navigationController.navigationBar.tintColor = [UIColor redColor];

    return navigationController;
}

//- (void)drawRect:(CGRect)rect
//{
//    if (bgImage == nil)
//    {
//        bgImage = [[UIImage imageNamed:@"bg_top"] retain];
//    }
//    [bgImage drawInRect:rect];
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

-(void) dealloc
{
//    [bgImage release];
    [super dealloc];
}
@end
