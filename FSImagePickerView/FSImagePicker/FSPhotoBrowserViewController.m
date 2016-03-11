//
//  FSPhotoBrowserViewController.m
//  FSImagePickerView
//
//  Created by qufenqi on 1/5/16.
//  Copyright © 2016 王正一. All rights reserved.
//

#import "FSPhotoBrowserViewController.h"
#import "FSImageModel.h"

#define collectionID @"photeBrowser"
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface FSPhotoBrowserViewController()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSInteger _currentPage;
    UIImageView *_currentImageView;
    BOOL _isChanged;
}
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) UIView *bottomView;
@end
@implementation FSPhotoBrowserViewController
- (UIView *)bottomView
{
    if (!_bottomView) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 61, [UIScreen mainScreen].bounds.size.width, 61)];
        bottomView.backgroundColor = [UIColor lightGrayColor];
        
        UIImage *deleteImage = [UIImage imageNamed:@"photoBrowser_delete"];
        UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(40, 12, 27, 37)];
        [delete addTarget:self action:@selector(p_deleteImage) forControlEvents:UIControlEventTouchUpInside];
        [delete setImage:deleteImage forState:UIControlStateNormal];
        [bottomView addSubview:delete];
        
        UIImage *rotateImage = [UIImage imageNamed:@"photoBrowser_roate"];
        UIButton *rotate = [[UIButton alloc] initWithFrame:CGRectMake(110 , 10, 45, 40)];
        [rotate addTarget:self action:@selector(p_rotateImage) forControlEvents:UIControlEventTouchUpInside];
        [rotate setImage:rotateImage forState:UIControlStateNormal];
        [bottomView addSubview:rotate];
        
        UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 15 - 100, 13, 100, 35)];
        [save setTitle:@"保存" forState:UIControlStateNormal];
        save.backgroundColor = [UIColor blueColor];
        [save addTarget:self action:@selector(p_saveImage) forControlEvents:UIControlEventTouchUpInside];
        save.titleLabel.font = [UIFont systemFontOfSize:16];
        [bottomView addSubview:save];
        
        _bottomView = bottomView;
    }
    return _bottomView;
}

- (UICollectionView *)myCollectionView
{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
        collectionView.pagingEnabled = YES;
        collectionView.bounces = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionID];
        
        _myCollectionView = collectionView;
    }
    return _myCollectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_setUpUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self p_sutUpNav];
}

#pragma mark UI
- (void)p_setUpUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myCollectionView];
    [self.view addSubview:self.bottomView];
    _isChanged = NO;
}

- (void)p_sutUpNav
{
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 17, 25)];
    [left setImage:[UIImage imageNamed:@"public_back_white"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(p_pop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:left];
    self.title = [NSString stringWithFormat:@"%td/%td",_currentPage + 1,self.imageArray.count - 1];
}

#pragma mark myCollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count - 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    UIImageView *imageView;
    if (![cell.subviews.lastObject isKindOfClass:[UIImageView class]]) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 61)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor blackColor];
        [cell addSubview:imageView];
    } else {
        imageView = (UIImageView *)cell.subviews.lastObject;
    }
    _currentImageView = imageView;
    _currentPage = indexPath.row;
    
    FSImageModel *model = self.imageArray[indexPath.row];
    __block FSImageModel *blockModel = model;
    UIImage *tempImage = [UIImage imageWithData:model.data];
    imageView.image = tempImage;
    
//    NSURL *assetUrl = model.assetUrl;
//    if (!assetUrl) {
//        NSString *pid = model.pid;
//        if (pid) {
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            [self sendGetRequst:[NSString stringWithFormat:@"public/zoom_in?pid=%@",pid] sucess:^(BOOL isHaveData, id obj) {
//                if (isHaveData) {
//                    if ([obj isKindOfClass:[NSDictionary class]]) {
//                        NSDictionary *responseDic = (NSDictionary *)obj;
//                        NSString *url = [FSFactoryClass parseIntegeString:responseDic key:@"url"];
//                        if (url) {
//                            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:tempImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                [hud hide:YES];
//                                _isChanged = YES;
//                                blockModel.assetUrl = [NSURL URLWithString:@"downloadDone"];
//                                blockModel.data = UIImageJPEGRepresentation(image, 0.1);
//                            }];
//                        }
//                    }
//                } else {
//                    [hud hide:YES];
//                }
//            } failedAction:^(BOOL isOver) {
//                [hud hide:YES];
//            }];
//        }
//    }
    
    return cell;
}

#pragma mark actions
- (void)p_deleteImage
{
    [self.imageArray removeObjectAtIndex:_currentPage];
    if (self.imageArray.count == 1) {
        [self p_pop];
        return;
    }
    if (_currentPage + 1 == self.imageArray.count) {
        _currentPage --;
    }
    [self.myCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_currentPage inSection:0]]];
    self.title = [NSString stringWithFormat:@"%td/%td",_currentPage + 1,self.imageArray.count - 1];
    
}

- (void)p_rotateImage
{
    _isChanged = YES;
    UIImage *image = _currentImageView.image;
    
    UIImageOrientation orientation = 0;
    switch (image.imageOrientation) {
        case UIImageOrientationUp:
            orientation = UIImageOrientationRight;
            break;
        case UIImageOrientationRight:
            orientation = UIImageOrientationDown;
            break;
        case UIImageOrientationDown:
            orientation = UIImageOrientationLeft;
            break;
        case UIImageOrientationLeft:
            orientation = UIImageOrientationUp;
            break;
        default:
            break;
    }
    image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:orientation];
    _currentImageView.image = image;
}

- (void)p_saveImage
{
    _isChanged = YES;
    FSImageModel *model = self.imageArray[_currentPage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        model.data = UIImageJPEGRepresentation(_currentImageView.image, 1.0);
        dispatch_async(dispatch_get_main_queue(), ^{
//            [FSFactoryClass showMessage:@"保存成功" view:self.view];
        });
    });
}

- (void)p_pop
{
    //把修改完的图片传给imagePickerView
    if (self.editedCallBack) {
        self.editedCallBack(self.imageArray,_isChanged);
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.title = [NSString stringWithFormat:@"%td/%td",_currentPage + 1,self.imageArray.count - 1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
