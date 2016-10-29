//
//  ASContactBuilder.h
//  AndroidShell
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import "MFTypes.h"

@class MFContact;

@interface MFContactUpdate : NSObject

- (void)updateContact:(MFContact*)contactSrc toContactRef:(CNMutableContact*)contactDst;

@end
