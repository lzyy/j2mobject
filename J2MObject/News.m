//
//  News.m
//  J2MObject
//
//  Created by Limboy on 8/4/13.
//  Copyright (c) 2013 Limboy. All rights reserved.
//

#import "News.h"

@implementation News
- (NSDictionary *)JSONKeysToPropertyKeys
{
    return @{
             @"ga_prefix": @"gaPrefix",
             @"share_image": @"shareImage",
             @"id": @"ID",
             };
}

// manually set items here
- (void)setItems:(NSArray *)items
{
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *item in items) {
        NewsItem *newsItem = [[NewsItem alloc] initWithDictionary:item];
        [itemsArray addObject:newsItem];
    }
    _items = itemsArray;
}
@end
