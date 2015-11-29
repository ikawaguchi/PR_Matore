//
//  PRMAppDefaults.m
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/06.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import "PRMAppDefaults.h"
#import "PRMBlogDataManager.h"

NSString *const PRMAppDefaultsBlogOpenUrl = @"PRMAppDefaultsBlogOpenUrl";
NSString *const PRMAppDefaultsBlogOpenTitle = @"PRMAppDefaultsBlogOpenTitle";
NSString *const PRMAppDefaultsFavoriteBlogs = @"PRMAppDefaultsFavoriteBlogs";


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

- (PRMBlogDataManager *)favoriteBlogs{
    return [[self defaults] objectForKey:PRMAppDefaultsFavoriteBlogs];
}

- (void)setFavoriteBlogs:(PRMBlogDataManager *)param{
    [[self defaults] setObject:param forKey:PRMAppDefaultsFavoriteBlogs];
}


@end
