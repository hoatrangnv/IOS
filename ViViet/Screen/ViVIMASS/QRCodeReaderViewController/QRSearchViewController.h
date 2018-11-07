//
//  QRSearchViewController.h
//  ViViMASS
//
//  Created by Mac Mini on 9/20/18.
//

#import <UIKit/UIKit.h>
#import "QRCodeReader.h"
#import "QRCodeReaderView.h"
#import "QRCodeReaderDelegate.h"
#import "QRCameraSwitchButton.h"
#import "QRToggleTorchButton.h"

@interface QRSearchViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField * _Nullable txtSearch;
@property (strong, nonatomic) IBOutlet QRCodeReaderView     *cameraView;
@property (strong, nonatomic) UIButton             *cancelButton;
@property (retain, nonatomic) IBOutlet QRCameraSwitchButton *switchCameraButton;
@property (retain, nonatomic) IBOutlet QRToggleTorchButton *toggleTorchButton;

@property (nonatomic,assign) id<QRCodeReaderDelegate> __nullable delegate;
@property (copy, nonatomic) void (^ _Nullable completionBlock) (NSString * __nullable);
@property (strong, nonatomic) QRCodeReader * _Nullable codeReader;

- (void)startScanning;
- (void)stopScanning;
- (void)setCompletionWithBlock:(nullable void (^) (NSString * __nullable resultAsString))completionBlock;

- (IBAction)doClose:(id _Nullable )sender;
- (IBAction)doSearch:(id _Nullable )sender;
- (IBAction)doChooseLibrary:(id _Nullable )sender;


@end
