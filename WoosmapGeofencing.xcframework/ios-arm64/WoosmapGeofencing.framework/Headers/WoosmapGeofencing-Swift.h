// Generated by Apple Swift version 5.5.2 (swiftlang-1300.0.47.5 clang-1300.0.29.30)
#ifndef WOOSMAPGEOFENCING_SWIFT_H
#define WOOSMAPGEOFENCING_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(ns_consumed)
# define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
# define SWIFT_RELEASES_ARGUMENT
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import CoreLocation;
@import Foundation;
@import ObjectiveC;
@import Realm;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="WoosmapGeofencing",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif


@class NSDate;
@class NSNumber;
@class NSString;

SWIFT_CLASS("_TtC17WoosmapGeofencing8Distance")
@interface Distance : RealmSwiftObject
@property (nonatomic, copy) NSDate * _Nullable date;
@property (nonatomic) double originLatitude;
@property (nonatomic) double originLongitude;
@property (nonatomic) double destinationLatitude;
@property (nonatomic) double destinationLongitude;
@property (nonatomic) NSInteger distance;
@property (nonatomic, copy) NSString * _Nullable distanceText;
@property (nonatomic) NSInteger duration;
@property (nonatomic, copy) NSString * _Nullable durationText;
@property (nonatomic, copy) NSString * _Nullable mode;
@property (nonatomic, copy) NSString * _Nullable units;
@property (nonatomic, copy) NSString * _Nullable routing;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC17WoosmapGeofencing8Location")
@interface Location : RealmSwiftObject
@property (nonatomic, copy) NSDate * _Nullable date;
@property (nonatomic) double latitude;
@property (nonatomic, copy) NSString * _Nullable locationDescription;
@property (nonatomic, copy) NSString * _Nullable locationId;
@property (nonatomic) double longitude;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class CLLocationManager;
@class CLVisit;
@class CLLocation;
@class CLRegion;

SWIFT_CLASS("_TtC17WoosmapGeofencing15LocationService")
@interface LocationService : NSObject <CLLocationManagerDelegate>
- (void)locationManager:(CLLocationManager * _Nonnull)manager didVisit:(CLVisit * _Nonnull)visit;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didUpdateLocations:(NSArray<CLLocation *> * _Nonnull)locations;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nonnull)error;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didExitRegion:(CLRegion * _Nonnull)region;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didEnterRegion:(CLRegion * _Nonnull)region;
- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager * _Nonnull)manager;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didStartMonitoringForRegion:(CLRegion * _Nonnull)region;
- (void)locationManager:(CLLocationManager * _Nonnull)manager monitoringDidFailForRegion:(CLRegion * _Nullable)region withError:(NSError * _Nonnull)error;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC17WoosmapGeofencing12LogSearchAPI")
@interface LogSearchAPI : RealmSwiftObject
@property (nonatomic, copy) NSDate * _Nullable date;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, copy) NSString * _Nullable lastPOI_distance;
@property (nonatomic, copy) NSString * _Nullable distanceLimit;
@property (nonatomic, copy) NSString * _Nullable locationDescription;
@property (nonatomic, copy) NSString * _Nullable distanceTraveled;
@property (nonatomic, copy) NSString * _Nullable distanceToFurthestMonitoredPOI;
@property (nonatomic, copy) NSString * _Nullable distanceTraveledLastRefreshPOIRegion;
@property (nonatomic) double searchAPILastRequestTimeStampValue;
@property (nonatomic) BOOL sendSearchAPIRequest;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSData;

