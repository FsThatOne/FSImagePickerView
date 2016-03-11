//
//  FSImageModel.m
//  FSImagePickerView
//
//  Created by qufenqi on 12/30/15.
//  Copyright © 2015 王正一. All rights reserved.
//

#import "FSImageModel.h"
#import <objc/runtime.h>

@implementation FSImageModel
// 归档
- (void)encodeWithCoder:(NSCoder*)encoder
{
    unsigned int count;
    Ivar* ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char* name = ivar_getName(ivar);
        NSString* strName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:strName];
        [encoder encodeObject:value forKey:strName];
    }
    free(ivars);
}

// 解档
- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init]) {
        unsigned int count;
        Ivar* ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            const char* name = ivar_getName(ivar);
            NSString* strName = [NSString stringWithUTF8String:name];
            id value = [decoder decodeObjectForKey:strName];
            [self setValue:value forKey:strName];
        }
        free(ivars);
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"url --> %@\ndata --> %lu",self.url,(unsigned long)self.data.length];
}

@end
