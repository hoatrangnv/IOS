//
//  DucNT_HienThiTokenViewController.m
//  ViMASS
//
//  Created by MacBookPro on 7/9/14.
//
//

#import "DucNT_HienThiTokenViewController.h"
#import "GiaoDienThongTinPhim.h"

@interface DucNT_HienThiTokenViewController ()<DucNT_ViewHienThiToken> {

}

@end

@implementation DucNT_HienThiTokenViewController

@synthesize viewHienThiToken;
@synthesize viewQuenMatKhauToken;
@synthesize viewDoiMatKhauToken;
@synthesize viewSetting;
@synthesize btnSetting;
@synthesize btnViewDoiMatKhau;
@synthesize btnViewHienThi;
@synthesize btnViewQuenMatKhau;
@synthesize nViewDangHienThi;
@synthesize viewSeperator;


#pragma mark - init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addButtonBack];
    [self addTitleView:[@"title_6_so_token" localizableString]];
//    [self khoiTaoButtonSetting];
    [self addButtonHuongDan];
    [self khoiTaoCacViewOption];
    [self khoiTaoViewSetting];
    [self.view addSubview:viewSetting];
//    [self.view bringSubviewToFront:viewSetting];
    viewSetting.hidden = YES;
}

- (void)suKienClickSetting {
//    [self.view bringSubviewToFront:viewSetting];
//    if(!viewSetting.isHidden)
//    {
//        viewSetting.hidden = YES;
//    }
//    else
//    {
//        viewSetting.hidden = NO;
//    }
    [self suKienClickViewQuenMatKhau];
}

- (void)suKienBamNutHuongDanGiaoDichViewController:(UIButton *)sender {
    GiaoDienThongTinPhim *vc = [[GiaoDienThongTinPhim alloc] initWithNibName:@"GiaoDienThongTinPhim" bundle:nil];
    vc.nOption = HUONG_DAN_PHONE_TOKEN;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark - handler error

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - dealloc

- (void)dealloc {

    if(viewSetting)
        [viewSetting release];
    if(viewHienThiToken)
    {
        [viewHienThiToken stopTimer];
        [viewHienThiToken release];
    }
    if(viewQuenMatKhauToken)
        [viewQuenMatKhauToken release];
    if(viewDoiMatKhauToken)
        [viewDoiMatKhauToken release];
    if(btnSetting)
        [btnSetting release];
    if(btnViewHienThi)
        [btnViewHienThi release];
    if(btnViewDoiMatKhau)
        [btnViewDoiMatKhau release];
    if(btnViewQuenMatKhau)
        [btnViewQuenMatKhau release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - khởi tạo view setting + các view option


-(void)khoiTaoCacViewOption
{
    //Chú ý retain khi gọi kiểu này
    if(viewHienThiToken == nil)
    {
        viewHienThiToken = [[DucNT_ViewHienThiToken alloc] initWithNib];
        viewHienThiToken.delegate = self;
    }
    
    if(viewQuenMatKhauToken == nil)
    {
        viewQuenMatKhauToken = [[DucNT_ViewQuenMatKhauToken alloc] initWithNib];
    }

    if (viewDoiMatKhauToken == nil)
    {
        viewDoiMatKhauToken = [[DucNT_ViewDoiMatKhauToken alloc] initWithNib];
    }
    
    /*Kiểm tra xem trên máy có lưu seed token chưa -> nếu có thì hiện view hiện thị
     * nếu ko thì vào view quên mật khẩu token
     */
    if([DucNT_Token daTonTaiToken])
    {
        self.nViewDangHienThi = VIEW_HIEN_TOKEN;
//        self.navigationItem.title = [@"@title_6_so_token" localizableString];
        [self addTitleView:[@"title_6_so_token" localizableString]];
        [self.view addSubview:viewHienThiToken];
    }
    else
    {
        self.nViewDangHienThi = VIEW_QUEN_MAT_KHAU_TOKEN;
//        self.navigationItem.title = [@"@title_quen_mat_khau_token" localizableString];
        [self addTitleView:[@"title_quen_mat_khau_token" localizableString]];
        [self.view addSubview:viewQuenMatKhauToken];
    }
}

/*
 * khởi tạo view setting
 */
-(void)khoiTaoViewSetting
{
    viewSetting = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 200, 50, 200, 80)];
    viewSetting.backgroundColor = [UIColor colorWithRed:0 green:(float)56/255 blue:(float)84/255 alpha:0.5];
    [self khoiTaoButtonOptionTrongViewSetting];
}

-(void)khoiTaoButtonOptionTrongViewSetting
{
    btnViewHienThi = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    btnViewQuenMatKhau = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    btnViewDoiMatKhau = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [btnViewDoiMatKhau setTitle:[@"@title_doi_mat_khau_token" localizableString] forState:UIControlStateNormal];
    [btnViewDoiMatKhau addTarget:self action:@selector(suKienClickViewDoiMatKhau) forControlEvents:UIControlEventTouchUpInside];
    btnViewDoiMatKhau.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnViewQuenMatKhau setTitle:[@"@title_quen_mat_khau_token" localizableString] forState:UIControlStateNormal];
    [btnViewQuenMatKhau addTarget:self action:@selector(suKienClickViewQuenMatKhau) forControlEvents:UIControlEventTouchUpInside];
    btnViewQuenMatKhau.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnViewHienThi setTitle:[@"@title_6_so_token" localizableString] forState:UIControlStateNormal];
    [btnViewHienThi addTarget:self action:@selector(suKienClickViewHienThiToken) forControlEvents:UIControlEventTouchUpInside];
    btnViewHienThi.titleLabel.font = [UIFont systemFontOfSize:15];
    viewSeperator = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 200, 1)];
    viewSeperator.backgroundColor = [UIColor colorWithRed:(float)133/255 green:(float)133/255 blue:(float)133/255 alpha:1];
    [self showOptionViewSetting];
}

