//
//  FSPhotoAssetsModel.h
//  FSImagePickerView
//
//  Created by qufenqi on 1/5/16.
//  Copyright © 2016 王正一. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/ALAsset.h>

@interface FSPhotoAssetsModel : NSObject
@property (nonatomic, strong) ALAsset *asset;

@property (nonatomic, assign) BOOL selected;

+ (instancetype)photoAssetsModelWithDict:(NSDictionary *)dict;
@end
