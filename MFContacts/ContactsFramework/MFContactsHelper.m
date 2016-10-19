//
//  MFContactsHelper.m
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//


#import "MFContactsHelper.h"
#import "MFContactsAccessRoutine.h"
#import "MFContactsStoreRoutine.h"
#import "MFContactsChangeRoutine.h"
#import "MFThread.h"

@interface MFContactsHelper ()<MFContactsChangeRoutineDelegate>

@property (nonatomic, strong) MFContactsAccessRoutine *access;
@property (nonatomic, strong) MFContactsStoreRoutine *contacts;
@property (nonatomic, strong) MFContactsChangeRoutine *externalChange;
@property (nonatomic, strong) MFThread *thread;
@property (atomic, copy) void (^externalChangeCallback)();
@property (atomic, strong) dispatch_queue_t externalChangeQueue;

@end

@implementation MFContactsHelper

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    self.fieldsMask = MFContactFieldAll;
    self.thread = [[MFThread alloc] init];
    [self.thread start];
    [self.thread dispatchAsync:^
     {
         CNContactStore *store = [[CNContactStore alloc] init];
         self.access = [[MFContactsAccessRoutine alloc] initWithContactStore:store];
         self.contacts = [[MFContactsStoreRoutine alloc] initWithContactStore:store];
         self.externalChange = [[MFContactsChangeRoutine alloc] initWithContactStore:store];
         self.externalChange.delegate = self;
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
    return [MFContactsAccessRoutine accessStatus];
}

- (void)readContacts:(MFReadContactsBlock)completionBlock
{
    [self readContactsOnQueue:dispatch_get_main_queue() completion:completionBlock];
}

- (void)readContactsOnQueue:(dispatch_queue_t)queue completion:(MFReadContactsBlock)completionBlock
{
    MFContactField fieldMask = self.fieldsMask;
    [self.thread dispatchAsync:^{
        [self.contacts allContactsWithContactFieldMask:fieldMask with:^(NSArray<MFContact *> * _Nullable contacts, NSError * _Nullable error) {
            dispatch_async(queue, ^{
                completionBlock ? completionBlock(contacts, nil) : nil;
            });
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
         MFContact *contact = [self.contacts contactByIdentifier:identifier withFieldMask:self.fieldsMask];
         dispatch_async(queue, ^{
            completion ? completion(contact) : nil;
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
    [self.thread dispatchAsync:^{
         UIImage *image = [self.contacts imageWithIdentifier:identifier];
         dispatch_async(queue, ^
                        {
                            completion ? completion(image) : nil;
                        });
     }];
}

- (void)writeContact:(nonnull MFContact *)contact
          completion:(nonnull MFWriteContactBlock)completion{
    [self writeContact:contact onQueue:dispatch_get_main_queue() completion:completion];
}

- (void)writeContact:(nonnull MFContact *)contact
             onQueue:(nonnull dispatch_queue_t)queue
          completion:(nonnull MFWriteContactBlock)completion{
    [self.thread dispatchAsync:^{
        NSError* err = [self.contacts writeContact:contact];
        dispatch_async(queue, ^{
           completion ? completion(err) : nil;
       });
    }];
}

- (void)writeContacts:(nonnull NSArray *)contact
           completion:(nonnull MFWriteContactBlock)completion{
    [self writeContacts:contact onQueue:dispatch_get_main_queue() completion:completion];
}

- (void)writeContacts:(nonnull NSArray *)contact
              onQueue:(nonnull dispatch_queue_t)queue
           completion:(nonnull MFWriteContactBlock)completion{
    [self.thread dispatchAsync:^{
        NSError* err = [self.contacts writeContacts:contact];
        dispatch_async(queue, ^{
            completion ? completion(err) : nil;
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
    [self.thread dispatchAsync:^
     {
         [self.access requestAccessWithCompletion:^(BOOL granted, NSError *error)
          {
              dispatch_async(queue, ^
                             {
                                 completionBlock ? completionBlock(granted, error) : nil;
                             });
          }];
     }];
}

#pragma mark - MFContactsChangeRoutineDelegate
- (void)contactsDidChange
{
    dispatch_queue_t queue = self.externalChangeQueue ?: dispatch_get_main_queue();
    dispatch_async(queue, ^
                   {
                       self.externalChangeCallback ? self.externalChangeCallback() : nil;
                   });
}

@end
