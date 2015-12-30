//
//  QFQImagePickeView.m
//  BDApp
//
//  Created by 杨占江 on 15/5/26.
//  Copyright (c) 2015年 xulicheng. All rights reserved.
//

#import "QFQImagePickeView.h"
#import "QFQImageCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "QFQOrderDetailViewController.h"
#import "QFQPhotoBrowserViewController.h"
#import "QFQPhotoGroupController.h"
#import "QFQMyDefinition.h"
#import <AVFoundation/AVFoundation.h>
#import "QFQGatherInfomationViewController.h"

@interface QFQImagePickeView ()<UICollectionViewDataSource, UICollectionViewDelegate, QFQImageCellDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, QFQphotoGroupControllerDelegate>

@property (nonatomic, strong) ALAssetsLibrary *library;
//@property (nonatomic, strong) NSArray *kSeletedPhotos;
@end

@implementation QFQImagePickeView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;

        QFQImageModel *model = [[QFQImageModel alloc] init];
        model.url = kAddImage;
        self.data = [NSMutableArray arrayWithObject:model];
        [self registerClass:[QFQImageCell class] forCellWithReuseIdentifier:@"QFQImagePickerCollectionCell"];

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.delegate = self;
        self.dataSource = self;

        QFQImageModel *model = [[QFQImageModel alloc] init];
        model.url = kAddImage;
        self.backgroundColor = [UIColor colorwithString:@"#F5F5F5"];
        self.data = [NSMutableArray arrayWithObject:model];
        [self registerClass:[QFQImageCell class] forCellWithReuseIdentifier:@"QFQImagePickerCollectionCell"];
    }
    return self;
}


#pragma mark - collectionView
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(65, 65);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QFQImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QFQImagePickerCollectionCell" forIndexPath:indexPath];
    QFQImageModel *model = self.data[indexPath.row];

    cell.model = model;
    cell.delegate = self;

    cell.indexPath = indexPath;
    
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    QFQImageModel *model = self.data[indexPath.row];

    
    if ([model.url isEqualToString:kAddImage]) {
        NSLog(@"添加图片");
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中获取", nil];
        [sheet showInView:self];
        
    } else {
        
        __weak QFQImagePickeView *weakSelf = self;
        QFQPhotoBrowserViewController *photoBrowser = [[QFQPhotoBrowserViewController alloc] init];
        photoBrowser.imageArray = self.data;
        photoBrowser.editedCallBack = ^(NSMutableArray *imageArray,BOOL isChanged){
        weakSelf.content = isChanged;
        [weakSelf reloadData];
        };
        if (self.controller) {
            [self.controller.fatherController.navigationController pushViewController:photoBrowser animated:YES];
        }else{
            [self.verifyController.navigationController pushViewController:photoBrowser animated:YES];
        }
        NSLog(@"弹出图片浏览器");
    }
}

#pragma mark - QFQImageCellDelegate
//删除图片
- (void)imageCellDelete:(QFQImageCell *)cell indexPath:(NSIndexPath *)indexPath
{
//    if (tag == self.tag) {
    
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除此图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = indexPath.row;
        [alertView show];
        
//    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.data removeObjectAtIndex:alertView.tag];
        [self reloadData];
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"拍照");
            [self selectFromeCamer];
            break;
        case 1:
            NSLog(@"从相册中获取");
            [self selectFromePhotoLibrary];
            break;
        case 2:
            NSLog(@"取消");
            break;
        default:
            break;
    }
}
#pragma mark - 拍照 & 相册
//拍照
- (void)selectFromeCamer
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您可以在【设置】-【隐私】-【相机】中进行操作，重新授权BDApp访问您的相册" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    } else {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            if (self.controller) {
                [self.controller.fatherController presentViewController:picker animated:YES completion:^{
            }];
            } else {
                [self.verifyController presentViewController:picker animated:YES completion:^{
                }];
            }
        }else
        {
            NSString * errorMess = @"无法打开照相机,请确认相机可用";
            [QFQFactoryClass showMessage:errorMess view:self.controller.view];
        }
    }
    
}

//相册
- (void)selectFromePhotoLibrary
{
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied){
        
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您可以在【设置】-【隐私】-【照片】中进行操作，重新授权BDApp访问您的相册" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    } else {
        QFQPhotoGroupController *photoVc = [[QFQPhotoGroupController alloc] init];
        photoVc.delegate = self;
        photoVc.detailViewController = self.controller;
        photoVc.verifyViewController = self.verifyController;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoVc];
//        nav.view.tag = self.tag;
        if (self.controller) {
            [self.controller.navigationController presentViewController:nav animated:YES completion:^{
            }];
        }else{
            [self.verifyController presentViewController:nav animated:YES completion:^{
            }];
        }
    }
}
#pragma mark -- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        
        //当选择的类型是图片
        if ([type isEqualToString:@"public.image"])
        {
            //先把图片转成NSData
            UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            QFQImageModel *model = [QFQImageModel new];
            model.data = imageData;
            [self.data insertObject:model atIndex:self.data.count-1];
            [self reloadData];
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.data.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            if (self.verifyController) {
                [self.verifyController.storagePhoto addObject:imageData];
            }
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        }
    }];
    
    
    
}

#pragma mark -- QFQphotoGroupControllerDelegate
- (void)photoGroupController:(QFQPhotoGroupController *)vc didSelectedAssetArray:(NSArray *)assets
{
    
    
        self.content = YES;
    
        for (ALAsset *asset in assets) {
            
            UIImage *image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
            NSData *imageData = [[NSData alloc] init];
            if (vc.needUpOriginalImg) {
                imageData = UIImageJPEGRepresentation(image, 1.0);
            } else {
                imageData = UIImageJPEGRepresentation(image, 0.1);
            }
            QFQImageModel *model = [QFQImageModel new];
            model.data = imageData;
            model.assetUrl = [asset valueForProperty:ALAssetPropertyAssetURL];
//            UIImage *verifyImage = [UIImage imageWithData:imageData];
            if (self.controller) {
                [self.controller.storagePhotoUrl addObject:model.assetUrl];
            }
            [self.data insertObject:model atIndex:self.data.count-1];
            [self reloadData];
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.data.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

            //上传图片
            //            [self postServerImage:imageData];
        }
        
        
        
//    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.window endEditing:YES];
}
@end
