//
//  JsonBaseModel.m
//  康吴康
//
//  Created by 龚杰洪 on 14/12/26.
//  Copyright (c) 2014年 龚杰洪. All rights reserved.
//

#import "JsonBaseModel.h"
#import <objc/runtime.h>//

@implementation JsonBaseModel

- (id)initWithDictionary:(NSDictionary *)jsonDic
{
    self = [super init];
    
    if (self != nil)
    {
        [self setValuesForKeysWithDictionary:jsonDic];
        int i;
        unsigned int propertyCount = 0;
        objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
        
        for ( i=0; i < propertyCount; i++ )
        {
            objc_property_t *thisProperty = propertyList + i;
            
            const char* propertyName = property_getName(*thisProperty);
            
            NSString *propertyKeyName = [NSString stringWithUTF8String:propertyName];
            
            if ([[jsonDic valueForKey:propertyKeyName] isKindOfClass:[NSDictionary class]])
            {
                id object = [[[self getItemClassWithPropretyName:propertyKeyName] alloc] initWithDictionary:[jsonDic valueForKey:propertyKeyName]];
                [self setValue:object forKey:propertyKeyName];
            }
            else if ([[jsonDic valueForKey:propertyKeyName] isKindOfClass:[NSArray class]])
            {
                NSMutableArray *arr = [NSMutableArray array];
                for (id object in [jsonDic valueForKey:propertyKeyName])
                {
                    if ([object isKindOfClass:[NSDictionary class]])
                    {
                        [arr addObject:[[[self getItemClassWithPropretyName:propertyKeyName] alloc] initWithDictionary:object]];
                    }
                    else
                    {
                        [arr addObject:object];
                    }
                }
                [self setValue:arr forKey:propertyKeyName];
            }
            else
            {
                
            }
        }
    }
    
    return self;
}

-(Class)getItemClassWithPropretyName:(NSString *)name
{
    return [NSString class];
}

- (id)initWithCacheKey:(NSString *)cacheKey
{
    self = [super init];
    
    if (self != nil)
    {
        [self setValuesForKeysWithDictionary:[[NSUserDefaults standardUserDefaults]
                                              valueForKey:cacheKey]];
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"\n\nUndefined Key : %@\n\n", key);
}

- (NSDictionary *)convertToDictionary
{
    int i;
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
    
    for ( i=0; i < propertyCount; i++ )
    {
        objc_property_t *thisProperty = propertyList + i;
        
        const char* propertyName = property_getName(*thisProperty);
        
        NSString *propertyKeyName = [NSString stringWithUTF8String:propertyName];
        
        if ([[self valueForKey:propertyKeyName] isKindOfClass:[JsonBaseModel class]])
        {
            [returnDic setValue:[[self valueForKey:propertyKeyName] convertToDictionary] forKey:propertyKeyName];
        }
        else if ([[self valueForKey:propertyKeyName] isKindOfClass:[NSArray class]])
        {
            NSMutableArray *arr = [NSMutableArray array];
            for (JsonBaseModel *object in [self valueForKey:propertyKeyName])
            {
                [arr addObject:[object convertToDictionary]];
            }
            [returnDic setValue:arr forKey:propertyKeyName];
        }
        else
        {
            [returnDic setValue:[self valueForKey:propertyKeyName]?
             [self valueForKey:propertyKeyName] : @""
                         forKey:propertyKeyName];
        }
    }
    return returnDic;
}

- (BOOL)cacheWithCacheKey:(NSString *)cacheKey
{
    [[NSUserDefaults standardUserDefaults] setObject:self.convertToDictionary
                                              forKey:cacheKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
