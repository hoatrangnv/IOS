//
//  PlaceGalleryView.m
//  ViMASS
//
//  Created by Chung NV on 8/22/13.
//
//

#import "PlaceGalleryView.h"
#import "YoutubeObj.h"
#import "OtherService.h"
@implementation PlaceGalleryView
{
    NSMutableArray *yt_videos;
}
-(void)_init
{
    //
    NSArray *links = @[@"http://www.youtube.com/watch?v=BgNjixKZhHU",@"http://www.youtube.com/watch?v=pMuHiJXwWJc",@"http://www.youtube.com/watch?v=NnEJfUnI-qU",@"http://www.youtube.com/watch?v=WRsz7dPWIlA",@"http://www.youtube.com/watch?v=8AasR3xtXkc",@"http://www.youtube.com/watch?v=rQ8bLzRMg1A",@"http://www.youtube.com/watch?v=7LBU4hdsJd8",@"http://www.youtube.com/watch?v=R1OSEZ2eqiI"];
    yt_videos = [NSMutableArray new];
    for (int i = 0; i< links.count; i++)
    {
        NSString *link = [links objectAtIndex:i];
        YoutubeObj *yt = [[YoutubeObj alloc] init];
        NSString *ytID = [YoutubeObj ytIDFromLinkVideo:link];
        yt.ytLink = link;
        yt.ytImageThumb = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/hqdefault.jpg",ytID];
        [[OtherService requestWithCallBack:^(OtherService *service, NSString *messCode) {
            yt.ytTitle = ((YoutubeObj *)service.data).ytTitle;
            if (tblGallery != nil)
            {
                NSIndexPath *idxPath = [NSIndexPath indexPathForRow:i inSection:0];
                [tblGallery reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }] getYoutubeInfo:link];
        [yt_videos addObject:yt];
        [yt release];
    }
}

-(void)removeFromSuperview
{
//    v_youtube_playe
    [super removeFromSuperview];
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    tblGallery.cellClass = @"PlaceGalleryViewCell";
    tblGallery.datas = yt_videos;
    [tblGallery didSelectedRow:^(id object)
     {
         YoutubeObj *yt = (YoutubeObj *) object;
         [v_youtube_player setVideoURL:yt.ytLink];
     }];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self _init];
    }
    return self;
}

- (void)dealloc
{
    [tblGallery release];
    [v_youtube_player release];
    [super dealloc];
}
@end
