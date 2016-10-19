//
//  MFContactsManager.h
//  MFContactsDemo
//
//  Created by Mason on 2016/10/18.
//  Copyright © 2016年 Mason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFContactsHelperProtocol.h"

@interface MFContactsManager : NSObject <MFContactsHelperProtocol>

+ (nonnull instancetype)shareManager;

@end
