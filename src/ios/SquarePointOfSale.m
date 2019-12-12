#import "SquarePointOfSale.h"
#import <Cordova/CDV.h>
@import SquarePointOfSaleSDK;
@implementation SquarePointOfSale;
@synthesize callbackId;

- (void)initTransaction:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
    NSDictionary *options = [command.arguments objectAtIndex: 0];
    NSNumber *amountInCents = [options objectForKey:@"amount"];
    float floatAmount = [amountInCents floatValue];
    NSString * currencyCode = [options objectForKey:@"currencyCode"];
    NSString * squareClientId = [options objectForKey:@"squareClientId"];
    NSString * squareCallbackFunction = [options objectForKey:@"squareCallbackFunction"];
    NSString * locationID = [options objectForKey:@"location"];
    NSString * notes = [options objectForKey:@"notes"];
    NSError *error = nil;
    SCCMoney *amount = [SCCMoney moneyWithAmountCents:floatAmount*100 currencyCode:currencyCode error:&error];
    [SCCAPIRequest setClientID:squareClientId];
    SCCAPIRequest *request = [SCCAPIRequest requestWithCallbackURL:[NSURL URLWithString:squareCallbackFunction]
                                                            amount:amount
                                                    userInfoString:nil
                                                        locationID:locationID
                                                             notes:notes
                                                        customerID:nil
                                              supportedTenderTypes:13 //allows all payments except cash
                                                 clearsDefaultFees:NO
                                   returnAutomaticallyAfterPayment:TRUE
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
    NSString* transactionID = response.transactionID;
    if(transactionID) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:transactionID];
    } else {
        NSError* error = response.error;
        NSInteger errorCode = error.code;
        NSString*  errorMessage = @"";
        if(errorCode == 5) {
            errorMessage = @"com.squareup.register.ERROR_ILLEGAL_LOCATION_ID";
        } else if(errorCode == 3) {
            errorMessage = @"com.squareup.register.ERROR_USER_NOT_LOGGED_IN";
        } else {
            errorMessage = @"com.squareup.register.ERROR_TRANSACTION_CANCELED";
        }
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

@end
