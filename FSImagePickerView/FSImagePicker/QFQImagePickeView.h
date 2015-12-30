//
//  QFQImagePickeView.h
//  BDApp
//
//  Created by 杨占江 on 15/5/26.
//  Copyright (c) 2015年 xulicheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QFQImageModel.h"
#import "QFQStartVerifyViewController.h"

@class QFQOrderDetailViewController,QFQGatherInfomationViewController;

@interface QFQImagePickeView : UICollectionView

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, weak) QFQGatherInfomationViewController *controller;
@property (nonatomic, weak) QFQStartVerifyViewController *verifyController;
@property (nonatomic, assign) BOOL isQFQVerifyCell;//判断是否是认证界面(只显示一个item)
/**
 *  标记是否有数据
 */
@property (nonatomic, assign, getter=isContent) BOOL content;

@end
