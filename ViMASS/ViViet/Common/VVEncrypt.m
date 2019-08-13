//
//  VVEncrypt.m
//  ViMASS
//
//  Created by Chung NV on 4/25/13.
//
//

#import "VVEncrypt.h"

int vvrandom (int max)
{
    return (int)(arc4random() % max);
}

#define VVEncrypt_MIN 48
#define VVEncrypt_MAX 122

typedef unsigned char ECHAR;

@implementation VVEncrypt

#pragma mark - Public

-(NSString *)process:(NSString *)strInput
{
    int i,n;
    n = layer > 0 ? layer : vvrandom(5);
    for (i=0; i< n; i++)
    {
        strInput = [self step1:strInput];
        strInput = [self step2:strInput];
    }
    
    NSString *re = [NSString stringWithFormat:@"%@%c",strInput,((char)(n + min))  ];
    return re;
}

-(NSString *)getEncrypt:(NSString *)strInput
{
    NSString* encrypt = [self process:strInput];
    return encrypt;
}

+(NSString *)getAppToken
{
    VVEncrypt * vvEncrypt = [VVEncrypt new];
    NSString * appToken = [vvEncrypt getEncrypt:@"vvmc.vimass.vn"];
    [vvEncrypt release];
    return appToken;
}

+(NSString *)getAppToken:(NSString *)account
                 timeOut:(long)timeout
{
    NSDate *now = [NSDate date];
    long int time = now.timeIntervalSince1970 + timeout;
    now = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * dFomatter = [NSDateFormatter new];
    [dFomatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *expire_date = [dFomatter stringFromDate:now];
    NSString *token = [NSString stringWithFormat:@"%@!%@",expire_date,account];
    
    VVEncrypt * vvEncrypt = [VVEncrypt new];
    NSString * token_encrypt = [vvEncrypt getEncrypt:token];
    [vvEncrypt release];
    return token_encrypt;
}
- (ECHAR *)toCharArray:(NSString *)str padding:(int)p
{
    ECHAR *s = malloc(str.length + p);
    memcpy(s, [str cStringUsingEncoding:NSASCIIStringEncoding], str.length);
    
    return s;
}

-(NSString *)step1:(NSString *)strInput
{
    NSInteger strInput_length = strInput.length;
    if (strInput_length == 0)
        return @"";
    
    ECHAR *cin = [self toCharArray:strInput padding:0];
    
    
    ECHAR *cout = malloc(strInput_length + 2);
    cout[strInput_length + 1] = 0;
    
    int key = vvrandom(max - min + 1) + min;
    
    for (int i = 0; i < strInput_length; i++)
    {
        ECHAR c = cin[i];
        c = (ECHAR) (((c - min) + (key - min)) % (max - min + 1) + min);
        
        cout[i] = c;
    }
    
    cout[strInput_length] = key;
    
    NSString *ret = [NSString stringWithCString:(char *)cout encoding:NSASCIIStringEncoding];
    free(cout);
    free (cin);
    return ret;
}

-(NSString *)step2:(NSString *)strInput
{
    NSInteger l = strInput.length;
    if (l == 0)
        return @"";
    
    ECHAR *cInput = [self toCharArray:strInput padding:0];
    
    
    int k = vvrandom(5) + 1;
    
    ECHAR *strKey = malloc (k);
    for (int i = 0; i < k; i++)
    {
        strKey[i] = (ECHAR)(vvrandom(max - min + 1) + min);
    }
        
    long cKey_length = l % k == 0 ? l / k : (l / k + 1);
    cKey_length *= k;
    
    ECHAR *cKey = malloc(cKey_length);
    for (int i = 0; i < cKey_length; i+=k)
    {
        memcpy(cKey + i, strKey, k);
    }
    
    for (int i = 0; i < l; i++)
    {
        cInput[i] = (ECHAR) (((cInput[i] - min) + (cKey[i] - min)) % (max - min + 1) + min);
    }
    
    ECHAR *tmp = malloc(l + k + 2);
    
    memcpy(tmp, cInput, l);
    memcpy(tmp + l, strKey, k);
    tmp[l + k] = (ECHAR) (k + min);
    tmp[l + k + 1] = 0;
    
    NSString *ret = [NSString stringWithCString:(char *)tmp encoding:NSASCIIStringEncoding];
    
    free(cInput);
    free(tmp);
    free(strKey);
    
    return ret;
}

#pragma mark - Init & @syn
-(id)init
{
    if (self = [super init])
    {
        self.min = VVEncrypt_MIN;
        self.max = VVEncrypt_MAX;
        self.layer = 3;
    }
    return self;
}

-(id)initWithMin:(int)  min_
             max:(int)  max_
           layer:(int)  layer_
{
    if (self = [super init])
    {
        self.min = min_;
        self.max = max_;
        self.layer = layer_;
    }
    return self;
}
@synthesize min,max,layer;


@end
