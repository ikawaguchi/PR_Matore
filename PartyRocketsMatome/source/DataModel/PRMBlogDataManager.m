//
//  PRTBlogDataManager.m
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/06.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import "PRMBlogDataManager.h"


@interface PRMBlogDataManager()

@end

@implementation PRMBlogDataManager

- (id)init{
    self = [super init];
    if(self){
        self.titles = [NSMutableArray array];
        self.articleUrls = [NSMutableArray array];
        self.themes = [NSMutableArray array];
        self.updates = [NSMutableArray array];
        self.isFavorite = [NSMutableArray array];
    }
    
    return self;
}

- (NSInteger)count{
    return [self.titles count];
}


- (void)addTitlesObject:(NSString *)object{
    if (object == nil){
        [self.titles addObject:@""];
    }
    else{
        [self.titles addObject:object];
    }
}

- (void)insertTitlesObject:(NSString *)object{
    if (object == nil){
        [self.titles insertObject:@"" atIndex:0];
    }
    else{
        [self.titles insertObject:object atIndex:0];
    }
}

- (void)addArticleUrlsObject:(NSString *)object{
    if (object == nil){
        [self.articleUrls addObject:@""];
    }
    else{
        [self.articleUrls addObject:object];
    }
}
- (void)addIsFavorite:(Boolean)object{
    [self.isFavorite addObject:@(object)];
}



- (void)insertArticleUrlsObject:(NSString *)object{
    if (object == nil){
        [self.articleUrls insertObject:@"" atIndex:0];
    }
    else{
        [self.articleUrls insertObject:object atIndex:0];
    }
}


- (void)addThemesObject:(NSString *)object{
    if (object == nil){
        [self.themes addObject:@""];
    }
    else{
        [self.themes addObject:object];
    }
}

- (void)insertThemesObject:(NSString *)object{
    if (object == nil){
        [self.themes insertObject:@"" atIndex:0];
    }
    else{
        [self.themes insertObject:object atIndex:0];
    }
}


- (void)addUpdatesObject:(NSString *)object{
    if (object == nil){
        [self.updates addObject:@""];
    }
    else{
        [self.updates addObject:object];
    }
}

- (void)insertUpdatesObject:(NSString *)object{
    if (object == nil){
        [self.updates insertObject:@"" atIndex:0];
    }
    else{
        [self.updates insertObject:object atIndex:0];
    }
}

- (void)insertIsFavorite:(Boolean)object{
    [self.isFavorite insertObject:@(object) atIndex:0];
}

- (void)updateIsFavorite:(Boolean)object index:(NSInteger)index{
    self.isFavorite[index] = @(object);
}

- (void)deleteTitlesObject:(NSInteger)index
{
    if ([self.titles count] > index) {
        [self.titles removeObjectAtIndex:index];
    }
    else {
        NSLog(@"deleteTitlesObject Index OverFlow");
    }
}

- (void)deleteArticleUrlsObject:(NSInteger)index
{
    if ([self.titles count] > index) {
        [self.titles removeObjectAtIndex:index];
    }
    else {
        NSLog(@"deleteTitlesObject Index OverFlow");
    }
}

- (void)deleteThemesObject:(NSInteger)index
{
    if ([self.themes count] > index) {
        [self.themes removeObjectAtIndex:index];
    }
    else {
        NSLog(@"deleteThemesObject Index OverFlow");
    }
}

- (void)deleteUpdatesObject:(NSInteger)index
{
    if ([self.updates count] > index) {
        [self.updates removeObjectAtIndex:index];
    }
    else {
        NSLog(@"deleteUpdatesObject Index OverFlow");
    }
}

- (void)deleteIsFavoriteObject:(NSInteger)index
{
    if ([self.isFavorite count] > index) {
        [self.isFavorite removeObjectAtIndex:index];
    }
    else {
        NSLog(@"deleteIsFavoriteObject Index OverFlow");
    }
}


@end
