#import "JsonBaseModel.h"

@interface SkillInfoDataUser_info : JsonBaseModel
@property (strong, nonatomic) NSString *avatar_large;
@property (strong, nonatomic) NSString *avatar_middle;
@property (strong, nonatomic) NSString *vip;
@property (strong, nonatomic) NSString *tags;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *nick;
@property (strong, nonatomic) NSString *weibo_verified;
@property (strong, nonatomic) NSString *person_sign;
@property (strong, nonatomic) NSString *verified_reason;
@property (strong, nonatomic) NSString *avatar_origin;
@property (strong, nonatomic) NSString *level;
@property (strong, nonatomic) NSString *birth_at;
@property (strong, nonatomic) NSString *weibo_verified_type;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *avatar_small;

@end

@interface SkillInfoData : JsonBaseModel
@property (strong, nonatomic) NSString *hot_degree;
@property (strong, nonatomic) NSString *playlist_id;
@property (strong, nonatomic) NSString *cover_large;
@property (strong, nonatomic) NSString *cover_middle;
@property (strong, nonatomic) NSString *brief;
@property (strong, nonatomic) NSString *total_listen;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *total_support;
@property (strong, nonatomic) NSString *cover_small;
@property (strong, nonatomic) SkillInfoDataUser_info *user_info;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *total_collection;
@property (strong, nonatomic) NSString *hits;
@property (strong, nonatomic) NSString *is_default;
@property (strong, nonatomic) NSString *total_comment;

@end

@interface SkillInfo : JsonBaseModel
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *real_num;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSString *resMsg;
@property (strong, nonatomic) NSString *set_num;

@end

