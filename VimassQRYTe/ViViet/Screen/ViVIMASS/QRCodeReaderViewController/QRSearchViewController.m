//
//  QRSearchViewController.m
//  ViViMASS
//
//  Created by Mac Mini on 9/20/18.
//

#import "QRSearchViewController.h"
#import "CommonUtils.h"
#import "QRDonViViewController.h"
#import "HiNavigationBar.h"
#import <objc/runtime.h>
@interface QRSearchViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate>

@end

@implementation QRSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _txtSearch.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtSearch.adjustsFontSizeToFitWidth = true;
    _txtSearch.layer.borderWidth=1.0;
//    [_txtSearch setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    if (@available(iOS 13, *)) {
        Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(_txtSearch, ivar);

        placeholderLabel.textColor = [UIColor lightGrayColor];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_codeReader.previewLayer setFrame:CGRectMake(0, 0, _cameraView.frame.size.width, _cameraView.frame.size.height)];
        
        [_cameraView.layer insertSublayer:_codeReader.previewLayer atIndex:0];
    });
    
    [_codeReader setCompletionWithBlock:^(NSString *resultAsString) {
        if (self.completionBlock != nil) {
            self.completionBlock(resultAsString);
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(reader:didScanResult:)]) {
            [self.delegate reader:self didScanResult:resultAsString];
        }
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    if (_nType == 0) {
        [_txtSearch setHidden:YES];
        [_btnTraCuu setHidden:YES];
        [_lblTitle setHidden:NO];
        [_btnDangKyQR setHidden:YES];
    } else {
        [_btnDangKyQR setHidden:NO];
    }

}

- (void)switchDeviceInput
{
    [_codeReader switchDeviceInput];
}
- (IBAction)switchCameraAction:(UIButton *)button
{
    [self switchDeviceInput];
}

- (IBAction)toggleTorchAction:(UIButton *)button
{
    [_codeReader toggleTorch];
}
-(void)dismissKeyboard {
    [_txtSearch resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
        [self startScanning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopScanning];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    
    if (lowercaseCharRange.location != NSNotFound) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:[string uppercaseString]];
        return NO;
    }
    return true;
}

- (void)dealloc {
    [_txtSearch release];
    [self stopScanning];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_btnTraCuu release];
    [_lblTitle release];
    [_btnDangKyQR release];
    [super dealloc];
}
- (IBAction)doSearch:(id)sender {
    if([CommonUtils isEmptyOrNull:self.txtSearch.text]){
        return;
    }

    [self.delegate reader:self didScanResultSearch:self.txtSearch.text];
}

- (IBAction)doChooseLibrary:(id)sender {
}

- (IBAction)suKienChonLayAnh:(id)sender {
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)suKienChonDangKyQR:(id)sender {
    QRDonViViewController *vc = [[QRDonViViewController alloc] initWithNibName:@"QRDonViViewController" bundle:nil];
    vc.nType = 1;
    UINavigationController *navHome = [HiNavigationBar navigationControllerWithRootViewController: vc];
    [self presentViewController:navHome animated:YES completion:nil];
    [vc release];
}

- (IBAction)doClose:(id)sender {
    [_codeReader stopScanning];
    
    if (_completionBlock) {
        _completionBlock(nil);
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(readerDidCancel:)]) {
        [_delegate readerDidCancel:self];
    }
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
//    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    NSLog(@"%s - lay anh qr thanh cong", __FUNCTION__);
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSArray *features = [self detectQRCode:image];
    if (features != nil && features.count > 0) {
        for (CIQRCodeFeature* qrFeature in features) {
            NSLog(@"QRFeature.messageString : %@ ", qrFeature.messageString);
            if (self.delegate != nil) {
                [self.delegate reader:self didScanResultSearch:qrFeature.messageString];
            }
            break;
        }
    }
}

-(NSArray *)detectQRCode:(UIImage *) image
{
    CIImage* ciImage = [[CIImage alloc] initWithImage:image]; // assuming underlying data is a CIImage
    //CIImage* ciImage = [CIImage initWithCGImage: UIImage.CGImage]; // to use if the underlying data is a CGImage
    
    NSDictionary* options;
    CIContext* context = [CIContext context];
    options = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh }; // Slow but thorough
    //options = @{ CIDetectorAccuracy : CIDetectorAccuracyLow}; // Fast but superficial
    
    CIDetector* qrDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                                context:context
                                                options:options];
    if ([[ciImage properties] valueForKey:(NSString*) kCGImagePropertyOrientation] == nil) {
        options = @{ CIDetectorImageOrientation : @1};
    } else {
        options = @{ CIDetectorImageOrientation : [[ciImage properties] valueForKey:(NSString*) kCGImagePropertyOrientation]};
    }
    
    NSArray * features = [qrDetector featuresInImage:ciImage
                                             options:options];
    
    return features;
}

#pragma mark - Controlling the Reader

- (void)startScanning {
    [_codeReader startScanning];
}

- (void)stopScanning {
    [_codeReader stopScanning];
}
#pragma mark - Managing the Block

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock
{
    self.completionBlock = completionBlock;
}


@end
@implementation UITextField (custom)
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 1,
                      bounds.size.width - 20, bounds.size.height - 2);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
