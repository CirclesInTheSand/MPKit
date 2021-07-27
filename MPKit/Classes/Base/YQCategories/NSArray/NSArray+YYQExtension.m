//
//  NSArray+YYQExtension.m
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import "NSArray+YYQExtension.h"

@implementation NSArray (YYQExtension)

+ (NSArray *)arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([array isKindOfClass:[NSArray class]]) return array;
    return nil;
}

- (id)randomObject{
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    
    return nil;
}

-(id)objectOrNilAtIndex:(NSUInteger)index{
    
    return index<self.count? self[index] :nil;
}

- (NSDictionary *)sortedByPropertyName:(NSString *)propertyName{
    NSMutableDictionary *dictionarySource = [NSMutableDictionary dictionary];
    NSArray *nameArray = [self valueForKeyPath:propertyName];
    [nameArray enumerateObjectsUsingBlock:^(NSString *nameString, NSUInteger idx, BOOL * _Nonnull stop) {
        
        /**< 取propertyName对应的城市模型 */
        id cityModel = [self objectAtIndex:idx];
        
        /**< 模型里的拼音字符串 */
        NSString *pingYinString = [cityModel valueForKey:@"pingYing"];
        NSString *firstCaptalizedLetter = [[pingYinString substringToIndex:1] capitalizedString];
        /**< 取是该首字母的{字母:城市模型数组}字典 对应的城市模型数组*/
        NSMutableArray *modelArray = [dictionarySource objectForKey:firstCaptalizedLetter];
        
        /**< 如果取到了城市模型数组,则添加进去即可 */
        if(modelArray.count){
            [modelArray addObject:cityModel];
        }else{
            /**< 如果没有取到,则新建一个添加进去 */
            modelArray = [NSMutableArray arrayWithObject:cityModel];
            [dictionarySource setObject:modelArray forKey:firstCaptalizedLetter];
        }
    }];
    return dictionarySource;
}

@end

@implementation NSMutableArray (YYQExtension)

+ (NSMutableArray *)arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) return array;
    return nil;
}

- (void)removeFirstObject{

    [self removeObjectAtIndex:0];
}

@end
