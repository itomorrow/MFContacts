//
//  ASAddressBookChangeRoutine.h
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFAddressBookBaseRoutine.h"

@protocol MFAddressBookChangeDelegate;

@interface MFAddressBookChangeRoutine : MFAddressBookBaseRoutine

@property (nonatomic, weak) NSObject <MFAddressBookChangeDelegate> *delegate;

@end


@protocol MFAddressBookChangeDelegate <NSObject>

- (void)addressBookDidChange;

@end
