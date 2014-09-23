//
//  PRMCommon.m
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/16.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import "PRMCommon.h"

@implementation PRMCommon


+ (NSString *)logEncoded:(NSArray *)arr locale:(id)locale indent:(NSUInteger)indent{
    NSMutableString *mStr = [NSMutableString string];
    // indent level に応じてスペースを挿入
    for (int i = 0; i < indent; i++) {
        [mStr appendString:@"    "];
    }
    [mStr appendString:@"(\n"];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        if ([obj isKindOfClass:[NSArray class]]) {
            // さらに入れ子の場合は、indent level + 1 でインデントを考慮
            [mStr appendFormat:@"%@,\n", [obj descriptionWithLocale:locale indent:indent + 1]];
        } else {
            // indent level に応じてスペースを挿入
            for (int i = 0; i < indent; i++) {
                [mStr appendString:@"    "];
            }
            [mStr appendFormat:@"%@", [obj description]];
            // 配列の末尾の要素かでコンマを入れるかを判断
            if (idx == [arr count] - 1) {
                [mStr appendString:@"\n"];
            } else {
                [mStr appendString:@",\n"];
            }
        }
    }];
    // indent level - 1 のスペースを挿入
    for (int i = 0; i < indent - 1; i++) {
        [mStr appendString:@"    "];
    }
    [mStr appendString:@")"];
    return mStr;
};


@end
