cordova.define("com.simpro.plugins.squarepos.IOSSquarePOS", function(require, exports, module) {
    var exec = require('cordova/exec');
    var IOSSquarePOS = function() {
    };
    IOSSquarePOS.prototype.initTransaction = function(options, success, fail) {
        if (!options) {
            options = {};
        }
        var params = {
            amount: options.amount ? options.amount : 1,
            currencyCode: options.currencyCode? options.currencyCode : "AUD",
            squareClientId: options.squareClientId ? options.squareClientId : "",
            squareCallbackFunction: options.squareCallbackFunction? options.squareCallbackFunction : ""
        };
        return cordova.exec(success, fail, "IOSSquarePOS", "initTransaction", [params]);
    };
    
    window.iosSquarePOS = new IOSSquarePOS();
    
    });
  