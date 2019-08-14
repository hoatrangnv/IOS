//
//  CheckNetworkStatus.h
//  VASTelecom
//  Copyright 2011 C4-CMCSoft. All rights reserved.
//


#import "Reachability.h"

@interface CheckNetworkStatus : NSObject {
    Reachability* internetReachable;
}

-(BOOL) checkNetworkStatus;

@end
