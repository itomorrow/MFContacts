//
//  MFContactsHelperBMFe.h
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFContactsModels.h"
#import "MFTypes.h"



typedef void(^MFRequestAccessBlock)(BOOL granted, NSError * _Nullable error);
typedef void(^MFReadContactsBlock)(NSArray <MFContact *> * _Nullable contacts, NSError * _Nullable error);
typedef void(^MFWriteContactBlock)(NSError * _Nullable error);
typedef void(^MFRemoveContactBlock)(NSError * _Nullable error);
typedef void(^MFReadContactBlock)(MFContact * _Nullable contact);
typedef void(^MFReadPhotoBlock)(UIImage * _Nullable photo);



@protocol MFContactsHelperProtocol <NSObject>

// access
+ (MFAddressBookAccess)access;

- (void)requestAccess:(nonnull MFRequestAccessBlock)completionBlock;
- (void)requestAccessOnQueue:(nonnull dispatch_queue_t)queue
                  completion:(nonnull MFRequestAccessBlock)completionBlock;

// read contact
- (void)readContacts:(nonnull MFReadContactsBlock)completionBlock;
- (void)readContactsOnQueue:(nonnull dispatch_queue_t)queue
                 completion:(nonnull MFReadContactsBlock)completionBlock;

- (void)readContactByIdentifier:(nonnull NSString *)identifier
                   completion:(nonnull MFReadContactBlock)completion;
- (void)readContactByIdentifier:(nonnull NSString *)identifier
                      onQueue:(nonnull dispatch_queue_t)queue
                   completion:(nonnull MFReadContactBlock)completion;

- (void)readPhotoByIdentifier:(nonnull NSString *)identifier
                 completion:(nonnull MFReadPhotoBlock)completion;
- (void)readPhotoByIdentifier:(nonnull NSString *)identifier
                    onQueue:(nonnull dispatch_queue_t)queue
                 completion:(nonnull MFReadPhotoBlock)completion;

// write contact
- (void)writeContact:(nonnull MFContact *)contact
                   completion:(nonnull MFWriteContactBlock)completion;
- (void)writeContact:(nonnull MFContact *)contact
                      onQueue:(nonnull dispatch_queue_t)queue
                   completion:(nonnull MFWriteContactBlock)completion;

- (void)writeContacts:(nonnull NSArray *)contacts
          completion:(nonnull MFWriteContactBlock)completion;
- (void)writeContacts:(nonnull NSArray *)contacts
             onQueue:(nonnull dispatch_queue_t)queue
          completion:(nonnull MFWriteContactBlock)completion;

// remove contact
- (void)removeContactByIdentifier:(nonnull NSString *)identifier
          completion:(nonnull MFRemoveContactBlock)completion;
- (void)removeContactByIdentifier:(nonnull NSString *)identifier
             onQueue:(nonnull dispatch_queue_t)queue
          completion:(nonnull MFRemoveContactBlock)completion;

- (void)removeContactsByIdentifiers:(nonnull NSArray *)identifiers
           completion:(nonnull MFRemoveContactBlock)completion;
- (void)removeContactsByIdentifiers:(nonnull NSArray *)identifiers
              onQueue:(nonnull dispatch_queue_t)queue
           completion:(nonnull MFRemoveContactBlock)completion;

// change observer
- (void)startObserveChangesWithCallback:(nonnull void (^)())callback;
- (void)startObserveChangesOnQueue:(nonnull dispatch_queue_t)queue
                          callback:(nonnull void (^)())callback;
- (void)stopObserveChanges;

@end

