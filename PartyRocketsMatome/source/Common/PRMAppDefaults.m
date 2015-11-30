//
//  PRMAppDefaults.m
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/06.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import "PRMAppDefaults.h"

NSString *const PRMAppDefaultsBlogOpenUrl               = @"PRMAppDefaultsBlogOpenUrl";
NSString *const PRMAppDefaultsBlogOpenTitle             = @"PRMAppDefaultsBlogOpenTitle";
NSString *const PRMAppDefaultsFavoriteBlogTitles        = @"PRMAppDefaultsFavoriteBlogTitles";
NSString *const PRMAppDefaultsFavoriteBlogArticleUrls   = @"PRMAppDefaultsFavoriteBlogArticleUrls";
NSString *const PRMAppDefaultsFavoriteBlogThemes        = @"PRMAppDefaultsFavoriteBlogThemes";
NSString *const PRMAppDefaultsFavoriteBlogUpdates       = @"PRMAppDefaultsFavoriteBlogUpdates";


@implementation PRMAppDefaults

#pragma mark -init

static PRMAppDefaults *currentDefaults = nil;


// TODO:本クラスオブジェクトをシングルトンで呼び出す
+ (PRMAppDefaults*)currentDefaults
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentDefaults = [PRMAppDefaults new];
    });
    return currentDefaults;
}


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


// TODO:このメソッドを呼び出すとsetした内容が即時反映される
- (void)synchronize
{
    [[self defaults] synchronize];
}


#pragma mark - Private

- (NSUserDefaults*)defaults
{
    return [NSUserDefaults standardUserDefaults];
}



#pragma mark - Blog

- (NSString *)blogOpenUrl{
    return [[self defaults] objectForKey:PRMAppDefaultsBlogOpenUrl];
}

- (void)setBlogOpenUrl:(NSString *)param{
    [[self defaults] setObject:param forKey:PRMAppDefaultsBlogOpenUrl];
}

- (NSString *)blogOpenTitle{
    return [[self defaults] objectForKey:PRMAppDefaultsBlogOpenTitle];
}

- (void)setBlogOpenTitle:(NSString *)param{
    [[self defaults] setObject:param forKey:PRMAppDefaultsBlogOpenTitle];
}


#pragma mark - FavoriteBlog

- (NSMutableArray *)favoriteBlogTitles{
    NSMutableArray* array = [[[self defaults] arrayForKey:PRMAppDefaultsFavoriteBlogTitles] mutableCopy];
    if (array == nil) {
        array = [NSMutableArray array];
    }
    return array;
}

- (void)setFavoriteBlogTitles:(NSMutableArray *)param{
    [[self defaults] setObject:param forKey:PRMAppDefaultsFavoriteBlogTitles];
}

- (NSMutableArray *)favoriteBlogArticleUrls{
    NSMutableArray* array = [[[self defaults] arrayForKey:PRMAppDefaultsFavoriteBlogArticleUrls] mutableCopy];
    if (array == nil) {
        array = [NSMutableArray array];
    }
    return array;
}

- (void)setFavoriteBlogArticleUrls:(NSMutableArray *)param{
    [[self defaults] setObject:param forKey:PRMAppDefaultsFavoriteBlogArticleUrls];
}

- (NSMutableArray *)favoriteBlogThemes{
    NSMutableArray* array = [[[self defaults] arrayForKey:PRMAppDefaultsFavoriteBlogThemes] mutableCopy];
    if (array == nil) {
        array = [NSMutableArray array];
    }
    return array;
}

- (void)setFavoriteBlogThemes:(NSMutableArray *)param{
    [[self defaults] setObject:param forKey:PRMAppDefaultsFavoriteBlogThemes];
}

- (NSMutableArray *)favoriteBlogUpdates{
    NSMutableArray* array = [[[self defaults] arrayForKey:PRMAppDefaultsFavoriteBlogUpdates] mutableCopy];
    if (array == nil) {
        array = [NSMutableArray array];
    }
    return array;
}

- (void)setFavoriteBlogUpdates:(NSMutableArray *)param{
    [[self defaults] setObject:param forKey:PRMAppDefaultsFavoriteBlogUpdates];
}




@end
