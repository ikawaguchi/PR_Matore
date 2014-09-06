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

- (void)addArticleUrlsObject:(NSString *)object{
    if (object == nil){
        [self.articleUrls addObject:@""];
    }
    else{
        [self.articleUrls addObject:object];
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

- (void)addUpdatesObject:(NSString *)object{
    if (object == nil){
        [self.updates addObject:@""];
    }
    else{
        [self.updates addObject:object];
    }
}


@end