// dùng để hiện thị lại view setting sau khi chuyển view
-(void)showOptionViewSetting
{
    if(nViewDangHienThi == VIEW_HIEN_TOKEN)
    {
        [viewSetting.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        btnViewDoiMatKhau.frame = CGRectMake(0, 0, 200, 40);
        btnViewQuenMatKhau.frame = CGRectMake(0, 40, 200, 40);
        [viewSetting addSubview:btnViewQuenMatKhau];
        [viewSetting addSubview:viewSeperator];
        [viewSetting addSubview:btnViewDoiMatKhau];
    }
    else if(nViewDangHienThi == VIEW_QUEN_MAT_KHAU_TOKEN)
    {
        [viewSetting.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        btnViewHienThi.frame = CGRectMake(0, 0, 200, 40);
        btnViewDoiMatKhau.frame = CGRectMake(0, 40, 200, 40);
        [viewSetting addSubview:btnViewDoiMatKhau];
        [viewSetting addSubview:viewSeperator];
        [viewSetting addSubview:btnViewHienThi];
    }
    else if(nViewDangHienThi == VIEW_DOI_MAT_KHAU_TOKEN)
    {
        [viewSetting.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        btnViewHienThi.frame = CGRectMake(0, 0, 200, 40);
        btnViewQuenMatKhau.frame = CGRectMake(0, 40, 200, 40);
        [viewSetting addSubview:btnViewQuenMatKhau];
        [viewSetting addSubview:viewSeperator];
        [viewSetting addSubview:btnViewHienThi];
    }
}

#pragma mark - xử lý sự kiện chuyển chọn chức năng
-(void)didSelectBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)suKienClickButtonSetting
{
//    [self.view bringSubviewToFront:viewSetting];
//    if(!viewSetting.isHidden)
//    {
//        viewSetting.hidden = YES;
//    }
//    else
//    {
//        viewSetting.hidden = NO;
//    }
    [self suKienClickViewQuenMatKhau];
}

-(void)suKienClickViewQuenMatKhau
{
    viewSetting.hidden = YES;
    nViewDangHienThi = VIEW_QUEN_MAT_KHAU_TOKEN;
    [self showOptionViewSetting];
    [viewDoiMatKhauToken removeFromSuperview];
    [viewHienThiToken removeFromSuperview];
    [self addTitleView:[@"title_quen_mat_khau_token" localizableString]];
    viewQuenMatKhauToken.frame = CGRectMake(0, 5, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:viewQuenMatKhauToken];
}

-(void)suKienClickViewDoiMatKhau
{
    viewSetting.hidden = YES;
    nViewDangHienThi = VIEW_DOI_MAT_KHAU_TOKEN;
    [self showOptionViewSetting];
    [viewQuenMatKhauToken removeFromSuperview];
    [viewHienThiToken removeFromSuperview];
    self.title = [@"@title_doi_mat_khau_token" localizableString];
    [self.view addSubview:viewDoiMatKhauToken];
}

-(void)suKienClickViewHienThiToken
{
    viewSetting.hidden = YES;
    nViewDangHienThi = VIEW_HIEN_TOKEN;
    [self showOptionViewSetting];
    [viewDoiMatKhauToken removeFromSuperview];
    [viewQuenMatKhauToken removeFromSuperview];
    self.title = [@"@title_6_so_token" localizableString];
    [self.view addSubview:viewHienThiToken];
}

@end
