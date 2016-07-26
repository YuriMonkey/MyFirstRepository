//
//  HomeViewController.m
//  集合视图Demo
//
//  Created by zhongjunpan on 15/11/26.
//  Copyright (c) 2015年 zhimeng. All rights reserved.
//

#import "HomeViewController.h"
#import "MyCollectionViewCell.h"
#import "DetailViewController.h"
#import "Goods.h"

@interface HomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView
{
    CGRect  rect = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:rect];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGRect rectCollection = CGRectMake(0, 0, rect.size.width, rect.size.height-20);
     self.collectionView = [[UICollectionView alloc] initWithFrame: rectCollection collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor blueColor];
   
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
   
    //每个单元的大小，也可以通过collectionView:layout:sizeForItemAtIndexPath:协议方法动态指定
    //layout.itemSize = CGSizeMake(50.0f, 50.0f);
    
    //流式布局的方向
    //水平方向：可以水平滚动，
    //              段与段之间是水平方向从左到右排列，
    //              段内每个单元则先从上到下依此排列，在垂直方向排满后，再向右侧从上到下一次依次排列。
    //              此时的段内的”行间距"是“段内的列间距”
    //              此时的段内的”单元间距"是“段内的行间距”
    //垂直方向：可以垂直滚动，
    //              段与段之间是垂直方向从上到下排列，
    //              段内每个单元则先在水平方向从左到右依此排列，在水平方向排满后，再在下方从左到右依次排列。
    //              此时的段内的”行间距"就是“段内的行间距”
    //              此时的段内的”单元间距"是“段内的列间距”
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //设置每个段与周围区域（即段于段之间、段与集合视图的边界之间）的距离
    //UIEdgeInsetsMake(顶部，左边，下边，右边）
    //实际距离可能比配置的值大
    layout.sectionInset = UIEdgeInsetsMake(10.0, 5.0f, 10.0f, 5.0f);
    
    //设置每个段内的最小行距，
    //也可以通过collectionView:layout:minimumLineSpacingForSectionAtIndex:协议方法动态设置
    //实际距离可能比配置的值大
    //layout.minimumLineSpacing = 10.0f;
    
    //设置每个段内，各个单元之间的最小间距，
    //也可以通过collectionView:layout:minimumLineSpacingForSectionAtIndex:协议方法动态设置
    //实际距离可能比配置的值大
    //layout.minimumInteritemSpacing = 10.0f;
    
    layout.headerReferenceSize = CGSizeMake(60, 60);
    layout.footerReferenceSize = CGSizeMake(20, 30);
    
    [self _initData];
}

- (void) _initData
{
    int sectionCount = 3;
    int itemCountPerSection = 15;
    self.data = [NSMutableArray arrayWithCapacity:sectionCount];
    for (int i=0; i<sectionCount; i++) {
        NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:itemCountPerSection];
        for (int j=0; j<itemCountPerSection; j++) {
            NSString *str = [NSString stringWithFormat:@"%d-%d", i+1, j+1];
            Goods *goods = [Goods new];
            goods.name = str;
            [tmp addObject:goods];
        }
        [self.data addObject:tmp];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //注册可重用的单元所使用的类
    [self.collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    //注册可重用的段头所使用的类
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    
    //注册可重用的段尾所使用的类
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleBordered target:self action:@selector(delAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(editAction:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

#pragma mark - Action
- (void)editAction:(id)sender
{
    DetailViewController *dvc = [[DetailViewController alloc] init];
    NSIndexPath *path =  [self.collectionView.indexPathsForSelectedItems firstObject];
    dvc.value = self.data[path.section][path.row];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)delAction:(id)sender
{
    [self.collectionView performBatchUpdates:^{
        NSArray * itemPaths = [self.collectionView indexPathsForSelectedItems];
        
        if (itemPaths.count > 0) {
            NSIndexPath *path = itemPaths[0];
            int sectionDelFlag = 0;
            //在数据源删除数据
            [self.data[path.section] removeObjectAtIndex:path.row];
            if ([self.data[path.section] count] == 0) {
                [self.data removeObjectAtIndex:path.section];
                sectionDelFlag = 1;
            }
            //在视图层删除数据
            if (sectionDelFlag) {
                [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:path.section]];
            } else {
                [self.collectionView deleteItemsAtIndexPaths:@[path]];
            }
        }
    } completion:nil];
}

#pragma  mark - 集合视图数据源代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.data.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    Goods *goods = self.data[indexPath.section][indexPath.row];
    cell.titleLabel.text = goods.name;
    return cell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        header.backgroundColor = [UIColor purpleColor];
        UILabel *title = (UILabel*)[header viewWithTag:100];
        if (!title) {
            title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 50)];
            title.tag = 100;
            title.font = [UIFont systemFontOfSize:20];
            title.textColor = [UIColor yellowColor];
            [header addSubview:title];
        }
        title.text = [NSString stringWithFormat:@"第%ld段", indexPath.section];
        return header;
    } else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        footer.backgroundColor = [UIColor darkGrayColor];
        return footer;
    }
    return nil;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

#pragma  mark - 集合视图事件代理
- (void)collectionView:(UICollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [NSString stringWithFormat:@"第%ld段第%ld个单元被选中！", indexPath.section, indexPath.row];
    NSLog(@"%@", str);
}

- (void)collectionView:(UICollectionView *)aCollectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [NSString stringWithFormat:@"第%ld段第%ld个单元被取消选中！", indexPath.section, indexPath.row];
    NSLog(@"%@", str);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(60, 60);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(30, 30);
}

@end
