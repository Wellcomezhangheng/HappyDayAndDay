//
//  mineViewController.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "mineViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <MessageUI/MessageUI.h>
#import "ProgressHUD.h"
#import "WeiboSDK.h"
#import "WBHttpRequest+WeiboShare.h"
#import "AppDelegate.h"

@interface mineViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *headImageButton;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UILabel *nikeNameLable;
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIView *blackView;
@end

@implementation mineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageArray = @[@"icon_ele.png",@"icon_msg.png",@"icon_like.png",@"icon_ac.png",@"icon_ordered.png"];
    self.titleArray = [NSMutableArray arrayWithObjects:@"清除缓存",@"用户反馈",@"给我评分",@"当前版本",@"分享给好友", nil];
    self.navigationController.navigationBar.barTintColor = mainColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self HeaderView];
     [self.view addSubview:self.tableView];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //每次图片出现的时候，重新计算图片缓存大小；
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger catchSize = [cache getSize];
    NSString *cachstr = [NSString stringWithFormat:@"清除缓存大小 （%.02fM）",(float)catchSize/1024/1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cachstr];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)HeaderView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 195)];
    headView.backgroundColor = RGB(96, 185, 191);
    self.tableView.tableHeaderView = headView;
    [headView addSubview:self.nikeNameLable];
    [headView addSubview:self.headImageButton];
}
//登录/注册
- (void)login{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            //清除缓存图片；
            NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
            SDImageCache *cache = [SDImageCache sharedImageCache];
            [cache clearDisk];
            [self.titleArray replaceObjectAtIndex:0 withObject:@"清除缓存"];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case 1:
        {
            [self yesORno];
//            if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
//                [self sendEmail]; // 调用发送邮件的代码
//            }
        }
            break;
        case 2:
        {
            //用户评分
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 3:
        {
            //检测当前版本
            [ProgressHUD show:@"正在为您检测中"];
            [self performSelector:@selector(checkAppVersion) withObject:nil afterDelay:2.0];
        }
            break;
        case 4:
        {
            //分享
            [self share];
            //[self shareee];
        }
            break;
    default:
            break;
    }
}
- (void)shareee{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:nil];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    [alertController addAction:archiveAction];
    [self presentViewController:alertController animated:YES completion:nil];
