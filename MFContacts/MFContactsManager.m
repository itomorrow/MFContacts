//
//  MFContactsManager.m
//  MFContactsDemo
//
//  Created by Mason on 2016/10/18.
//  Copyright © 2016年 Mason. All rights reserved.
//

#import "MFContactsManager.h"
#import "MFContactsHelper.h"
#import "MFAddressBookHelper.h"

@implementation MFContactsManager

static MFContactsManager* manager = nil;
static id<MFContactsHelperProtocol> helper = nil;

+ (nonnull instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version > 9.0) {
            helper = [[MFContactsHelper alloc] init];
        } else {
            helper = [[MFAddressBookHelper alloc] init];
        }
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [MFContactsManager shareManager];
}

- (id)copyWithZone:(struct _NSZone *)zone{
    return [MFContactsManager shareManager];
}

#pragma mark - MFContactsHelperProtocol
// access
+ (MFAddressBookAccess)access{
    return [helper access];
}

- (void)requestAccess:(nonnull MFRequestAccessBlock)completionBlock{
    return [helper requestAccess:completionBlock];
}

- (void)requestAccessOnQueue:(nonnull dispatch_queue_t)queue
                  completion:(nonnull MFRequestAccessBlock)completionBlock{
    return [helper requestAccessOnQueue:queue completion:completionBlock];
}

// read contact
- (void)readContacts:(nonnull MFReadContactsBlock)completionBlock{
    return [helper readContacts:completionBlock];
}

- (void)readContactsOnQueue:(nonnull dispatch_queue_t)queue
                 completion:(nonnull MFReadContactsBlock)completionBlock{
    return [helper readContactsOnQueue:queue completion:completionBlock];
}

- (void)readContactByIdentifier:(nonnull NSString *)identifier
                     completion:(nonnull MFReadContactBlock)completion{
    return [helper readContactByIdentifier:identifier completion:completion];
}

- (void)readContactByIdentifier:(nonnull NSString *)identifier
                        onQueue:(nonnull dispatch_queue_t)queue
                     completion:(nonnull MFReadContactBlock)completion{
    return [helper readContactByIdentifier:identifier onQueue:queue completion:completion];
}

- (void)readPhotoByIdentifier:(nonnull NSString *)identifier
                   completion:(nonnull MFReadPhotoBlock)completion{
    return [helper readPhotoByIdentifier:identifier completion:completion];
}

- (void)readPhotoByIdentifier:(nonnull NSString *)identifier
                      onQueue:(nonnull dispatch_queue_t)queue
                   completion:(nonnull MFReadPhotoBlock)completion{
    return [helper readPhotoByIdentifier:identifier onQueue:queue completion:completion];
}

// write contact
- (void)writeContact:(nonnull MFContact *)contact
          completion:(nonnull MFWriteContactBlock)completion{
    return [helper writeContact:contact completion:completion];
}

- (void)writeContact:(nonnull MFContact *)contact
             onQueue:(nonnull dispatch_queue_t)queue
          completion:(nonnull MFWriteContactBlock)completion{
    return [helper writeContact:contact onQueue:queue completion:completion];
}

- (void)writeContacts:(nonnull NSArray *)contacts
           completion:(nonnull MFWriteContactBlock)completion{
    return [helper writeContacts:contacts completion:completion];
}

- (void)writeContacts:(nonnull NSArray *)contacts
              onQueue:(nonnull dispatch_queue_t)queue
           completion:(nonnull MFWriteContactBlock)completion{
    return [helper writeContacts:contacts onQueue:queue completion:completion];
}

// remove contact
- (void)removeContactByIdentifier:(nonnull NSString *)identifier
                       completion:(nonnull MFRemoveContactBlock)completion{
    return [helper removeContactByIdentifier:identifier completion:completion];
}

- (void)removeContactByIdentifier:(nonnull NSString *)identifier
                          onQueue:(nonnull dispatch_queue_t)queue
                       completion:(nonnull MFRemoveContactBlock)completion{
    return [helper removeContactByIdentifier:identifier onQueue:queue completion:completion];
}

- (void)removeContactsByIdentifiers:(nonnull NSArray *)identifiers
                         completion:(nonnull MFRemoveContactBlock)completion{
    return [helper removeContactsByIdentifiers:identifiers completion:completion];
}

- (void)removeContactsByIdentifiers:(nonnull NSArray *)identifiers
                            onQueue:(nonnull dispatch_queue_t)queue
                         completion:(nonnull MFRemoveContactBlock)completion{
    return [helper removeContactsByIdentifiers:identifiers onQueue:queue completion:completion];
}

// change observer
- (void)startObserveChangesWithCallback:(nonnull void (^)())callback{
    return [helper startObserveChangesWithCallback:callback];
}

- (void)startObserveChangesOnQueue:(nonnull dispatch_queue_t)queue
                          callback:(nonnull void (^)())callback{
    return [helper startObserveChangesOnQueue:queue callback:callback];
}

- (void)stopObserveChanges{
    return [helper stopObserveChanges];
}

@end
