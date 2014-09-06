//
//  PRTBlogDataManager.h
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/06.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRMBlogDataManager : NSObject

@property (readonly, nonatomic) NSMutableArray *titles;
@property (readonly, nonatomic) NSMutableArray *articleUrls;
@property (readonly, nonatomic) NSMutableArray *themes;
@property (readonly, nonatomic) NSMutableArray *updates;



- (void)addTitlesObject:(NSString *)object;
- (void)addArticleUrlsObject:(NSString *)object;
- (void)addThemesObject:(NSString *)object;
- (void)addUpdatesObject:(NSString *)object;

- (NSInteger)count;

@end
