//
//  MFContactsModels.m
//  AddressBook
//
//  Created by Mason on 16/9/21.
//  Copyright © 2016年 Mason. All rights reserved.
//

#import "MFContactsModels.h"
#import <AddressBook/AddressBook.h>

@interface MFAddressBookRefWrapper ()
{
    ABAddressBookRef ref;
}
@property (nonatomic, strong) NSError *error;
@end

@implementation MFAddressBookRefWrapper

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    CFErrorRef error = NULL;
    ref = ABAddressBookCreateWithOptions(NULL, &error);
    if (error)
    {
        self.error = (__bridge NSError *)(error);
    }
    return self;
}

- (void)dealloc
{
    if (ref)
    {
        CFRelease(ref);
    }
}

#pragma mark - properties

- (ABAddressBookRef)ref
{
    return ref;
}

@end

@implementation MFContact

@end


@implementation MFName
- (nullable instancetype)initWithFirstName:(nullable NSString*)firstName lastName:(nullable NSString*)lastName{
    self = [super init];
    if (self) {
        _firstName = firstName;
        _lastName = lastName;
    }
    return self;
}

@end


@implementation MFJob

@end


@implementation MFPhone

@end

@implementation MFWebSite

@end

@implementation MFEmail

@end

@implementation MFAddress

@end

@implementation MFSocialProfile

@end

@implementation MFRelatedPerson

@end

@implementation MFSource

@end


@implementation MFContactDate

@end


@implementation MFRecordDate

@end



