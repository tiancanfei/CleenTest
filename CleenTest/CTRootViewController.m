//
//  CTRootViewController.m
//  CleenTest
//
//  Created by bjwltiankong on 2018/3/19.
//  Copyright © 2018年 bjwltiankong. All rights reserved.
//

#import "CTRootViewController.h"

#import "CTRootCell.h"
#import "CTRootCellItem.h"

static NSInteger page = 1;
static NSInteger psize = 14;

@interface CTRootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *rows;

@end

@implementation CTRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    
    [self.view addSubview:self.tableView];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTRootCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CTRootCell class])];
    if (self.rows.count > indexPath.row) {
        CTRootCellItem *item = (CTRootCellItem *)self.rows[indexPath.row];
        cell.item = item;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.rows.count > indexPath.row) {
        CTRootCellItem *item = (CTRootCellItem *)self.rows[indexPath.row];
        return item.CellHeight;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

#pragma mark - getter setter

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        [_tableView registerClass:[CTRootCell class] forCellReuseIdentifier:NSStringFromClass([CTRootCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreData)];
    }
    return _tableView;
}

#pragma mark - 自定义方法

- (void)refreshData
{
    __weak typeof(self) weakSelf = self;
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD show];
    
    [[CTNetworking share] GET:kCTRoot_Url params:@{@"page":[NSString stringWithFormat:@"%zd",psize],@"psize":[NSString stringWithFormat:@"%zd",page]} success:^(id response) {
        
        [SVProgressHUD dismiss];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        NSLog(@"%@",response[@"rows"]);
        NSMutableArray *rows =  [NSMutableArray arrayWithArray:[CTRootCellItem mj_objectArrayWithKeyValuesArray:response[@"rows"]]];
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_queue_create("calulate", DISPATCH_QUEUE_CONCURRENT);
        
        [rows enumerateObjectsUsingBlock:^(CTRootCellItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"imageHref == %@,%zd",item.imageHref,item.imageHref.length);
            
            if (item.isEmpty) {
                [rows removeObject:item];
            }
            else
            {
                dispatch_group_enter(group);
                dispatch_group_async(group, queue, ^{
                    [item calculateFrames];
                    dispatch_group_leave(group);
                });
            }
        }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (page == 1)
            {
                weakSelf.rows = rows;
            }
            else
            {
                NSMutableArray *datas = [NSMutableArray array];
                [datas addObjectsFromArray:weakSelf.rows];
                [datas addObjectsFromArray:rows];
                weakSelf.rows = datas;
            }
            
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        page--;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)refreshNewData
{
    page = 1;
    [self refreshData];
}

- (void)refreshMoreData
{
    page++;
    [self refreshData];
}

@end
