#import "SquarePointOfSale.h"
#import <Cordova/CDV.h>
@import SquarePointOfSaleSDK;
@implementation SquarePointOfSale;
@synthesize callbackId;

- (void)initTransaction:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
    NSDictionary *options = [command.arguments objectAtIndex: 0];
    NSInteger amountInCents = [[options objectForKey:@"amount"] integerValue];
    NSString * currencyCode = [options objectForKey:@"currencyCode"];
    NSString * squareClientId = [options objectForKey:@"squareClientId"];
    NSString * squareCallbackFunction = [options objectForKey:@"squareCallbackFunction"];
    NSError *error = nil;
    SCCMoney *amount = [SCCMoney moneyWithAmountCents:amountInCents*100 currencyCode:currencyCode error:&error];
    [SCCAPIRequest setClientID:squareClientId];
    SCCAPIRequest *request = [SCCAPIRequest requestWithCallbackURL:[NSURL URLWithString:squareCallbackFunction]
                                                            amount:amount
                                                    userInfoString:nil
                                                        locationID:nil
                                                             notes:@"Privatr Notes"
                                                        customerID:nil
                                              supportedTenderTypes:SCCAPIRequestTenderTypeAll
                                                 clearsDefaultFees:NO
                                   returnAutomaticallyAfterPayment:NO
                                                             error:&error ];
    if (error) {
        return;
    }
    if (![SCCAPIConnection performRequest:request error:&error]) {
        return;
    }
}

- (void)handleOpenURL:(NSNotification*)notification {
    NSURL* url = [notification object];
    NSError *decodeError = nil;
    SCCAPIResponse  *response = [SCCAPIResponse responseWithResponseURL:url error:&decodeError];
    CDVPluginResult* pluginResult = nil;
    NSArray* emptyArray = @[response.transactionID];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:emptyArray];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

@end
