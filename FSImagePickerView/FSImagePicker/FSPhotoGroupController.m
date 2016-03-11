//
//  FSPhotoGroupController.m
//  FSImagePickerView
//
//  Created by qufenqi on 1/5/16.
//  Copyright © 2016 王正一. All rights reserved.
//

#import "FSPhotoGroupController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FSPhotoAssetsController.h"

@interface FSPhotoGroupController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) ALAssetsLibrary *library;
@end

@implementation FSPhotoGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self p_setUI];
    [self p_setData];
    
}

- (void)p_setUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.rowHeight = 80;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //导航栏配置
    self.title = @"我的相册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - data
- (void)p_setData
{
    self.data = [NSMutableArray array];
    ALAssetsLibrary *libray = [[ALAssetsLibrary alloc] init];
    self.library = libray;
    [libray enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [self.data addObject:group];
        } else {
            [self.tableView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetsGroup *group = self.data[indexPath.row];
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.imageView.image = [UIImage imageWithCGImage:group.posterImage];
    
    cell.textLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)[group numberOfAssets]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetsGroup *group = self.data[indexPath.row];
    NSMutableArray *photos = [NSMutableArray array];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [photos addObject:result];
        } else {
            FSPhotoAssetsController *vc = [[FSPhotoAssetsController alloc] init];
            vc.groupVc = self;
            vc.data = photos;
            vc.title = [group valueForProperty:ALAssetsGroupPropertyName];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
}


@end
