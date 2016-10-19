//
//  ASAddressBookBaseRoutine.m
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MFAddressBookBaseRoutine.h"


@interface MFAddressBookBaseRoutine ()
@property (nonatomic, strong) MFAddressBookRefWrapper *wrapper;
@end

@implementation MFAddressBookBaseRoutine

#pragma mark - life cycle

- (instancetype)initWithAddressBookRefWrapper:(MFAddressBookRefWrapper *)wrapper
{
    self = [super init];
    self.wrapper = wrapper;
    return self;
}

@end
