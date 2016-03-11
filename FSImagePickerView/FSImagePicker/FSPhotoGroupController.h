//
//  FSPhotoGroupController.h
//  FSImagePickerView
//
//  Created by qufenqi on 1/5/16.
//  Copyright © 2016 王正一. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  相册照片选择完成的协议
 */
@class FSPhotoGroupController;
@protocol FSphotoGroupControllerDelegate <NSObject>

- (void)photoGroupController:(FSPhotoGroupController *)vc didSelectedAssetArray:(NSArray *)assets;

@end
@interface FSPhotoGroupController : UIViewController
@property (nonatomic, weak) id <FSphotoGroupControllerDelegate> delegate;
@end
