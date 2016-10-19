//
//  MFContactsAccessRoutine.h
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFContactsBaseRoutine.h"
#import "MFTypes.h"

@interface MFContactsAccessRoutine : MFContactsBaseRoutine

- (void)requestAccessWithCompletion:(void (^)(BOOL granted, NSError *error))completionBlock;
+ (MFAddressBookAccess)accessStatus;

@end
