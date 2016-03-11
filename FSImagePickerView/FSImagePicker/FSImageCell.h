//
//  FSImageCell.h
//  FSImagePickerView
//
//  Created by qufenqi on 12/30/15.
//  Copyright © 2015 王正一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSImageModel.h"

#define kAddImage @"addImage"

@class FSImageCell;
@protocol FSImageCellDelegate <NSObject>

- (void)imageCellDelete:(FSImageCell *)cell indexPath:(NSIndexPath *)indexPath;

@end
@interface FSImageCell : UICollectionViewCell
@property (nonatomic, strong) FSImageModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id <FSImageCellDelegate> delegate;
@end
