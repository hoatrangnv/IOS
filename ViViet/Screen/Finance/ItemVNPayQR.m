//
//  ItemVNPayQR.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 3/27/19.
//

#import "ItemVNPayQR.h"

@implementation ItemVNPayQR
- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        if(dict)
        {
            NSString *sPayload = [dict valueForKey:@"payLoad"];
            if (!sPayload) {
                _payLoad = @"";
            } else {
                _payLoad = sPayload;
            }
            
            NSString *sPoint = [dict valueForKey:@"pointOIMethod"];
            if (!sPoint) {
                _pointOIMethod = @"";
            } else {
                _pointOIMethod = sPoint;
            }
            
            NSString *sMaster = [dict valueForKey:@"masterMerchant"];
            if (!sMaster) {
                _masterMerchant = @"";
            } else {
                _masterMerchant = sMaster;
            }
            
            NSString *sMerchantCode = [dict valueForKey:@"merchantCode"];
            if (!sMerchantCode) {
                _merchantCode = @"";
            } else {
                _merchantCode = sMerchantCode;
            }
            
            NSString *sMerchantCC = [dict valueForKey:@"merchantCC"];
            if (!sMerchantCC) {
                _merchantCC = @"";
            } else {
                _merchantCC = sMerchantCC;
            }
            
            NSString *sCCY = [dict valueForKey:@"ccy"];
            if (!sCCY) {
                _ccy = @"";
            } else {
                _ccy = sCCY;
            }
            
            NSString *sAmount = [dict valueForKey:@"amount"];
            if (!sAmount) {
                _amount = @"";
            } else {
                _amount = sAmount;
            }
            
            NSString *sCountryCode = [dict valueForKey:@"countryCode"];
            if (!sCountryCode) {
                _countryCode = @"";
            } else {
                _countryCode = sCountryCode;
            }
            
            NSString *sMerchantName = [dict valueForKey:@"merchantName"];
            if (!sMerchantName) {
                _merchantName = @"";
            } else {
                _merchantName = sMerchantName;
            }
            
            NSString *smerchantCity = [dict valueForKey:@"merchantCity"];
            if (!smerchantCity) {
                _merchantCity = @"";
            } else {
                _merchantCity = smerchantCity;
            }
            
            NSString *spinCode = [dict valueForKey:@"pinCode"];
            if (!spinCode) {
                _pinCode = @"";
            } else {
                _pinCode = spinCode;
            }
            
            NSString *saddtionalData = [dict valueForKey:@"addtionalData"];
            if (!saddtionalData) {
                _addtionalData = @"";
            } else {
                _addtionalData = saddtionalData;
            }
            
            NSString *scrc16 = [dict valueForKey:@"crc16"];
            if (!scrc16) {
                _crc16 = @"";
            } else {
                _crc16 = scrc16;
            }
            
            NSString *sstoreID = [dict valueForKey:@"storeID"];
            if (!sstoreID) {
                _storeID = @"";
            } else {
                _storeID = sstoreID;
            }
            
            NSString *sbillNumber = [dict valueForKey:@"billNumber"];
            if (!sbillNumber) {
                _billNumber = @"";
            } else {
                _billNumber = sbillNumber;
            }
            
            NSString *sterminalID = [dict valueForKey:@"terminalID"];
            if (!sterminalID) {
                _terminalID = @"";
            } else {
                _terminalID = sterminalID;
            }
            
            NSString *spurposeTemp = [dict valueForKey:@"purpose"];
            if (!spurposeTemp) {
                _purpose = @"";
            } else {
                _purpose = spurposeTemp;
            }
            
            NSString *sconsumerDataTemp = [dict valueForKey:@"consumerData"];
            if (!sconsumerDataTemp) {
                _consumerData = @"";
            } else {
                _consumerData = sconsumerDataTemp;
            }
            
            NSString *scustomerIDTemp = [dict valueForKey:@"customerID"];
            if (!scustomerIDTemp) {
                _customerID = @"";
            } else {
                _customerID = scustomerIDTemp;
            }
            
            NSString *sreferenceIDTemp = [dict valueForKey:@"referenceID"];
            if (!sreferenceIDTemp) {
                _referenceID = @"";
            } else {
                _referenceID = sreferenceIDTemp;
            }
            
            NSString *expDateTemp = [dict valueForKey:@"expDate"];
            if (!expDateTemp) {
                _expDate = @"";
            } else {
                _expDate = expDateTemp;
            }
            
            _typeQRShow = [[dict valueForKey:@"typeQRShow"] intValue];
        } else {
            _typeQRShow = 0;
        }
    }
    return self;
}

