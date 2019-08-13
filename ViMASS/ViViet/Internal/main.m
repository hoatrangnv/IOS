//#import <UIKit/UIKit.h>
#import "AppDelegate.h"

void uncaughtException(NSException *except)
{
    NSLog(@"catch exception");
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    [standard setObject:except.description forKey:@"exception"];
    [standard synchronize];
}
 
//int main(int argc, char *argv[])
//{
//    @autoreleasepool
//    {
//        NSSetUncaughtExceptionHandler(uncaughtException);
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//    }
//}

/* cv*/
int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = -1;
    @try {
        retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
    @catch (NSException* exception) {
        NSLog(@"Uncaught exception: %@", exception.description);
        NSLog(@"Stack trace: %@", [exception callStackSymbols]);
    }
    [pool release];
    return retVal;
}
