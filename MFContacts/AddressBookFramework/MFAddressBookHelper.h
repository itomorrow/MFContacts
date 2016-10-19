//
//  MFAddressBookHelper.h
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFContactsHelperProtocol.h"


@interface MFAddressBookHelper : NSObject<MFContactsHelperProtocol>

@property (nonatomic, assign) MFContactField fieldsMask;
@property (nullable, nonatomic, strong) NSArray <NSSortDescriptor *> *sortDescriptors;


@end

