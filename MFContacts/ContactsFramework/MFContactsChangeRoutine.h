//
//  MFContactsChangeRoutine.h
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFContactsBaseRoutine.h"

@protocol MFContactsChangeRoutineDelegate;

@interface MFContactsChangeRoutine : MFContactsBaseRoutine

@property (nonatomic, weak) NSObject <MFContactsChangeRoutineDelegate> *delegate;

@end


@protocol MFContactsChangeRoutineDelegate <NSObject>

- (void)contactsDidChange;

@end
