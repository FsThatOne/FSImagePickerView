//
//  FSPhotoBrowserViewController.h
//  FSImagePickerView
//
//  Created by qufenqi on 1/5/16.
//  Copyright © 2016 王正一. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^editedPhoto)(NSMutableArray *imageArray,BOOL isChanged);
@interface FSPhotoBrowserViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) editedPhoto editedCallBack;
@end
