//
//  PRMAppDefaults.h
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/06.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRMBlogDataManager.h"


@interface PRMAppDefaults : NSObject

+ (PRMAppDefaults *)currentDefaults;
- (void)synchronize;

- (NSString *)blogOpenUrl;
- (void)setBlogOpenUrl:(NSString *)param;

- (NSString *)blogOpenTitle;
- (void)setBlogOpenTitle:(NSString *)param;

- (NSMutableArray *)favoriteBlogTitles;
- (void)setFavoriteBlogTitles:(NSMutableArray *)param;
- (NSMutableArray *)favoriteBlogArticleUrls;
- (void)setFavoriteBlogArticleUrls:(NSMutableArray *)param;
- (NSMutableArray *)favoriteBlogThemes;
- (void)setFavoriteBlogThemes:(NSMutableArray *)param;
- (NSMutableArray *)favoriteBlogUpdates;
- (void)setFavoriteBlogUpdates:(NSMutableArray *)param;


@end
