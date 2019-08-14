//
//  AmountTextField.h
//  ViMASS
//
//  Created by Chung NV on 3/29/13.
//
//

#import "ExTextField.h"

typedef BOOL (^AmountBlockValidate)(double amount);

@interface AmountTextField : ExTextField
-(NSString *) getAmount;
-(void) addAmountConstraintWithBlock:(AmountBlockValidate ) amountValidate
              withErrorMessage:(NSString *) messageError;

@end
