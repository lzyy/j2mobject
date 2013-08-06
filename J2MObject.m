//
//  J2MObject.m
//  J2MObject
//
//  Created by Limboy on 8/4/13.
//  Copyright (c) 2013 Limboy. All rights reserved.
//

#import "J2MObject.h"
#import <objc/runtime.h>

#pragma mark - NSObject (AutoDescription)
@interface NSObject (AutoDescription)
- (NSString *) autoDescription;
@end

@implementation NSObject (AutoDescription)

- (NSString *) autoDescriptionForClassType:(Class)classType {
    
	NSMutableString * result = [NSMutableString string];
    
	// Find Out something about super Classes
	Class superClass  = class_getSuperclass(classType);
	if  ( superClass != nil && ![superClass isEqual:[NSObject class]])
	{
		// Append all the super class's properties to the result (Reqursive, until NSObject)
		[result appendString:[self autoDescriptionForClassType:superClass]];
	}
    
	// Add Information about Current Properties
	NSUInteger		  property_count;
	objc_property_t * property_list = class_copyPropertyList(classType, &property_count); // Must Free, later
    
	for (int i = property_count - 1; i >= 0; --i) { // Reverse order, to get Properties in order they were defined
		objc_property_t property = property_list[i];
        
		// For Eeach property we are loading its name
		const char * property_name = property_getName(property);
        
		NSString * propertyName = [NSString stringWithCString:property_name encoding:NSASCIIStringEncoding];
        
        // don't output jsonData
        if ([propertyName isEqualToString:@"jsonData"]) {
            continue;
        }
        
		if (propertyName) { // and if name is ok, we are getting value using KVC
			id value = [self valueForKey:propertyName];
            
			// format of result items: p1 = v1; p2 = v2; ...
			[result appendFormat:@"%@ = %@; ", propertyName, value];
		}
	}
	free(property_list);//Clean up
    
	return result;
}

- (NSString *)autoDescription
{
	return [NSString stringWithFormat:@"[%@ {%@}]", NSStringFromClass([self class]), [self autoDescriptionForClassType:[self class]]];
}

@end


#pragma mark - J2MObject
@interface J2MObject ()
@property (nonatomic, readwrite) NSDictionary *jsonData;
@end

@implementation J2MObject
- (id)initWithDictionary:(NSDictionary *)JSON
{
    NSDictionary *JSONKeysToPropertyKeys = [self JSONKeysToPropertyKeys];
    self.jsonData = JSON;
    
    for (NSString *jsonKey in JSON) {
        NSString *propertyKey = JSONKeysToPropertyKeys[jsonKey] ? JSONKeysToPropertyKeys[jsonKey] : jsonKey;
        
        if ([self respondsToSelector:NSSelectorFromString(propertyKey)]) {
            NSString *className = [self getPropertyTypeString:propertyKey];
            
            // not primitive types
            if (className) {
                Class class = NSClassFromString(className);
                if ([class isSubclassOfClass:[J2MObject class]]) {
                    // if JSON[jsonKey] is NSNull class, ignore it. so it becomes nil.
                    if (![JSON[jsonKey] isKindOfClass:[NSNull class]]) {
                        // if the property is J2MObject's subclass
                        // init it with the right class
                        J2MObject *value = [[class alloc] initWithDictionary:JSON[jsonKey]];
                        [self setValue:value forKey:propertyKey];
                    }
                } else {
                    // maybe it's an NSMutableArray or something else
                    [self setValue:JSON[jsonKey] forKey:propertyKey];
                }
            } else {
                // just set value directly
                if (![JSON[jsonKey] isKindOfClass:[NSNull class]]) {
                    [self setValue:JSON[jsonKey] forKey:propertyKey];
                }
            }
        }
    }
    
    return self;
}


- (NSString *)getPropertyTypeString:(NSString *)propertyName
{
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    // propertyAttributes looks like: T@"NSArray",&,Vstuff
    const char * propertyAttributes = property_getAttributes(property);
    // suck out the type within attributes
    NSArray *sections = [[NSString stringWithUTF8String:propertyAttributes] componentsSeparatedByString:@"\""];
    
    NSString *type;
    // something like T@"ViewController",&,N,V_viewController
    if (sections.count == 3) {
        type = sections[1];
    }
    // if it is primitive value, it's like Ti,N,V_number
    return type;
}

- (NSDictionary *)JSONKeysToPropertyKeys
{
    return @{};
}

- (NSString *)description
{
    return [self autoDescription];
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        char *propertyType = property_copyAttributeValue(property, "T");
        NSString *propertyName = [NSString stringWithFormat:@"%s", property_getName(property)];
		free (propertyType);
		char *iVar = property_copyAttributeValue(property, "V");
		NSString *iVarName = [NSString stringWithFormat:@"%s", iVar];
		free(iVar);

        
        switch (propertyType[0]) {
            case 'i': // int
            case 's': // short
            case 'l': // long
            case 'q': // long long
            case 'I': // unsigned int
            case 'S': // unsigned short
            case 'L': // unsigned long
            case 'Q': // unsigned long long
            case 'f': // float
            case 'd': // double
            case 'B': // BOOL
                [aCoder encodeInteger:[[self valueForKey:iVarName] intValue] forKey:propertyName];
                break;
            default:
                [aCoder encodeObject:[self valueForKey:iVarName] forKey:propertyName];
        }
        free(propertyType);
    }
    free(properties);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
        
        for (int i = 0; i < propertyCount; i++) {
            objc_property_t property = properties[i];
            char *propertyType = property_copyAttributeValue(property, "T");
            NSString *propertyName = [NSString stringWithFormat:@"%s", property_getName(property)];
			free(propertyType);
			char *iVar = property_copyAttributeValue(property, "V");
            NSString *iVarName = [NSString stringWithFormat:@"%s", iVar];
			free(iVar);
            
            switch (propertyType[0]) {
                case 'i': // int
                case 's': // short
                case 'l': // long
                case 'q': // long long
                case 'I': // unsigned int
                case 'S': // unsigned short
                case 'L': // unsigned long
                case 'Q': // unsigned long long
                case 'f': // float
                case 'd': // double
                case 'B': // BOOL
                    [self setValue:[NSNumber numberWithInteger:[aDecoder decodeIntegerForKey:propertyName]] forKey:iVarName];
                    break;
                default:
                    [self setValue:[aDecoder decodeObjectForKey:propertyName] forKey:iVarName];
            }
            free(propertyType);
        }
        free(properties);
    }
    return self;
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    id object = [[[self class] allocWithZone:zone] init];
    
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        NSString *iVarName = [NSString stringWithFormat:@"%s", property_copyAttributeValue(property, "V")];
        
        [object setValue:[self valueForKey:iVarName] forKey:iVarName];
    }
    free(properties);
    return object;
}

@end
