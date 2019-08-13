//
//  HomeScreen.h
//  CameraUploadApp
//
//  Created by QUANGHIEP on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseScreen.h"
#import "ModelInterfaces.h"
@interface HomeScreen : BaseScreen<UIAlertViewDelegate,UITableViewDataSource, UITableViewDelegate>
{
    ModelInterfaces * modelInterface;
    NSMutableArray * dataToTable;
}
@end
