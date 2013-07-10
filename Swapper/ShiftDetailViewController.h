//
//  ShiftDetailViewController.h
//  Swapper
//
//  Created by David Wen on 2013-07-07.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shift.h"
#import <MessageUI/MessageUI.h>

@interface ShiftDetailViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) Shift *shift;

- (IBAction)sendEmail;

@end
