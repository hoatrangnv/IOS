//
//  CheckNetworkStatus.m
//  VASTelecom
//  Copyright 2011 C4-CMCSoft. All rights reserved.
//

#import "CheckNetworkStatus.h"
#import "Reachability.h"

@implementation CheckNetworkStatus

-(BOOL) checkNetworkStatus{
    internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    [internetReachable startNotifier];
    
    BOOL isDown = FALSE;
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            
            isDown = TRUE;
            break;
        }
        case ReachableViaWiFi:
        {
//            NSLog(@"The internet is working via WIFI.");
            isDown = FALSE;
            break;
        }
        case ReachableViaWWAN:
        {
//            NSLog(@"The internet is working via WWAN.");
            isDown = FALSE;
            break;
        }
    }
    
    return isDown;
}
@end
