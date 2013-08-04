//
//  NewsItem.h
//  J2MObject
//
//  Created by Limboy on 8/4/13.
//  Copyright (c) 2013 Limboy. All rights reserved.
//

#import "J2MObject.h"

@interface NewsItem : J2MObject
@property (nonatomic, copy) NSString *imageSource;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *shareURL;
@property (nonatomic, copy) NSString *shareImage;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger ID;
@end
