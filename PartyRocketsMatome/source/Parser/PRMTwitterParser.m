//
//  PRMTwitterParser.m
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/23.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import "PRMTwitterParser.h"
#import "PRMTwitterTimeLineModel.h"

@implementation PRMTwitterParser



+ (NSArray *)parse:(NSArray *)responseObject{
    NSMutableArray *timeLineObjects = [NSMutableArray array];
    
    
    for(NSDictionary *childObject in responseObject){
        PRMTwitterTimeLineModel *model = [PRMTwitterTimeLineModel new];
        [model setMainText:[childObject objectForKey:@"text"]];
        [model setTableHeight:[self tableHeightCalc:model.mainText]];
        [timeLineObjects addObject:model];
    }
    
    return timeLineObjects;
}


+ (CGFloat)tableHeightCalc:(NSString *)mainText{
    CGRect display = [[UIScreen mainScreen] bounds];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, display.size.width, display.size.height)];
    [label setNumberOfLines:20];
    [label setFont:[UIFont fontWithName:@"HiraKakuProN-W3" size:13]];
    [label setText:mainText];
    [label sizeToFit];
    NSLog(@"%@ %lf",label.text,label.frame.size.height);
    return label.frame.size.height + 30;
}


@end
