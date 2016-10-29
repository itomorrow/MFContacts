//
//  MFAddressBookHelper.m
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MFAddressBookHelper.h"
#import "MFAddressBookAccessRoutine.h"
#import "MFAddressBookContactsRoutine.h"
#import "MFAddressBookChangeRoutine.h"
#import "MFThread.h"


@interface MFAddressBookHelper ()<MFAddressBookChangeDelegate>

@property (nonatomic, strong) MFAddressBookAccessRoutine *access;
@property (nonatomic, strong) MFAddressBookContactsRoutine *contacts;
@property (nonatomic, strong) MFAddressBookChangeRoutine *externalChange;
@property (nonatomic, strong) MFThread *thread;
@property (atomic, copy) void (^externalChangeCallback)();
@property (atomic, strong) dispatch_queue_t externalChangeQueue;

@end


@implementation MFAddressBookHelper

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    self.fieldsMask = MFContactFieldAll;
    self.thread = [[MFThread alloc] init];
    [self.thread start];
    [self.thread dispatchAsync:^ {
         MFAddressBookRefWrapper *refWrapper = [[MFAddressBookRefWrapper alloc] init];
         self.access = [[MFAddressBookAccessRoutine alloc] initWithAddressBookRefWrapper:refWrapper];
         if (refWrapper){
             self.contacts = [[MFAddressBookContactsRoutine alloc] initWithAddressBookRefWrapper:refWrapper];
             self.externalChange = [[MFAddressBookChangeRoutine alloc] initWithAddressBookRefWrapper:refWrapper];
             self.externalChange.delegate = self;
         }
         
         self.fieldsMask = MFContactFieldAll;
         self.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name.firstName" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"name.lastName" ascending:YES]];
     }];
    return self;
}

- (void)dealloc
{
    [self.thread cancel];
}

#pragma mark - public

+ (MFAddressBookAccess)access
{
    return [MFAddressBookAccessRoutine accessStatus];
}

- (void)readContacts:(MFReadContactsBlock)completionBlock
{
    [self readContactsOnQueue:dispatch_get_main_queue() completion:completionBlock];
}

- (void)readContactsOnQueue:(dispatch_queue_t)queue completion:(MFReadContactsBlock)completionBlock
{
    MFContactField fieldMask = self.fieldsMask;
    [self.thread dispatchAsync:^{
         [self.access requestAccessWithCompletion:^(BOOL granted, NSError *error){
              [self.thread dispatchAsync:^{
                   NSArray *contacts = granted ? [self.contacts allContactsWithContactFieldMask:fieldMask] : nil;
                   dispatch_async(queue, ^{
                                      completionBlock ? completionBlock(contacts, error) : nil;
                   });
               }];
          }];
     }];
}

- (void)readContactByIdentifier:(NSString *)identifier completion:(MFReadContactBlock)completion
{
    [self readContactByIdentifier:identifier onQueue:dispatch_get_main_queue() completion:completion];
}

- (void)readContactByIdentifier:(NSString *)identifier onQueue:(dispatch_queue_t)queue
                   completion:(MFReadContactBlock)completion
{
    [self.thread dispatchAsync:^{
         MFContact *contact = [self.contacts contactByIdentifier:identifier withFieldMMFk:self.fieldsMask];
         dispatch_async(queue, ^{
              completion ? completion(contact) : nil;
         });
     }];
}

- (void)writeContact:(nonnull MFContact *)contact
          completion:(nonnull MFWriteContactBlock)completion{
    [self writeContact:contact onQueue:dispatch_get_main_queue() completion:completion
    ];
}

- (void)writeContact:(nonnull MFContact *)contact
             onQueue:(nonnull dispatch_queue_t)queue
          completion:(nonnull MFWriteContactBlock)completion{
    [self.thread dispatchAsync:^{
        [self.contacts writeContact:contact];
        dispatch_async(queue, ^{
                           completion ? completion(nil) : nil;
        });
    }];
}

- (void)writeContacts:(nonnull NSArray *)contacts
           completion:(nonnull MFWriteContactBlock)completion{
    [self writeContacts:contacts onQueue:dispatch_get_main_queue() completion:completion];
}

- (void)writeContacts:(nonnull NSArray *)contacts
              onQueue:(nonnull dispatch_queue_t)queue
           completion:(nonnull MFWriteContactBlock)completion{
    [self.thread dispatchAsync:^{
        [self.contacts writeContacts:contacts];
        dispatch_async(queue, ^{
           completion ? completion(nil) : nil;
       });
    }];
}

