//
//  NSString+com.m
//  CreatClassFromJson
//
//  Created by 龚杰洪 on 15/2/5.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "NSString+com.h"

@implementation NSString (com)

- (NSString *)onlyCapitalizedFistString
{
    if (self.length > 0)
    {
        NSString *first = [self substringToIndex:1];
        first = [first uppercaseString];
        return [self stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:first];
    }
    return self;
}
@end
