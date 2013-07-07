//
//  LocationPickerViewController.h
//  Swapper
//
//  Created by David Wen on 2013-07-06.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocationPickerViewController;

@protocol LocationPickerViewControllerDelegate <NSObject>
- (void)locationPickerDidCancel:(LocationPickerViewController *)picker;
- (void)locationPicker:(LocationPickerViewController *)picker didPickLocation:(NSString *)location;
@end

@interface LocationPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIPickerView *LocationPicker;
@property (nonatomic, weak) id <LocationPickerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *location;

- (IBAction)cancel;
- (IBAction)done;

@end