SWIFT_CLASS("_TtC17WoosmapGeofencing3POI")
@interface POI : RealmSwiftObject
@property (nonatomic, copy) NSData * _Nullable jsonData;
@property (nonatomic, copy) NSString * _Nullable city;
@property (nonatomic, copy) NSString * _Nullable idstore;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSDate * _Nullable date;
@property (nonatomic) double distance;
@property (nonatomic, copy) NSString * _Nullable duration;
@property (nonatomic) double latitude;
@property (nonatomic, copy) NSString * _Nullable locationId;
@property (nonatomic) double longitude;
@property (nonatomic, copy) NSString * _Nullable zipCode;
@property (nonatomic) double radius;
@property (nonatomic, copy) NSString * _Nullable address;
@property (nonatomic) BOOL openNow;
@property (nonatomic, copy) NSString * _Nullable countryCode;
@property (nonatomic, copy) NSString * _Nullable tags;
@property (nonatomic, copy) NSString * _Nullable types;
@property (nonatomic, copy) NSString * _Nullable contact;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC17WoosmapGeofencing6Region")
@interface Region : RealmSwiftObject
@property (nonatomic, copy) NSDate * _Nullable date;
@property (nonatomic) BOOL didEnter;
@property (nonatomic, copy) NSString * _Nullable identifier;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double radius;
@property (nonatomic) BOOL fromPositionDetection;
@property (nonatomic) NSInteger distance;
@property (nonatomic, copy) NSString * _Nonnull distanceText;
@property (nonatomic) NSInteger duration;
@property (nonatomic, copy) NSString * _Nonnull durationText;
@property (nonatomic, copy) NSString * _Nonnull type;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC17WoosmapGeofencing15RegionIsochrone")
@interface RegionIsochrone : RealmSwiftObject
@property (nonatomic, copy) NSDate * _Nullable date;
@property (nonatomic) BOOL didEnter;
@property (nonatomic, copy) NSString * _Nullable identifier;
@property (nonatomic, copy) NSString * _Nullable locationId;
@property (nonatomic, copy) NSString * _Nullable idStore;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) NSInteger radius;
@property (nonatomic) BOOL fromPositionDetection;
@property (nonatomic) NSInteger distance;
@property (nonatomic, copy) NSString * _Nonnull distanceText;
@property (nonatomic) NSInteger duration;
@property (nonatomic, copy) NSString * _Nonnull durationText;
@property (nonatomic, copy) NSString * _Nonnull type;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC17WoosmapGeofencing5Visit")
@interface Visit : RealmSwiftObject
@property (nonatomic) double accuracy;
@property (nonatomic, copy) NSDate * _Nullable arrivalDate;
@property (nonatomic, copy) NSDate * _Nullable date;
@property (nonatomic, copy) NSDate * _Nullable departureDate;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, copy) NSString * _Nullable visitId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