// update contact
- (void)updateContact:(nonnull MFContact *)contact
           completion:(nonnull MFUpdateContactBlock)completion{
    [self updateContact:contact onQueue:dispatch_get_main_queue() completion:completion];
}

- (void)updateContact:(nonnull MFContact *)contact
              onQueue:(nonnull dispatch_queue_t)queue
           completion:(nonnull MFUpdateContactBlock)completion{
    [self.thread dispatchAsync:^{
        [self.contacts updateContact:contact];
        dispatch_async(queue, ^{
            completion ? completion(nil) : nil;
        });
    }];
}

- (void)updateContacts:(nonnull NSArray *)contacts
            completion:(nonnull MFUpdateContactBlock)completion{
    [self updateContacts:contacts onQueue:dispatch_get_main_queue() completion:completion];
}

- (void)updateContacts:(nonnull NSArray *)contacts
               onQueue:(nonnull dispatch_queue_t)queue
            completion:(nonnull MFUpdateContactBlock)completion{
    [self.thread dispatchAsync:^{
        [self.contacts updateContacts:contacts];
        dispatch_async(queue, ^{
            completion ? completion(nil) : nil;
        });
    }];
}

- (void)removeContactByIdentifier:(nonnull NSString *)identifier
                     completion:(nonnull MFRemoveContactBlock)completion{
    [self removeContactByIdentifier:identifier onQueue:dispatch_get_main_queue() completion:completion];
}

- (void)removeContactByIdentifier:(nonnull NSString *)identifier
                        onQueue:(nonnull dispatch_queue_t)queue
                     completion:(nonnull MFRemoveContactBlock)completion{
    [self.thread dispatchAsync:^{
        [self.contacts removeContactByIdentifier:identifier];
        dispatch_async(queue, ^{
           completion ? completion(nil) : nil;
       });
    }];
}

- (void)removeContactsByIdentifiers:(nonnull NSArray *)recordIDs
                       completion:(nonnull MFRemoveContactBlock)completion{
    [self removeContactsByIdentifiers:recordIDs onQueue:dispatch_get_main_queue() completion:completion];
}

- (void)removeContactsByIdentifiers:(nonnull NSArray *)recordIDs
                          onQueue:(nonnull dispatch_queue_t)queue
                       completion:(nonnull MFRemoveContactBlock)completion{
    [self.thread dispatchAsync:^{
        [self.contacts removeContactsByIdentifiers:recordIDs];
        dispatch_async(queue, ^{
           completion ? completion(nil) : nil;
       });
    }];
}

- (void)readPhotoByIdentifier:(nonnull NSString *)identifier completion:(MFReadPhotoBlock)completion
{
    [self readPhotoByIdentifier:identifier onQueue:dispatch_get_main_queue() completion:completion];
}

- (void)readPhotoByIdentifier:(NSString *)identifier onQueue:(dispatch_queue_t)queue
                 completion:(MFReadPhotoBlock)completion
{
    [self.thread dispatchAsync:^
     {
         NSData *image = [self.contacts imageWithIdentifier:identifier];
         dispatch_async(queue, ^{
            completion ? completion(image) : nil;
        });
     }];
}

- (void)startObserveChangesWithCallback:(void (^)())callback
{
    [self startObserveChangesOnQueue:dispatch_get_main_queue() callback:callback];
}

- (void)startObserveChangesOnQueue:(dispatch_queue_t)queue callback:(void (^)())callback
{
    self.externalChangeCallback = callback;
    self.externalChangeQueue = queue;
}

- (void)stopObserveChanges
{
    self.externalChangeCallback = nil;
    self.externalChangeQueue = nil;
}

- (void)requestAccess:(nonnull MFRequestAccessBlock)completionBlock
{
    [self requestAccessOnQueue:dispatch_get_main_queue() completion:completionBlock];
}

- (void)requestAccessOnQueue:(nonnull dispatch_queue_t)queue
                  completion:(nonnull MFRequestAccessBlock)completionBlock
{
    [self.thread dispatchAsync:^{
         [self.access requestAccessWithCompletion:^(BOOL granted, NSError *error){
              dispatch_async(queue, ^{
                 completionBlock ? completionBlock(granted, error) : nil;
             });
          }];
     }];
}

#pragma mark - APAddressBookChangeDelegate
- (void)addressBookDidChange
{
    dispatch_queue_t queue = self.externalChangeQueue ?: dispatch_get_main_queue();
    dispatch_async(queue, ^{
       self.externalChangeCallback ? self.externalChangeCallback() : nil;
   });
}


@end
