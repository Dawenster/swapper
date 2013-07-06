//
//  Shift.h
//  Swapper
//
//  Created by David Wen on 2013-07-06.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shift : NSObject

- (NSString *)formatTitle:(Shift *)shift;
- (NSString * )formatSubTitle:(Shift *)shift;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *locationDetail;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, assign) int duration;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign) BOOL taken;
@property (nonatomic, copy) NSString *notes;

@end
