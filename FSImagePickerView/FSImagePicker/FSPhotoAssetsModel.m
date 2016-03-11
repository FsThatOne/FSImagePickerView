//
//  FSPhotoAssetsModel.m
//  FSImagePickerView
//
//  Created by qufenqi on 1/5/16.
//  Copyright © 2016 王正一. All rights reserved.
//

#import "FSPhotoAssetsModel.h"

@implementation FSPhotoAssetsModel
+ (instancetype)photoAssetsModelWithDict:(NSDictionary *)dict
{
    FSPhotoAssetsModel *model = [[self alloc] init];
    model.selected = [dict[@"selected"] boolValue];
    model.asset = dict[@"asset"];
    return model;
}
@end
