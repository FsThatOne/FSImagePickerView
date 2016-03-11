//
//  FSPhotoAssetsController.m
//  FSImagePickerView
//
//  Created by qufenqi on 1/5/16.
//  Copyright © 2016 王正一. All rights reserved.
//

#import "FSPhotoAssetsController.h"
#import "FSPhotoAssetsCell.h"

@interface FSPhotoAssetsController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UICollectionView *myCollectionView;
//相册资源数组
@property (nonatomic, strong) NSMutableArray *mArry;
//底部的完成按钮
@property (nonatomic, weak) UIButton *completeBtn;
//选中的图片资源数组
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@end

@implementation FSPhotoAssetsController

static NSString * const reuseIdentifier = @"Cell";
#pragma mark - getter
- (NSMutableArray *)mArry
{
    if (!_mArry) {
        NSMutableArray *array= [NSMutableArray array];
        _mArry = array;
    }
    return _mArry;
}

- (NSMutableArray *)selectedAssets
{
    if (!_selectedAssets) {
        NSMutableArray *array = [NSMutableArray array];
        _selectedAssets = array;
    }
    return _selectedAssets;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setUI];
    
    [self p_setData];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.data.count > 1) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.data.count-1 inSection:0];
            [self.myCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        }
        
        
    });
    
    
}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)p_setUI
{
    //UICollectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.minimumLineSpacing = 2;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.alwaysBounceVertical = YES;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    self.myCollectionView = collectionView;
    collectionView.delegate =self;
    collectionView.dataSource = self;
    collectionView.contentInset = UIEdgeInsetsMake(10, 10, 0, 10);
    [collectionView registerClass:[FSPhotoAssetsCell class] forCellWithReuseIdentifier:@"FSPhotoAssetsCell"];
    
    //底部按钮
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44, [UIScreen mainScreen].bounds.size.width, 44)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:lineView];
    
    CGFloat btnW = 100;
    CGFloat btnY = 10;
    UIButton *completeBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - btnW - 20, btnY, btnW, bottomView.bounds.size.height - btnY * 2)];
    self.completeBtn = completeBtn;
    completeBtn.backgroundColor = [UIColor greenColor];
    NSString *str = @"0/9 完成";
    NSString *count = @"0";
    NSMutableAttributedString *mutableAtt = [self attributedStringWithString:str count:count];
    [self.completeBtn setAttributedTitle:mutableAtt forState:UIControlStateNormal];
    [completeBtn setAttributedTitle:mutableAtt forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:completeBtn];
    //导航条
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    
}

- (void)completeBtnClick
{
    //    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.selectedAssets, @"kSeletedPhotos", [NSNumber numberWithInteger:self.navigationController.view.tag], @"tag", nil];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"kSeletedPhotos" object:nil userInfo:dict];
    //
    if ([self.groupVc.delegate respondsToSelector:@selector(photoGroupController:didSelectedAssetArray:)]) {
        [self.groupVc.delegate photoGroupController:self.groupVc didSelectedAssetArray:self.selectedAssets];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableAttributedString *)attributedStringWithString:(NSString *)str count:(NSString *)count
{
    NSMutableAttributedString *mutableAtt = [[NSMutableAttributedString alloc] initWithString:str];
    [mutableAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, count.length)];
    [mutableAtt addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, str.length)];
    [self.completeBtn setAttributedTitle:mutableAtt forState:UIControlStateNormal];
    return mutableAtt;
}

#pragma mark - data
- (void)p_setData
{
    for (id obj in self.data) {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:obj forKey:@"asset"];
        FSPhotoAssetsModel *model = [FSPhotoAssetsModel photoAssetsModelWithDict:dict];
        [self.mArry addObject:model];
    }
}
#pragma mark - collectionView
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = 4;
    CGFloat width = (collectionView.bounds.size.width - (count - 1) * 10) / count;
    CGFloat height = width;
    return CGSizeMake(width, height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mArry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSPhotoAssetsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FSPhotoAssetsCell" forIndexPath:indexPath];
    cell.model = self.mArry[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSPhotoAssetsCell *cell = (FSPhotoAssetsCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    FSPhotoAssetsModel *model = self.mArry[indexPath.row];
    
    if (model.selected) {
        cell.indicator.image = [UIImage imageNamed:@"photo_unSelected"];
        model.selected = NO;
        [self.selectedAssets removeObject:model.asset];
        
    } else {
        if (self.selectedAssets.count < 9) {
//            for (NSURL *url in self.groupVc.detailViewController.storagePhotoUrl) {
//                if ([url isEqual:[model.asset valueForProperty:ALAssetPropertyAssetURL]]) {
//                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    hud.mode = MBProgressHUDModeText;
//                    hud.removeFromSuperViewOnHide = YES;
//                    hud.labelText = @"已添加过，无需重复添加";
//                    [hud hide:YES afterDelay:1];
//                    return;
//                }
//            }
            cell.indicator.image = [UIImage imageNamed:@"photo_selected"];
            model.selected = YES;
            [self.selectedAssets addObject:model.asset];
        } else {
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.removeFromSuperViewOnHide = YES;
//            hud.labelText = @"每次最多选9张";
//            [hud hide:YES afterDelay:1];
        }
    //更新底部按钮的title
    NSString *count = [NSString stringWithFormat:@"%ld", (unsigned long)self.selectedAssets.count];
    NSString *str = [NSString stringWithFormat:@"%@/9 完成", count];
    
    NSMutableAttributedString *mutableAtt = [self attributedStringWithString:str count:count];
    [self.completeBtn setAttributedTitle:mutableAtt forState:UIControlStateNormal];
    }
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
