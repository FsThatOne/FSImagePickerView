//
//  FSPhotoAssetsController.h
//  FSImagePickerView
//
//  Created by qufenqi on 1/5/16.
//  Copyright © 2016 王正一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPhotoGroupController.h"

@interface FSPhotoAssetsController : UIViewController
@property (nonatomic, strong) NSArray *data;

@property (nonatomic, weak) FSPhotoGroupController *groupVc;
@end
