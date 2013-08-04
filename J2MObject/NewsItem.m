//
//  NewsItem.m
//  J2MObject
//
//  Created by Limboy on 8/4/13.
//  Copyright (c) 2013 Limboy. All rights reserved.
//

#import "NewsItem.h"

@implementation NewsItem

- (NSDictionary *)JSONKeysToPropertyKeys
{
    return @{
             @"image_source": @"imageSource",
             @"share_url": @"shareURL",
             @"share_image": @"shareImage",
             @"id": @"ID",
             };
}
@end
