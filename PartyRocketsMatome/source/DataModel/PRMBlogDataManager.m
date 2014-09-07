//
//  PRTBlogDataManager.m
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/06.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import "PRMBlogDataManager.h"


@interface PRMBlogDataManager()

@property (readwrite, nonatomic) NSMutableArray *titles;
@property (readwrite, nonatomic) NSMutableArray *articleUrls;
@property (readwrite, nonatomic) NSMutableArray *themes;
@property (readwrite, nonatomic) NSMutableArray *updates;

@end

@implementation PRMBlogDataManager

- (id)init{
    self = [super init];
    if(self){
        self.titles = [NSMutableArray array];
        self.articleUrls = [NSMutableArray array];
        self.themes = [NSMutableArray array];
        self.updates = [NSMutableArray array];
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


@end
