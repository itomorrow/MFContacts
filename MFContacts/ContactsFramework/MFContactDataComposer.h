//
//  MFContactDataComposer.h
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>

@class MFName;
@class MFJob;
@class MFSource;
@class MFRecordDate;

@interface MFContactDataComposer : NSObject

@property (nonatomic, assign) CNMutableContact* contactRef;

- (void)composeName:(MFName*)name;
- (void)composeJob:(MFJob*)job;
- (void)composePhones:(NSArray*)phones;
- (void)composeBirthday:(NSDate*)date;
- (void)composeNote:(NSString*)note;
- (void)composeEmails:(NSArray*)emails;
- (void)composeWebsites:(NSArray*)urls;
- (void)composeAddresses:(NSArray*)addresses;
- (void)composeSocialProfiles:(NSArray*)profiles;
- (void)composeRelatedPersons:(NSArray*)persons;
- (void)composeDates:(NSArray*)dates;
- (void)composePhoto:(UIImage *)image;

@end




