//
//  J2MObject.h
//  J2MObject
//
//  Created by Limboy on 8/4/13.
//  Copyright (c) 2013 Limboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface J2MObject : NSObject <NSCoding, NSCopying>

// original json data
@property (nonatomic, readonly) NSDictionary *jsonData;

- (id)initWithDictionary:(NSDictionary *)JSON;

// set json key -> property map here
- (NSDictionary *)JSONKeysToPropertyKeys;
@end
