//
//  MainViewController.swift
//  PayPal-iOS-SDK-Sample-App
//
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit


class PayPalViewController: BaseViewController, PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate {

  var moneyQuantity:NSString!
  var method:NSString!
  var is_buy:Bool = false
  var dictCls: NSDictionary!
  var api: AppApi!
   var barBackBtn :UIBarButtonItem!
  var environment:String = PayPalEnvironmentSandbox

  var acceptCreditCards: Bool = true {
    didSet {
      payPalConfig.acceptCreditCards = acceptCreditCards
    }
  }
  var resultText = "" // empty
  var payPalConfig = PayPalConfiguration() // default

  @IBOutlet weak var successView: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    
     api = AppApi.sharedClient()
    // Do any additional setup after loading the view.
    title = "PayPal"

    // Set up payPalConfig
    payPalConfig.acceptCreditCards = acceptCreditCards;
    payPalConfig.merchantName = "Tonguer"
    payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
    payPalConfig.merchantUserAgreementURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")

    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    payPalConfig.languageOrLocale = NSLocale.preferredLanguages()[0] as! String

    // Setting the payPalShippingAddressOption property is optional.
    payPalConfig.payPalShippingAddressOption = .PayPal;

    println("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
    if(method.isEqualToString("payment")){
      moneyQuantity = NSString(format: "%i",(dictCls.objectForKey("price")?.integerValue)!)
       self.tougerPaypal()
    }else if(method.isEqualToString("charge")){
      self.tougerPaypal()
    }
   
  }

  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    PayPalMobile.preconnectWithEnvironment(environment)
  }


  // MARK: Memory

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: Single Payment
  func tougerPaypal() {
    // Remove our last completed payment, just for demo purposes.
    resultText = ""

    // Optional: include multiple items
    var item1 = PayPalItem(name: "course", withQuantity: 1, withPrice: NSDecimalNumber(string: self.moneyQuantity as? String), withCurrency: "USD", withSku: "Hip-0037")

    let items = [item1]
    let subtotal = PayPalItem.totalPriceForItems(items)

    // Optional: include payment details
    let shipping = NSDecimalNumber(string: "0.00")
    let tax = NSDecimalNumber(string: "0.00")
    let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)

    let total = subtotal.decimalNumberByAdding(shipping).decimalNumberByAdding(tax)
    let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Tonguer", intent: .Sale)

    payment.items = items
    payment.paymentDetails = paymentDetails

    if (payment.processable) {
      let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
      presentViewController(paymentViewController, animated: true, completion: nil)
    }
    else {
      // This particular payment will always be processable. If, for
      // example, the amount was negative or the shortDescription was
      // empty, this payment wouldn't be processable, and you'd want
      // to handle that here.
      println("Payment not processalbe: \(payment)")
    }
  }

  // PayPalPaymentDelegate

  func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
    println("PayPal Payment Cancelled")
    resultText = ""
    paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
    self.navigationController!.popToViewController(viewControllers[1], animated: true);
  }

  func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
    println("PayPal Payment Success !")
    paymentViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
      // send completed confirmaion to your server
      println("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
      self.resultText = completedPayment!.description
     
      self.showSuccess()
      //self.navigationController?.popToViewController(, animated: <#Bool#>))(true)
    })
  }


  // MARK: Future Payments

  @IBAction func authorizeFuturePaymentsAction(sender: AnyObject) {
    let futurePaymentViewController = PayPalFuturePaymentViewController(configuration: payPalConfig, delegate: self)
    presentViewController(futurePaymentViewController, animated: true, completion: nil)
  }


  func payPalFuturePaymentDidCancel(futurePaymentViewController: PayPalFuturePaymentViewController!) {
    println("PayPal Future Payment Authorizaiton Canceled")
    successView.hidden = true
    //futurePaymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
    self.navigationController!.popToViewController(viewControllers[1], animated: true);
  }

  func payPalFuturePaymentViewController(futurePaymentViewController: PayPalFuturePaymentViewController!, didAuthorizeFuturePayment futurePaymentAuthorization: [NSObject : AnyObject]!) {
    println("PayPal Future Payment Authorization Success!")
    // send authorizaiton to your server to get refresh token.
    futurePaymentViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
      self.resultText = futurePaymentAuthorization!.description
      self.showSuccess()
    })
  }

//  // MARK: Profile Sharing
//
//  @IBAction func authorizeProfileSharingAction(sender: AnyObject) {
//    let scopes = [kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]
//    let profileSharingViewController = PayPalProfileSharingViewController(scopeValues: NSSet(array: scopes), configuration: payPalConfig, delegate: self)
//    presentViewController(profileSharingViewController, animated: true, completion: nil)
//  }

  // PayPalProfileSharingDelegate

  func userDidCancelPayPalProfileSharingViewController(profileSharingViewController: PayPalProfileSharingViewController!) {
    println("PayPal Profile Sharing Authorization Canceled")
    successView.hidden = true
    profileSharingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }

  func payPalProfileSharingViewController(profileSharingViewController: PayPalProfileSharingViewController!, userDidLogInWithAuthorization profileSharingAuthorization: [NSObject : AnyObject]!) {
    println("PayPal Profile Sharing Authorization Success!")

    // send authorization to your server

    profileSharingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
      self.resultText = profileSharingAuthorization!.description
      self.showSuccess()
    })
  }

  // MARK: Helpers
  func showSuccess() {
    if(method.isEqualToString("charge")){
      UserUpadteApiCall()
    }else if(method.isEqualToString("payment")){
      paypalApiCall()
    }
    
  }
  //****** Update User Recodes ans Api call ************
  func UserUpadteApiCall(){
    
    var aParam:NSMutableDictionary = NSMutableDictionary()
    aParam.setValue(self.auth_token[0], forKey: "auth-token")
    aParam.setValue(moneyQuantity, forKey: "user[money]")
    
    self.api.updateUser(aParam as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      var dict = responseObject?.valueForKey("user") as! NSDictionary
      //var userDict = dict.valueForKey("user") as NSDictionary
      CommonUtilities.addUserInformation(dict)
      let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
      self.navigationController!.popToViewController(viewControllers[1], animated: true);
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }

  
  //****** Paypal Api call ************
  func paypalApiCall(){
     self.is_buy = true
    var aParam:NSMutableDictionary = NSMutableDictionary()
    aParam.setValue(self.auth_token[0], forKey: "auth-token")
    aParam.setValue(dictCls.valueForKey("id"), forKey: "class_id")
    aParam.setValue(is_buy, forKey: "is_buy")
    
    self.api.paypalApi(aParam as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
      self.navigationController!.popToViewController(viewControllers[1], animated: true);
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
    
  }

  
  
  
}
