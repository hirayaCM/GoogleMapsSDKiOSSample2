//
//  ViewController.m
//  GoogleMapsSample
//
//  Created by hiraya.shingo on 2014/05/20.
//
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>

/**
 *  マーカーの表示状態
 */
typedef NS_ENUM(NSInteger, markerState) {
    /**
     *  非表示
     */
    markerStateHidden = 1,
    /**
     *  表示中
     */
    markerStateDisplay,
};

@interface ViewController () <GMSMapViewDelegate>

/**
 *  `GMSMapView`
 */
@property (strong, nonatomic) GMSMapView *mapView;

/**
 *  GMSMarkerの配列
 */
@property (strong, nonatomic) NSArray *markers;

@end

@implementation ViewController

#pragma mark - UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // (1) GMSCameraPositionインスタンスの作成
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.698717
                                                            longitude:139.772900
                                                                 zoom:16.0];
    
    // (2) GMSMapViewインスタンスの作成
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    // (3) myLocationEnabledプロパティ
    self.mapView.myLocationEnabled = YES;
    
    // (4) settings.myLocationButtonプロパティ
    self.mapView.settings.myLocationButton = YES;
    
    // (5) delegateの設定
    self.mapView.delegate = self;
    
    self.view = self.mapView;
}

#pragma mark - GMSMapViewDelegate methods

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    [self reloadMarkers];
}

#pragma mark - private methods

/**
 *  マーカーの表示を更新する
 */
- (void)reloadMarkers
{
    // 表示されているマップアイテムのうち、画面外になったマーカー : マーカー削除
    // 非表示のマップアイテムのうち、画面内になったマーカー : マーカー追加
    for (GMSMarker *marker in self.markers) {
        if (marker.map) {
            // 表示中Item
            if ([self containsMarkerInMap:marker] == NO) {
                // マーカーが領域外になった
                marker.map = NO;
                NSLog(@"hidden %@ marker", marker.title);
            }
        } else {
            // 非表示のItem
            if ([self containsMarkerInMap:marker] == YES) {
                // マーカーが領域内になった
                // フラグを表示に変更
                marker.map = self.mapView;
                NSLog(@"display %@ marker", marker.title);
            }
        }
    }
}

/**
 *  現在の可視領域のGMSCoordinateBoundsを返す
 *
 *  @return `GMSCoordinateBounds`
 */
- (GMSCoordinateBounds *)visiableCoordinateBounds
{
    CLLocationCoordinate2D bottomLeftCoord = self.mapView.projection.visibleRegion.nearLeft;
    CLLocationCoordinate2D topRightCoord = self.mapView.projection.visibleRegion.farRight;
    
    return [[GMSCoordinateBounds alloc]initWithCoordinate:topRightCoord coordinate:bottomLeftCoord];
}

/**
 *  markerが地図の可視領域に存在するか
 *
 *  @param marker `GMSMarker`
 *
 *  @return markerが地図の可視領域に存在する場合YES、そうでなければNO
 */
- (BOOL)containsMarkerInMap:(GMSMarker *)marker
{
    return [self.visiableCoordinateBounds containsCoordinate:marker.position];
}

- (NSArray *)markers
{
    if (!_markers) {
        GMSMarker *yodobashiMarker = [GMSMarker new];
        yodobashiMarker.title = @"ヨドバシAkiba";
        yodobashiMarker.position = CLLocationCoordinate2DMake(35.698852, 139.774761);
        yodobashiMarker.userData = [NSNumber numberWithInteger:markerStateHidden];
        
        GMSMarker *akihabaraStationMarker = [GMSMarker new];
        akihabaraStationMarker.title = @"秋葉原駅";
        akihabaraStationMarker.position = CLLocationCoordinate2DMake(35.698404, 139.773001);
        akihabaraStationMarker.userData = [NSNumber numberWithInteger:markerStateHidden];
        
        GMSMarker *classmethodMarker = [GMSMarker new];
        classmethodMarker.title = @"クラスメソッド株式会社";
        classmethodMarker.position = CLLocationCoordinate2DMake(35.697236, 139.774718);
        classmethodMarker.userData = [NSNumber numberWithInteger:markerStateHidden];
        
        GMSMarker *denkigaiMarker = [GMSMarker new];
        denkigaiMarker.title = @"電気街";
        denkigaiMarker.position = CLLocationCoordinate2DMake(35.699649, 139.771419);
        denkigaiMarker.userData = [NSNumber numberWithInteger:markerStateHidden];
        
        GMSMarker *kandaMarker = [GMSMarker new];
        kandaMarker.title = @"神田駅";
        kandaMarker.position = CLLocationCoordinate2DMake(35.691690, 139.770883);
        kandaMarker.userData = [NSNumber numberWithInteger:markerStateHidden];
        
        GMSMarker *uenoMarker = [GMSMarker new];
        uenoMarker.title = @"上野駅";
        uenoMarker.position = CLLocationCoordinate2DMake(35.713768, 139.777254);
        uenoMarker.userData = [NSNumber numberWithInteger:markerStateHidden];
        
        GMSMarker *ochanomizuMarker = [GMSMarker new];
        ochanomizuMarker.title = @"御茶ノ水駅";
        ochanomizuMarker.position = CLLocationCoordinate2DMake(35.699855, 139.763786);
        ochanomizuMarker.userData = [NSNumber numberWithInteger:markerStateHidden];
        
        GMSMarker *asakusabashiMarker = [GMSMarker new];
        asakusabashiMarker.title = @"浅草橋駅";
        asakusabashiMarker.position = CLLocationCoordinate2DMake(35.697467, 139.785976);
        asakusabashiMarker.userData = [NSNumber numberWithInteger:markerStateHidden];
        
        _markers = @[
                     yodobashiMarker,
                     akihabaraStationMarker,
                     classmethodMarker,
                     denkigaiMarker,
                     kandaMarker,
                     uenoMarker,
                     ochanomizuMarker,
                     asakusabashiMarker,
                     ];
    }
    
    return _markers;
}

@end