//    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"标题" message:@"这个是UIAlertView的默认样式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
//    [alertview show];
    
    
    
}
- (void)yesORno{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题" message:@"是否发送邮件" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    //启用对话框视图控制器
    [self presentViewController:alertController animated:YES completion:nil];
}
//发送邮件
- (void)sendEmail{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
    [mailCompose setSubject:@"我是邮件主题"];
    
    // 设置收件人
    [mailCompose setToRecipients:@[@"838579111@qq.com"]];
    // 设置抄送人
//    [mailCompose setCcRecipients:@[@"2218722044@qq.com"]];
    // 设置密抄送
    [mailCompose setBccRecipients:@[@"邮箱号码"]];
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = @"我是邮件内容";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    /**
     *  添加附件
     */
    UIImage *image = [UIImage imageNamed:@"image"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [mailCompose addAttachmentData:imageData mimeType:@"" fileName:@"custom.png"];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
    NSData *pdf = [NSData dataWithContentsOfFile:file];
    [mailCompose addAttachmentData:pdf mimeType:@"" fileName:@"7天精通IOS233333"];
    
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}
//邮件发送完成调用的方法
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result)
    {
        case MFMailComposeResultCancelled: //取消
            NSLog(@"MFMailComposeResultCancelled-取消");
            break;
        case MFMailComposeResultSaved: // 保存
            NSLog(@"MFMailComposeResultSaved-保存邮件");
            break;
        case MFMailComposeResultSent: // 发送
            NSLog(@"MFMailComposeResultSent-发送邮件");
            break;
        case MFMailComposeResultFailed: // 尝试保存或发送邮件失败
            NSLog(@"MFMailComposeResultFailed发送失败: %@...",[error localizedDescription]);
        break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)checkAppVersion{
    [ProgressHUD showSuccess:@"当前已是最新版本"];
}
- (void)share{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    
    _blackView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kWidth, kHeight )];
    _blackView.backgroundColor = [UIColor whiteColor];
    [window addSubview:_blackView];

 
    
    
    _shareView = [[UIView alloc] initWithFrame:CGRectMake(0,kHeight, kWidth, kHeight)];
    _shareView.backgroundColor = [UIColor redColor];
    [window addSubview:_shareView];
  //微博
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(40, 40,70, 70);
    [weiboBtn addTarget:self action:@selector(fenxiang:) forControlEvents:UIControlEventTouchUpInside];
    [weiboBtn setImage:[UIImage imageNamed:@"ic_com_sina_weibo_sdk_logo.png"] forState:UIControlStateNormal];
    [_shareView addSubview:weiboBtn];
    //friend
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(130, 40,70, 70);
    [friendBtn setImage:[UIImage imageNamed:@"11.png"] forState:UIControlStateNormal];
    [_shareView addSubview:friendBtn];
    //circleBtn
    UIButton *circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    circleBtn.frame = CGRectMake(210, 40,70, 70);
    [circleBtn setImage:[UIImage imageNamed:@"ic_com_sina_weibo_sdk_logo.png"] forState:UIControlStateNormal];
    [_shareView addSubview:circleBtn];
    //取消按钮
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(130, 150,70, 70);
    [removeBtn setImage:[UIImage imageNamed:@"noselect.png"] forState:UIControlStateNormal];
    [_shareView addSubview:removeBtn];
    [removeBtn addTarget:self action:@selector(quxiao) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.8;
        self.shareView.frame = CGRectMake(0, 450, kWidth, kHeight-450);
    }];
    
}
- (void)quxiao{
     [self.shareView removeFromSuperview];
    [self.blackView removeFromSuperview];
}
- (void)fenxiang:(UIButton *)btn{
    {
        AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        authRequest.redirectURI = kRedirectURL;
        authRequest.scope = @"all";
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
        request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
        [WeiboSDK sendRequest:request];
        [self quxiao];
    
}
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    ZHLog(@"%@",response);
    
   
}
- (WBMessageObject *)messageToShare{
    WBMessageObject *message = [WBMessageObject message];
     message.text = NSLocalizedString(@"测试通过WeiboSDK发送文字到微博!", nil);
    return message;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    for (int i = 0; i < 5; i ++) {
        if (indexPath.row == i) {
            cell.textLabel.text = self.titleArray[i];
            cell.imageView.image = [UIImage imageNamed:self.imageArray[i]];
        }
    }
//    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
//    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
    return cell;
}
-(UILabel *)nikeNameLable{
    if (_nikeNameLable == nil) {
        self.nikeNameLable = [[UILabel alloc] initWithFrame:CGRectMake(180, 75, kWidth-200, 40)];
        self.nikeNameLable.text = @"HappyDayAndDay";
        self.nikeNameLable.numberOfLines = 0;
        self.nikeNameLable.textColor = [UIColor whiteColor];
    }
    return _nikeNameLable;
}
- (UIView *)shareView{
    if (_shareView == nil) {
        _shareView = [UIView new];
    }
    return _shareView;
}
- (UIButton *)headImageButton{
    if (_headImageButton == nil) {
        _headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _headImageButton.frame = CGRectMake(20, 40, 130, 130);
        [self.headImageButton setTitle:@"登录/注册" forState:UIControlStateNormal];
        [self.headImageButton setBackgroundColor:[UIColor whiteColor]];
        [self.headImageButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [self.headImageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.headImageButton.layer.cornerRadius = 65;
        self.headImageButton.clipsToBounds = YES;
    }
    return _headImageButton;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-44-64) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
