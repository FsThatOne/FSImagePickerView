//
//  FSImagePickerView.h
//  FSImagePickerView
//
//  Created by qufenqi on 12/30/15.
//  Copyright © 2015 王正一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSImageModel.h"

@interface FSImagePickerView : UICollectionView
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, weak) UIViewController *controller;
/**
 *  标记是否有数据
 */
@property (nonatomic, assign, getter=isContent) BOOL content;
@end
