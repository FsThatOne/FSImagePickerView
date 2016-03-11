//
//  FSPhotoAssetsCell.h
//  FSImagePickerView
//
//  Created by qufenqi on 1/5/16.
//  Copyright © 2016 王正一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAsset.h>
#import "FSPhotoAssetsModel.h"
@interface FSPhotoAssetsCell : UICollectionViewCell
@property (nonatomic, strong) ALAsset *asset;

@property (nonatomic, strong) FSPhotoAssetsModel *model;

@property (nonatomic, weak) UIImageView *indicator;
@end
