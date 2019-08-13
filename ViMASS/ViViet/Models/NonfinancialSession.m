//
//  NonfinancialSession.m
//  ViMASS
//
//  Created by Chung NV on 2/19/14.
//
//

#import "NonfinancialSession.h"
#import "LoginController.h"
#import "Common.h"
#import "ViToken.h"
#import "ViTokenViewController.h"
static NonfinancialSession * _share = nil;

@interface NonfinancialSession()
@property (nonatomic, copy) NSString * phoneNumber;
@property (nonatomic, copy) NSString * session;

/*
 *
 */
@property (nonatomic, retain) NSMutableDictionary * invalidSessions;
@end

@implementation NonfinancialSession
{
    void (^_callBack)(BOOL, NSString *, NSString *);
    void (^_callBack_vitoken)(BOOL);
}
+(NonfinancialSession *) share
{
    if (!_share)
    {
        _share = [NonfinancialSession new];
    }
    return _share;
}

+(NSString *)phoneNumber
{
    NonfinancialSession *share = [NonfinancialSession share];
    if (share)
    {
        return share.phoneNumber;
    }
    return nil;
}

+(NSString *)session
{
    NonfinancialSession *share = [NonfinancialSession share];
    if (share)
    {
        return share.session;
    }
    return nil;
}

#pragma mark - 
+(void)set_session_invalid:(NSString *)serviceKey
{
    NonfinancialSession *share = [self share];
    if (share)
    {
        if (share.invalidSessions == nil)
        {
            share.invalidSessions = [[NSMutableDictionary new] autorelease];
        }
        [share.invalidSessions setObject:[NSNumber numberWithBool:YES] forKey:serviceKey];
    }
}
+(void)service:(NSString *)serviceKey
   get_session:(void (^)(BOOL, NSString *, NSString *))callBack
{
    NonfinancialSession *share = [self share];
    if (share == nil)
    {
        return;
    }
    share->_callBack = [callBack copy];
    
    NSString *session = [self session];
    NSString *phoneNumber = [self phoneNumber];
    if ([self is_valid_string:session] && [self is_valid_string:phoneNumber])
    {
        BOOL invalid_session = [share.invalidSessions objectForKey:serviceKey];
        if (invalid_session)
        {
            [share login];
        }else
        {
            [share get_session_success];
        }
    }else
    {
        [share login];
    }
}

-(void) login
{
    __block NonfinancialSession *weak = self;
    [LoginController loginForFinance:NO callback:^(BOOL logined, id model)
    {
        if (logined)
        {
            NSDictionary * dict_model = (NSDictionary *)model;
            weak.session = [dict_model objectForKey:@"token"];
            weak.phoneNumber = [dict_model objectForKey:@"user"];
            [weak get_session_success];
        }else
        {
            [weak get_session_fail];
        }
    }];
}

-(void) get_session_fail
{
    if (_callBack)
    {
        [_callBack release];
    }
}
-(void) get_session_success
{
    if (_callBack)
    {
        self.invalidSessions = nil;
        _callBack(YES,_session,_phoneNumber);
        [_callBack release];
    }
    
}

#pragma mark -
+(BOOL) is_valid_string:(NSString *) string
{
    if (string && string.trim.length > 0)
    {
        return YES;
    }
    return NO;
}

#pragma mark - Check Vitoken
+(void)check_vitoken_exist:(void (^)(BOOL))callBack
{
    if (callBack == nil)
    {
        return;
    }
    if ([ViToken available])
    {
        callBack(YES);
    }else
    {
        NonfinancialSession *share = [NonfinancialSession share];
        
        share->_callBack_vitoken = [callBack copy];
        __block NonfinancialSession *weak = share;
        [ViTokenViewController confirm_register_ViToken:^(BOOL success){
             /*
              * success : VitokenController : when user click Back button
              * NOT : user not agree Reg ViToken : Cancel
              */
             if (success)
             {
                 weak->_callBack_vitoken([ViToken available]);
             }else
             {
                 weak->_callBack_vitoken(NO);
             }
         }];
    }
}

-(void)dealloc
{
    [_callBack release];
    [_callBack_vitoken release];
    [_phoneNumber release];
    [_session release];
    [super dealloc];
}
@end
