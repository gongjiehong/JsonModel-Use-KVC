//
//  JsonBaseModel.h
//  康吴康
//
//  Created by 龚杰洪 on 14/12/26.
//  Copyright (c) 2014年 龚杰洪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonBaseModel : NSObject
{
    
}

- (id)initWithDictionary:(NSDictionary *)jsonDic;

- (NSDictionary *)convertToDictionary;

- (id)initWithCacheKey:(NSString *)cacheKey;

- (BOOL)cacheWithCacheKey:(NSString *)cacheKey;

@end
