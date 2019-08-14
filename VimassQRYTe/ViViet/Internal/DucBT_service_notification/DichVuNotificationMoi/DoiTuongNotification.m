//
//  DoiTuongNotification.m
//  ViMASS
//
//  Created by DucBT on 10/14/14.
//
//

#import "DoiTuongNotification.h"
#import "Common.h"

@implementation DoiTuongNotification


- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        NSDictionary *aps = [dict valueForKey:@"aps"];
        if(aps)
        {
            NSNumber *appId = [aps objectForKey:@"appId"];
            if(appId)
                self.appId = appId;
            
            NSNumber *funcID = [aps objectForKey:@"funcID"];
            if(funcID)
                self.funcID = funcID;
            
            NSString *alertId = [aps objectForKey:@"alertId"];
            if(alertId)
                self.alertId = alertId;
            
            NSString *alert = [aps objectForKey:@"alert"];
            if(alert)
                self.alert = alert;
            
            NSNumber *time = [aps objectForKey:@"time"];
            if(time)
                self.time = time;
            
            NSNumber *totalFunc = [aps objectForKey:@"totalFunc"];
            if(totalFunc)
                self.totalFunc = totalFunc;
            
            NSNumber *badge = [aps objectForKey:@"badge"];
            if(badge)
                self.badge = badge;
            
            NSString *alertContent = [aps objectForKey:@"alertContent"];
            if(alertContent)
                self.alertContent = alertContent;
            
            NSString *sender = [aps objectForKey:@"sender"];
            if(sender)
                self.sender = sender;
            
            NSString *recipient = [aps objectForKey:@"recipient"];
            if(recipient)
                self.recipient = recipient;
            
            NSString *nameAlias = [aps objectForKey:@"nameAlias"];
            if(nameAlias)
                self.nameAlias = nameAlias;

            NSString *nameAliasRecipient = [aps objectForKey:@"nameAliasRecipient"];
            if(nameAliasRecipient)
                self.nameAliasRecipient = nameAliasRecipient;
            NSNumber *status = [aps objectForKey:@"status"];
            if(status)
                self.status = status;
            
            NSString *idShow = [aps objectForKey:@"idShow"];
            if(idShow)
                self.idShow = idShow;

            NSString *lydo = [aps objectForKey:@"lydo"];
            if(lydo)
                self.lydo = lydo;

            NSString *storeId = [aps objectForKey:@"storeId"];
            if(storeId)
                self.storeId = storeId;
            
            NSNumber *statusShow = [aps objectForKey:@"statusShow"];
            if(statusShow)
                self.statusShow = statusShow;
            
            NSNumber *typeShow = [aps objectForKey:@"typeShow"];
            if(typeShow)
                self.typeShow = typeShow;
        }
    }
    return self;
}

- (NSString*)layThoiGian
{
    NSString *sThoiGian = @"";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_time longLongValue] / 1000];
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    if([today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year] == [otherDay year] &&
       [today era] == [otherDay era])
    {
        //do stuff
        sThoiGian = [Common date:date toStringWithFormat:@"HH:mm"];
    }
    else
    {
        sThoiGian = [Common date:date toStringWithFormat:@"dd.MM.yyyy HH:mm"];
    }
    return sThoiGian;
}

- (NSDate*)layThoiGianTraVeNSDate
{
    return [NSDate dateWithTimeIntervalSince1970:[_time longLongValue] / 1000];
}

- (void)dealloc
{
    [_idShow release];
    [_lydo release];
    [_statusShow release];
    [_storeId release];
    [_typeShow release];
    [_alertContent release];
    [_appId release];
    [_funcID release];
    [_alertId release];
    [_alert release];
    [_time release];
    [_badge release];
    [_totalFunc release];
    [_sender release];
    [_recipient release];
    [_nameAlias release];
    [_nameAliasRecipient release];
    [_status release];
    [super dealloc];
}


@end
