Make it easier to convert JSON data to Objective-C Model object
===============================================================

when working with API web service, it is unavoidable to deal with JSON data. there are some libraries for this like Mantle, KZPropertyMapper, why J2MObject?

J2MObject is light weight
-------------------------
it's only 2 files, J2MObject.h/m, just put them into your projects.


J2MObject won't let `NSNull` pass through
-----------------------------------------
`NSNull` will bring problems when sent messages like `boolValue`, `intValue`, etc. just make it nil.


J2MObject implement `NSCopying`, `NSCoding` out of box
------------------------------------------------------
it means you can copy, archive/unarchive model object that inherit from `J2MObject`

J2MObject make debug easier
---------------------------
There is a builtin NSObject category called `autoDescription`. `J2MObject` use it in `description` method, so when you do 
```
NSLog(@"user:%@", user);
```

it will output something like:

```
User {ID = 39; username = limboy, ...}
```

J2MObject automatically set right type for you
----------------------------------------------
suppose the json data is like this:

```
{
	"title": @"The quick brown fox jump over the lazy dog.",
	"itemID": 1984
	"user": {
		@"username": @"Foobar",
		@"age": 24,
	}
}
```

and your model object is defined like this:

```
@interface MyModel : J2MObject
@property (nonatomic, copy) NSString *title,
@property (nonatomic, assign) NSInteger itemID,
@property (nonatomic) MyUser *user,
@end

@interface MyUser : J2MObject
@property (nonatomic, copy) NSString *username,
@property (nonatomic, assign) NSInteger age,
@end
```

the magic

```
MyModel *model = [[MyModel alloc] initWithDictionary(jsonData)];
```

J2MObject support json key -> model property mapping
----------------------------------------------------
in your Model.m, implement `-(NSdictionary *)JSONKeysToPropertyKeys`

```
- (NSDictionary *)JSONKeysToPropertyKeys
{
	// if json keys and property keys are the same, ignore.
    return @{
             @"ga_prefix": @"gaPrefix",
             @"share_image": @"shareImage",
             @"id": @"ID",
             };
}
```

J2MObject support customizing
-----------------------------
`J2MObject` use KVC internal. so if you want to do something special to some key, just implement `-setKey:(keyValue)key`
