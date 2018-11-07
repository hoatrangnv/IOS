//
//  QRSearchViewController.m
//  ViViMASS
//
//  Created by Mac Mini on 9/20/18.
//

#import "QRSearchViewController.h"
#import "CommonUtils.h"
@interface QRSearchViewController ()<UITextFieldDelegate>

@end

@implementation QRSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _txtSearch.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtSearch.adjustsFontSizeToFitWidth = true;
    _txtSearch.layer.borderWidth=1.0;
    
    [_codeReader.previewLayer setFrame:CGRectMake(0, 0, _cameraView.frame.size.width, _cameraView.frame.size.height)];

    [_cameraView.layer insertSublayer:_codeReader.previewLayer atIndex:0];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_txtSearch release];
    [self stopScanning];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

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
- (IBAction)doClose:(id)sender {
    [_codeReader stopScanning];
    
    if (_completionBlock) {
        _completionBlock(nil);
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(readerDidCancel:)]) {
        [_delegate readerDidCancel:self];
    }
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
