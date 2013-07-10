//
//  SwapperViewController.h
//  Swapper
//
//  Created by David Wen on 2013-07-06.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddShiftViewController.h"
#import "ShiftDetailViewController.h"
#import "MBProgressHUD.h"

@interface AvailableShiftsViewController : UITableViewController <AddShiftViewControllerDelegate> {
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) NSMutableData *responseData;

- (IBAction)reloadShifts;

@end
