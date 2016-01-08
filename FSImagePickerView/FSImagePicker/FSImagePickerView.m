//
//  FSImagePickerView.m
//  FSImagePickerView
//
//  Created by qufenqi on 12/30/15.
//  Copyright © 2015 王正一. All rights reserved.
//

#import "FSImagePickerView.h"
#import "FSImageCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FSPhotoBrowserViewController.h"
#import "FSPhotoGroupController.h"
#import <AVFoundation/AVFoundation.h>

@interface FSImagePickerView ()<UICollectionViewDataSource, UICollectionViewDelegate, FSImageCellDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FSphotoGroupControllerDelegate>
@property (nonatomic, strong) ALAssetsLibrary *library;
@end

@implementation FSImagePickerView

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
        self.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
        FSImageModel *model = [[FSImageModel alloc] init];
        model.url = kAddImage;
        self.backgroundColor = [UIColor colorWithWhite:245.0/255.0 alpha:1];
        self.data = [NSMutableArray arrayWithObject:model];
        [self registerClass:[FSImageCell class] forCellWithReuseIdentifier:@"FSImagePickerCollectionCell"];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.delegate = self;
        self.dataSource = self;
        
        FSImageModel *model = [[FSImageModel alloc] init];
        model.url = kAddImage;
        self.backgroundColor = [UIColor colorWithWhite:245.0/255.0 alpha:1];
        self.data = [NSMutableArray arrayWithObject:model];
        [self registerClass:[FSImageCell class] forCellWithReuseIdentifier:@"FSImagePickerCollectionCell"];
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
    FSImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FSImagePickerCollectionCell" forIndexPath:indexPath];
    FSImageModel *model = self.data[indexPath.row];
    
    cell.model = model;
    cell.delegate = self;
    
    cell.indexPath = indexPath;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSImageModel *model = self.data[indexPath.row];
    
    
    if ([model.url isEqualToString:kAddImage]) {
        NSLog(@"添加图片");
        
//        UIAlertController *sheetV = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        [sheetV addAction:[UIAlertAction actionWithTitle:@"哈哈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        }]];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中获取", nil];
        [sheet showInView:self];
        
    } else {
        FSPhotoBrowserViewController *photoBrowser = [[FSPhotoBrowserViewController alloc] init];
        photoBrowser.imageArray = self.data;
        photoBrowser.editedCallBack = ^(NSMutableArray *imageArray,BOOL isChanged){
        self.content = isChanged;
        [self reloadData];
        };
        if (self.controller) {
            [self.controller presentViewController:photoBrowser animated:YES completion:^{
            }];
        }
        NSLog(@"弹出图片浏览器");
    }
}

#pragma mark - FSImageCellDelegate
//删除图片
- (void)imageCellDelete:(FSImageCell *)cell indexPath:(NSIndexPath *)indexPath
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除此图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = indexPath.row;
    [alertView show];
    
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
            [self selectFromCamera];
            break;
        case 1:
            NSLog(@"从相册中获取");
            [self selectFromPhotoLibrary];
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
- (void)selectFromCamera
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您可以在【设置】-【隐私】-【相机】中进行操作，重新授权App访问您的相册" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
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
                [self.controller presentViewController:picker animated:YES completion:^{
                }];
            }
        }else
        {
//            NSString * errorMess = @"无法打开照相机,请确认相机可用";
//            [FSFactoryClass showMessage:errorMess view:self.controller.view];
        }
    }
    
}

//相册
- (void)selectFromPhotoLibrary{
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您可以在【设置】-【隐私】-【照片】中进行操作，重新授权App访问您的相册" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    } else {
        FSPhotoGroupController *photoVc = [[FSPhotoGroupController alloc] init];
        photoVc.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoVc];
        if (self.controller) {
            [self.controller presentViewController:nav animated:YES completion:^{
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
            
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            FSImageModel *model = [FSImageModel new];
            model.data = imageData;
            [self.data insertObject:model atIndex:self.data.count-1];
            [self reloadData];
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.data.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        }
    }];
    
    
    
}

#pragma mark -- FSphotoGroupControllerDelegate
- (void)photoGroupController:(FSPhotoGroupController *)vc didSelectedAssetArray:(NSArray *)assets
{
    
    
    self.content = YES;
    
    for (ALAsset *asset in assets) {
        
        UIImage *image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
        NSData *imageData = [[NSData alloc] init];
        imageData = UIImageJPEGRepresentation(image, 1);
        FSImageModel *model = [FSImageModel new];
        model.data = imageData;
        model.assetUrl = [asset valueForProperty:ALAssetPropertyAssetURL];
        [self.data insertObject:model atIndex:self.data.count-1];
        [self reloadData];
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.data.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

    }
    
    
    
    //    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.window endEditing:YES];
}

@end