- (void)setData:(NSDictionary *)dict {
    _payLoad = [[NSString alloc] initWithString:@""];
    _pointOIMethod = [[NSString alloc] initWithString:@""];
    _masterMerchant = [[NSString alloc] initWithString:@""];
    _merchantCode = [[NSString alloc] initWithString:@""];
    _merchantCC = [[NSString alloc] initWithString:@""];
    _ccy = [[NSString alloc] initWithString:@""];
    _amount = [[NSString alloc] initWithString:@""];
    _countryCode = [[NSString alloc] initWithString:@""];
    _merchantName = [[NSString alloc] initWithString:@""];
    _merchantCity = [[NSString alloc] initWithString:@""];
    _pinCode = [[NSString alloc] initWithString:@""];
    _addtionalData = [[NSString alloc] initWithString:@""];
    _crc16 = [[NSString alloc] initWithString:@""];
    _storeID = [[NSString alloc] initWithString:@""];
    _billNumber = [[NSString alloc] initWithString:@""];
    _terminalID = [[NSString alloc] initWithString:@""];
    _purpose = [[NSString alloc] initWithString:@""];
    _consumerData = [[NSString alloc] initWithString:@""];
    _customerID = [[NSString alloc] initWithString:@""];
    _referenceID = [[NSString alloc] initWithString:@""];
    _expDate = [[NSString alloc] initWithString:@""];
    if(dict)
    {
        NSString *sPayload = [dict valueForKey:@"payLoad"];
        if (!sPayload) {
            _payLoad = @"";
        } else {
            _payLoad = sPayload;
        }
        
        NSString *sPoint = [dict valueForKey:@"pointOIMethod"];
        if (!sPoint) {
            _pointOIMethod = @"";
        } else {
            _pointOIMethod = sPoint;
        }
        
        NSString *sMaster = [dict valueForKey:@"masterMerchant"];
        if (!sMaster) {
            _masterMerchant = @"";
        } else {
            _masterMerchant = sMaster;
        }
        
        NSString *sMerchantCode = [dict valueForKey:@"merchantCode"];
        if (!sMerchantCode) {
            _merchantCode = @"";
        } else {
            _merchantCode = sMerchantCode;
        }
        
        NSString *sMerchantCC = [dict valueForKey:@"merchantCC"];
        if (!sMerchantCC) {
            _merchantCC = @"";
        } else {
            _merchantCC = sMerchantCC;
        }
        
        NSString *sCCY = [dict valueForKey:@"ccy"];
        if (!sCCY) {
            _ccy = @"";
        } else {
            _ccy = sCCY;
        }
        
        NSString *sAmount = [dict valueForKey:@"amount"];
        if (!sAmount) {
            _amount = @"";
        } else {
            _amount = sAmount;
        }
        
        NSString *sCountryCode = [dict valueForKey:@"countryCode"];
        if (!sCountryCode) {
            _countryCode = @"";
        } else {
            _countryCode = sCountryCode;
        }
        
        NSString *sMerchantName = [dict valueForKey:@"merchantName"];
        if (!sMerchantName) {
            _merchantName = @"";
        } else {
            _merchantName = sMerchantName;
        }
        
        NSString *smerchantCity = [dict valueForKey:@"merchantCity"];
        if (!smerchantCity) {
            _merchantCity = @"";
        } else {
            _merchantCity = smerchantCity;
        }
        
        NSString *spinCode = [dict valueForKey:@"pinCode"];
        if (!spinCode) {
            _pinCode = @"";
        } else {
            _pinCode = spinCode;
        }
        
        NSString *saddtionalData = [dict valueForKey:@"addtionalData"];
        if (!saddtionalData) {
            _addtionalData = @"";
        } else {
            _addtionalData = saddtionalData;
        }
        
        NSString *scrc16 = [dict valueForKey:@"crc16"];
        if (!scrc16) {
            _crc16 = @"";
        } else {
            _crc16 = scrc16;
        }
        
        NSString *sstoreID = [dict valueForKey:@"storeID"];
        if (!sstoreID) {
            _storeID = @"";
        } else {
            _storeID = sstoreID;
        }
        
        NSString *sbillNumber = [dict valueForKey:@"billNumber"];
        if (!sbillNumber) {
            _billNumber = @"";
        } else {
            _billNumber = sbillNumber;
        }
        
        NSString *sterminalID = [dict valueForKey:@"terminalID"];
        if (!sterminalID) {
            _terminalID = @"";
        } else {
            _terminalID = sterminalID;
        }
        
        NSString *spurposeTemp = [dict valueForKey:@"purpose"];
        if (!spurposeTemp) {
            _purpose = @"";
        } else {
            _purpose = spurposeTemp;
        }
        
        NSString *sconsumerDataTemp = [dict valueForKey:@"consumerData"];
        if (!sconsumerDataTemp) {
            _consumerData = @"";
        } else {
            _consumerData = sconsumerDataTemp;
        }
        
        NSString *scustomerIDTemp = [dict valueForKey:@"customerID"];
        if (!scustomerIDTemp) {
            _customerID = @"";
        } else {
            _customerID = scustomerIDTemp;
        }
        
        NSString *sreferenceIDTemp = [dict valueForKey:@"referenceID"];
        if (!sreferenceIDTemp) {
            _referenceID = @"";
        } else {
            _referenceID = sreferenceIDTemp;
        }

        NSString *expDateTemp = [dict valueForKey:@"expDate"];
        if (!expDateTemp) {
            _expDate = @"";
        } else {
            _expDate = expDateTemp;
        }
        _typeQRShow = [[dict valueForKey:@"typeQRShow"] intValue];
    } else {
        _payLoad = @"";
        _pointOIMethod = @"";
        _masterMerchant = @"";
        _merchantCode = @"";
        _merchantCC = @"";
        _ccy = @"";
        _amount = @"";
        _countryCode = @"";
        _merchantName = @"";
        _merchantCity = @"";
        _pinCode = @"";
        _addtionalData = @"";
        _crc16 = @"";
        _storeID = @"";
        _billNumber = @"";
        _terminalID = @"";
        _typeQRShow = 0;
        _purpose = @"";
        _consumerData = @"";
        _customerID = @"";
        _referenceID = @"";
        _expDate = @"";
    }
}

- (void)dealloc {
    [_payLoad release];
    [_pointOIMethod release];
    [_masterMerchant release];
    [_merchantCode release];
    [_merchantCC release];
    [_ccy release];
    [_amount release];
    [_countryCode release];
    [_merchantName release];
    [_merchantCity release];
    [_pinCode release];
    [_addtionalData release];
    [_crc16 release];
    [_storeID release];
    [_billNumber release];
    [_terminalID release];
    [_purpose release];
    [_consumerData release];
    [_customerID release];
    [_referenceID release];
    [_expDate release];
    [super dealloc];
}
@end
