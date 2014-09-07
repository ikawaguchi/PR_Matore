//
//  PRMAppDefaults.h
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/06.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRMAppDefaults : NSObject

+ (PRMAppDefaults *)currentDefaults;
- (void)synchronize;

- (NSString *)blogOpenUrl;
- (void)setBlogOpenUrl:(NSString *)param;

- (NSString *)blogOpenTitle;
- (void)setBlogOpenTitle:(NSString *)param;

@end
