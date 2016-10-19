//
//  MFContactsBaseRoutine.m
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//


#import "MFContactsBaseRoutine.h"


@interface MFContactsBaseRoutine ()
@property (nonatomic, strong) CNContactStore *contactStore;
@end

@implementation MFContactsBaseRoutine

#pragma mark - life cycle

- (instancetype)initWithContactStore:(CNContactStore *)contactStore
{
    self = [super init];
    self.contactStore = contactStore;
    return self;
}

@end
