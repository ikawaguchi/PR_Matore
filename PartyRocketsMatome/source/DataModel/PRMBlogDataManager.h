//
//  PRTBlogDataManager.h
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/06.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRMBlogDataManager : NSObject

@property (nonatomic) NSMutableArray *titles;
@property (nonatomic) NSMutableArray *articleUrls;
@property (nonatomic) NSMutableArray *themes;
@property (nonatomic) NSMutableArray *updates;
@property (nonatomic) NSMutableArray *isFavorite;


- (void)addTitlesObject:(NSString *)object;
- (void)addArticleUrlsObject:(NSString *)object;
- (void)addThemesObject:(NSString *)object;
- (void)addUpdatesObject:(NSString *)object;
- (void)addIsFavorite:(Boolean)object;


- (void)insertTitlesObject:(NSString *)object;
- (void)insertArticleUrlsObject:(NSString *)object;
- (void)insertThemesObject:(NSString *)object;
- (void)insertUpdatesObject:(NSString *)object;
- (void)insertIsFavorite:(Boolean)object;

- (void)deleteTitlesObject:(NSInteger)index;
- (void)deleteArticleUrlsObject:(NSInteger)index;
- (void)deleteThemesObject:(NSInteger)index;
- (void)deleteUpdatesObject:(NSInteger)index;
- (void)deleteIsFavoriteObject:(NSInteger)index;


- (void)updateIsFavorite:(Boolean)object index:(NSInteger)index;

- (NSInteger)count;

@end
