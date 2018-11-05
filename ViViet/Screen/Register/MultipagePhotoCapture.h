//
//  MultipagePhotoCapture.h
//  ViMASS
//
//  Created by Ngo Ba Thuong on 9/5/13.
//
//

#import <UIKit/UIKit.h>

@interface MultipagePhotoCapture : UIView
{
    IBOutlet UIScrollView *v_scroll;
}

@property (nonatomic, readonly) NSArray *images;

- (IBAction)add;
- (IBAction)del;

@end
