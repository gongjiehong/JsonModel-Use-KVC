#import "SkillInfo.h"

@implementation SkillInfoDataUser_info

@end

@implementation SkillInfoData

-(Class)getItemClassWithPropretyName:(NSString *)name
{
    if ([name isEqualToString:@"user_info"])
    {
        return [SkillInfoDataUser_info class];
    }
    return [NSString class];
}

@end

@implementation SkillInfo

-(Class)getItemClassWithPropretyName:(NSString *)name
{
    if ([name isEqualToString:@"data"])
    {
        return [SkillInfoData class];
    }
    return [NSString class];
}

@end