/// WoosmapGeofencing main class. Cannot be instanciated, use <code>shared</code> property to access singleton
SWIFT_CLASS("_TtC17WoosmapGeofencing17WoosmapGeofencing")
@interface WoosmapGeofencing : NSObject
@property (nonatomic, strong) LocationService * _Null_unspecified locationService;
/// Access singleton of Now object
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) WoosmapGeofencing * _Nonnull shared;)
+ (WoosmapGeofencing * _Nonnull)shared SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
- (LocationService * _Nonnull)getLocationService SWIFT_WARN_UNUSED_RESULT;
- (void)initServices SWIFT_METHOD_FAMILY(none);
- (void)setTrackingEnableWithEnable:(BOOL)enable;
- (BOOL)getTrackingState SWIFT_WARN_UNUSED_RESULT;
- (void)setWoosmapAPIKeyWithKey:(NSString * _Nonnull)key;
- (void)setGMPAPIKeyWithKey:(NSString * _Nonnull)key;
- (void)setSearchWoosmapAPIWithApi:(NSString * _Nonnull)api;
- (void)setDistanceWoosmapAPIWithApi:(NSString * _Nonnull)api;
- (void)setTrafficDistanceWoosmapAPIWithApi:(NSString * _Nonnull)api;
- (void)setDistanceAPILanguageWithLanguage:(NSString * _Nonnull)language;
- (void)setDistanceMaxAirDistanceFilterWithDistance:(NSInteger)distance;
- (void)setDistanceTimeFilterWithTime:(NSInteger)time;
- (void)setCurrentPositionFilterWithDistance:(double)distance time:(NSInteger)time;
- (void)setSearchAPIRequestEnableWithEnable:(BOOL)enable;
- (BOOL)getSearchAPIRequestEnable SWIFT_WARN_UNUSED_RESULT;
- (void)setSearchAPICreationRegionEnableWithEnable:(BOOL)enable;
- (BOOL)getSearchAPICreationRegionEnable SWIFT_WARN_UNUSED_RESULT;
- (void)setSearchAPILastRequestTimeStampWithTime:(double)time;
- (double)getSearchAPILastRequestTimeStamp SWIFT_WARN_UNUSED_RESULT;
- (void)setDistanceAPIRequestEnableWithEnable:(BOOL)enable;
- (BOOL)getDistanceAPIRequestEnable SWIFT_WARN_UNUSED_RESULT;
- (void)setSearchAPIFilterWithDistance:(double)distance time:(NSInteger)time;
- (void)setSearchAPIRefreshDelayDayWithDay:(NSInteger)day;
- (NSInteger)getSearchAPIRefreshDelayDay SWIFT_WARN_UNUSED_RESULT;
- (void)setVisitEnableWithEnable:(BOOL)enable;
- (BOOL)getVisitEnable SWIFT_WARN_UNUSED_RESULT;
- (void)setAccuracyVisitFilterWithAccuracy:(double)accuracy;
- (void)setCreationOfZOIEnableWithEnable:(BOOL)enable;
- (void)setClassificationWithEnable:(BOOL)enable;
- (void)setRadiusDetectionClassifiedZOIWithRadius:(double)radius;
- (void)startMonitoringInForeGround;
/// Call this method from the DidFinishLaunchWithOptions method of your App Delegate
- (void)startMonitoringInBackground;
/// Call this method from the applicationDidBecomeActive method of your App Delegate
- (void)didBecomeActive;
- (void)trackingChangedWithTracking:(BOOL)tracking;
- (void)setModeHighfrequencyLocationWithEnable:(BOOL)enable;
- (BOOL)getModeHighfrequencyLocation SWIFT_WARN_UNUSED_RESULT;
- (void)refreshLocationWithAllTime:(BOOL)allTime;
- (void)setSearchAPIParametersWithParameters:(NSDictionary<NSString *, NSString *> * _Nonnull)parameters;
- (void)setUserPropertiesFilterWithProperties:(NSArray<NSString *> * _Nonnull)properties;
- (void)setSFMCCredentialsWithCredentials:(NSDictionary<NSString *, NSString *> * _Nonnull)credentials;
- (void)setPoiRadiusWithRadius:(id _Nonnull)radius;
- (void)stopTracking;
@end


SWIFT_CLASS("_TtC17WoosmapGeofencing3ZOI")
@interface ZOI : RealmSwiftObject
@property (nonatomic) double accumulator;
@property (nonatomic) double age;
@property (nonatomic) double covariance_det;
@property (nonatomic) int64_t duration;
@property (nonatomic, copy) NSDate * _Nullable endTime;
@property (nonatomic) double latMean;
@property (nonatomic) double lngMean;
@property (nonatomic, copy) NSString * _Nullable period;
@property (nonatomic) double prior_probability;
@property (nonatomic, copy) NSDate * _Nullable startTime;
@property (nonatomic, copy) NSString * _Nullable wktPolygon;
@property (nonatomic) double x00Covariance_matrix_inverse;
@property (nonatomic) double x01Covariance_matrix_inverse;
@property (nonatomic) double x10Covariance_matrix_inverse;
@property (nonatomic) double x11Covariance_matrix_inverse;
@property (nonatomic, copy) NSString * _Nullable zoiId;
+ (NSString * _Nullable)primaryKey SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
#endif
