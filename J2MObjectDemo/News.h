//
//  News.h
//  J2MObject
//
//  Created by Limboy on 8/4/13.
//  Copyright (c) 2013 Limboy. All rights reserved.
//

#import "J2MObject.h"
#import "NewsItem.h"

@interface News : J2MObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSArray *items;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *gaPrefix;
@property (nonatomic, copy) NSString *shareImage;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) BOOL special;
@end
