//
//  FSImageModel.h
//  FSImagePickerView
//
//  Created by qufenqi on 12/30/15.
//  Copyright © 2015 王正一. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSImageModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) NSData *data;

/**
 *  相册图片的本地地址
 */
@property (nonatomic, strong) NSURL *assetUrl;
@end
