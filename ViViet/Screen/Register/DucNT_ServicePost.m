//
//  DucNT_ServicePost.m
//  ViMASS
//
//  Created by MacBookPro on 7/3/14.
//
//

#import "DucNT_ServicePost.h"
#import "RoundAlert.h"
#import "Common.h"
#import "JSONKit.h"



@implementation DucNT_ServicePost
//@synthesize urlConnect;
//@synthesize receiveData;
@synthesize ducnt_connectDelegate;

NSString *const LINK_BASE = @"https://vimass.vn/vmbank/services";
NSString *const LINK_DANG_NHAP = @"https://vimass.vn/vmbank/services/account/login1";
NSString *const LINK_DANG_NHAP_TAI_KHOAN_KHAC = @"https://vimass.vn/vmbank/services/account/loginWithOtherApp";
NSString *const LINK_DANG_KY_TAI_KHOAN;
NSString *const LINK_DANG_KY_TOKEN = @"https://vimass.vn/vmbank/services/auth/createUser?";
NSString *const LINK_DANG_KY_TOKEN_TAI_KHOAN_KHAC = @"https://vimass.vn/vmbank/services/auth/createTokenWithOtherApp?";
NSString *const LINK_XAC_THUC_DANG_KY_TAI_KHOAN;
NSString *const LINK_XAC_THUC_DANG_KY_TOKEN;
NSString *const LINK_QUEN_MAT_KHAU_TOKEN = @"https://vimass.vn/vmbank/services/auth/forgetPassSoftToken?";
NSString *const LINK_DOI_MAT_KHAU_TOKEN;
NSString *const LINK_LAY_THONG_TIN_SAO_KE;
NSString *const LINK_XAC_THUC_QUEN_MAT_KHAU_TOKEN;

-(id)init
{
    if(self = [super init])
    {
        _bEncryptData = FALSE;
        receiveData = [[NSMutableData alloc] init];
       
    }
    return self;
}

- (id)initWithDinhDanh:(NSString*)sDinhDanh
{
    self = [super init];
    if(self)
    {
        mDinhDanh = [sDinhDanh copy];
        receiveData = [[NSMutableData alloc] init];
    }
    return self;
}



-(void)connect:(NSString *)sUrl withContent:(NSString *)sContent
{
    mShowAlert = YES;
    NSURL * url = [NSURL URLWithString:sUrl];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[sContent length]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    request.timeoutInterval = 120;
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[sContent dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    NSLog(@"%s - sURL : %@", __FUNCTION__, sUrl);
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)connectDiaDiem:(NSString *)sUrl withContent:(NSString *)sContent{
    mShowAlert = YES;
    [RoundAlert show];
    NSURL * url = [NSURL URLWithString:sUrl];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[sContent length]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[sContent dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    NSLog(@"%s >> %s line: %d >> sURL: %@ -- %@",__FILE__,__FUNCTION__ ,__LINE__, [[request URL] absoluteString], sContent);
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void)connectPost:(NSString *)sUrl withContent:(NSString *)sContent timeOut:(double)fTimeOut
{
    mShowAlert = YES;
    [RoundAlert show];
    NSURL * url = [NSURL URLWithString:sUrl];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[sContent length]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    request.timeoutInterval = fTimeOut;
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[sContent dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    NSLog(@"%s >> %s line: %d >> sURL: %@ -- %@",__FILE__,__FUNCTION__ ,__LINE__, [[request URL] absoluteString], sContent);
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)connectGetWithTimeout:(int)timeOut sUrl:(NSString *)sUrl withContent:(NSString *)sContent {
    mShowAlert = YES;
    [RoundAlert show];
    NSString *sNewURL = [sUrl stringByAppendingString:sContent];
    NSLog(@"%s >> %s line: %d >> sNewUrl: %@",__FILE__,__FUNCTION__ ,__LINE__, sNewURL);
    NSURL *url = [NSURL URLWithString:sNewURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOut];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void)connectGet:(NSString *)sUrl withContent:(NSString *)sContent
{
    mShowAlert = YES;
    [RoundAlert show];
    NSString *sNewURL = [sUrl stringByAppendingString:sContent];
    NSLog(@"%s >> %s line: %d >> sNewUrl: %@",__FILE__,__FUNCTION__ ,__LINE__, sNewURL);
    NSURL *url = [NSURL URLWithString:sNewURL];
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 120;
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //start the connection
    [connection start];
}

-(void)connectGet:(int)timeOut sUrl:(NSString *)sUrl withContent:(NSString *)sContent
{
    mShowAlert = YES;
    [RoundAlert show];
    NSString *sNewURL = [sUrl stringByAppendingString:sContent];
    NSLog(@"%s >> %s line: %d >> sNewUrl: %@ ",__FILE__,__FUNCTION__ ,__LINE__, sNewURL);
    NSURL *url = [NSURL URLWithString:sNewURL];
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval=timeOut;
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    //start the connection
    [connection start];
}

-(void)connectGet:(NSString *)sUrl withContent:(NSString *)sContent showAlert:(BOOL)isShow
{
    mShowAlert = isShow;
    if(isShow)
    {
        [RoundAlert show];
    }
    NSString *sNewURL = [sUrl stringByAppendingString:sContent];
    NSLog(@"%s >> %s line: %d >> sNewUrl: %@ ",__FILE__,__FUNCTION__ ,__LINE__, sNewURL);
    NSURL *url = [NSURL URLWithString:sNewURL];
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval=15;
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //start the connection
    [connection start];
}

+ (NSData*)connectGet:(NSString *)sUrl withContent:(NSString *) sContent showAlert:(BOOL)isShow
{
    if(isShow)
        [RoundAlert show];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", sUrl, sContent]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(isShow)
        [RoundAlert hide];
    return received;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
        NSLog(@"%s %s : httpResponse.statuscode : %ld", __FILE__, __FUNCTION__,(long)[httpResponse statusCode]);
        if([httpResponse statusCode] != 200)
        {
            NSLog(@"%s %s : httpResponse.statuscode != 200", __FILE__, __FUNCTION__);
            if(mShowAlert)
                [RoundAlert hide];
            //Khong ket noi duoc den server
            [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:[@"SYS001" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
            [connection cancel];
            [connection release];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receiveData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s %s : START", __FILE__, __FUNCTION__);
//    [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    if(mShowAlert)
        [RoundAlert hide];
    NSDictionary *ketQuaTraVe = @{
                                  @"msgCode" : @"101",
                                  @"msgContent" : [error localizedDescription],
                                  @"result" : @{}
                                  };
    [ducnt_connectDelegate ketNoiThanhCong:[ketQuaTraVe JSONString]];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%s %s : START : %ld", __FILE__, __FUNCTION__, (unsigned long)receiveData.length);

    
    if(mShowAlert)
        [RoundAlert hide];
    NSString *htmlSTR = @"";
    if(!_bEncryptData)
    {
        htmlSTR = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
//        NSLog(@"%s %s : htmlSTR: %@", __FILE__, __FUNCTION__, htmlSTR);
    }
    else
    {
        htmlSTR = [Common quicklz_decrypt:receiveData];
    }
    if (ducnt_connectDelegate && htmlSTR) {
        [ducnt_connectDelegate ketNoiThanhCong:htmlSTR];
    }

    [connection cancel];
//    [connection release];
}

-(void)dealloc
{
    [receiveData release];
    if(mDinhDanh)
        [mDinhDanh release];
    [super dealloc];
}
@end
