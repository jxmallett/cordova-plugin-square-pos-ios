#import <Cordova/CDV.h>
@import SquarePointOfSaleSDK;

@interface SquarePointOfSale : CDVPlugin
    @property   NSString* callbackId;
    @property (nonatomic, assign) SCCAPIRequestTenderTypes supportedTenderTypes;
    - (void)initTransaction:(CDVInvokedUrlCommand*)command;
@end
