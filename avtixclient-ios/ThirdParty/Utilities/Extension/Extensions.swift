//
//  Extensions.swift
//  
//
//  Created by Mapreet Kaur on 11/01/18.
//  Copyright © 2018 Vibrant appz All rights reserved.
//

import UIKit
import Dispatch
import Foundation

//--------------MARK:- NSUserDefaults Extension -
extension UserDefaults
{
    class func SFSDefault(setIntegerValue integer: Int , forKey key : String){
        UserDefaults.standard.set(integer, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func SFSDefault(setObject object: Any , forKey key : String){
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func SFSDefault(setValue object: Any , forKey key : String) {
        UserDefaults.standard.setValue(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func SFSDefault(setBool boolObject:Bool  , forKey key : String) {
        UserDefaults.standard.set(boolObject, forKey : key)
        UserDefaults.standard.synchronize()
    }
    
    class func SFSDefault(integerForKey  key: String) -> Int {
        let integerValue : Int = UserDefaults.standard.integer(forKey: key) as Int
        UserDefaults.standard.synchronize()
        return integerValue
    }
    
    class func SFSDefault(objectForKey key: String) -> Any {
        let object : Any = UserDefaults.standard.object(forKey: key)! as Any
        UserDefaults.standard.synchronize()
        return object
    }
    
    class func SFSDefault(valueForKey  key: String) -> Any {
        
        let value : Any = UserDefaults.standard.value(forKey: key)! as Any
        UserDefaults.standard.synchronize()
        return value
    }
    class func SFSDefault(boolForKey  key : String) -> Bool{
       
        let booleanValue : Bool = UserDefaults.standard.bool(forKey: key) as Bool
        UserDefaults.standard.synchronize()
        return booleanValue
    }
    
    class func SFSDefault(removeObjectForKey key: String) {
        
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    //Save no-premitive data
    class func SFSDefault(setArchivedDataObject object: Any , forKey key : String) {
        if let data  = NSKeyedArchiver.archivedData(withRootObject: object) as? Data {
            UserDefaults.standard.set(data, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    
    class func SFSDefault(getUnArchiveObjectforKey key: String) -> Any? {
        var objectValue : Any?
        if  let storedData  = UserDefaults.standard.object(forKey: key) as? Data {
            objectValue   =  NSKeyedUnarchiver.unarchiveObject(with: storedData) as Any?
            UserDefaults.standard.synchronize()
            return objectValue!;
        }
        else{
            objectValue = "" as Any?
            return objectValue!
        }
    }
}

extension UIDevice {
    
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
   
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
   
    enum ScreenType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case unknown
    }
   
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX
        default:
            return .unknown
        }
    }
}

extension UIColor {
    
    convenience public init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    class  func smNavigationBarColor()->UIColor {
        return UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
    }
    
    class  func smAppDefaultColor()->UIColor {
        return UIColor(red: 24/255, green: 73/255, blue: 213/255, alpha: 1.0)
    }
    
    class  func smGreyBorderColor()->UIColor {
        return UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0)
    }
    
    class  func sepratorHeaderColor()->UIColor {
        return UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
    }
    
    class  func sepratorDarkHeaderColor()->UIColor {
        return UIColor(red: 128.0/255.0, green: 151.0/255.0, blue: 167.0/255.0, alpha: 1.0)
    }
    
    class  func sepratorColor()->UIColor {
        return UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    }
    
    class func smPlaceHolderColor()->UIColor {
        return UIColor(red: 161.0/255.0, green: 161.0/255.0, blue: 162.0/255.0, alpha: 1.0)
    }
    
    class func smRGB(smRed r:CGFloat , smGrean g: CGFloat , smBlue b: CGFloat)->UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    class  func getRandomColor() -> UIColor{
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
    }
}

extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding + 10
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}


extension UITextField {
    
    @IBInspectable var placeholderColor: UIColor {
        get {
            guard let currentAttributedPlaceholderColor = attributedPlaceholder?.attribute(NSAttributedString.Key.foregroundColor, at: 0, effectiveRange: nil) as? UIColor else { return UIColor.clear }
            return currentAttributedPlaceholderColor
        }
        set {
            guard let currentAttributedString = attributedPlaceholder else { return }
            let attributes = [NSAttributedString.Key.foregroundColor : newValue]
            attributedPlaceholder = NSAttributedString(string: currentAttributedString.string, attributes: attributes)
        }
    }
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.isMenuVisible = false
        //do not display the menu
        return false
    }
    
    func textFieldPlaceholderColor(_ color:UIColor) {
        let attibutedStr:NSAttributedString=NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: color]);
        self.attributedPlaceholder=attibutedStr
    }
    
    func setLeftPaddingImageIcon(_ imageicon:UIImage) {
        let image1: UIImage? = imageicon
        if image1 != nil {
            let view: UIView? = UIView()
            view!.frame = CGRect(x: 0, y: 0, width:36, height: self.frame.size.height)
            let imageView = UIButton()
            imageView.frame = CGRect(x: 0, y: 0, width: 36-4, height: self.frame.size.height)
            imageView.setImage(imageicon, for: .normal)
            imageView.contentMode = .scaleAspectFit
            view?.addSubview(imageView)
            self.leftView=view
            self.leftViewMode=UITextField.ViewMode.always
            
        }
    }
    
    func setLeftPaddingView() {
        let paddingView=UIView()
        paddingView.frame=CGRect(x: 0, y: 0, width: 10, height: 30)
        self.leftView=paddingView
        self.layer.borderColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0).cgColor
        self.autocorrectionType = .no
        self.leftViewMode=UITextField.ViewMode.always
    }
    
    func setRightPaddingImageIcon(_ imageicon:UIImage) {
        let image1: UIImage? = imageicon
        if image1 != nil {
            let view: UIView? = UIView()
            view!.frame = CGRect(x: 0, y: 0, width:30 , height: self.frame.size.height)
            let imageView =  UIButton()
            imageView.frame = CGRect(x: 0, y: 0, width:30 , height: self.frame.size.height)
            imageView.setImage(imageicon, for: .normal)
            imageView.contentMode = .scaleAspectFit
            view?.addSubview(imageView)
            self.rightView = view
            self.rightViewMode = UITextField.ViewMode.always
            
        }
    }
    
    func setRightPaddingView() {
        let paddingView=UIView()
        paddingView.frame=CGRect(x: 0, y: 0, width: 10, height: 30)
        self.rightView=paddingView
        self.rightViewMode=UITextField.ViewMode.always
    }
    
    func setLeftAndRightPadding() {
        self.setLeftPaddingView()
        self.setRightPaddingView()
    }
    
    func setTextFieldRadiusCorner(_ cornerRadius:CGFloat) {
        self.layer.cornerRadius=cornerRadius;
        self.layer.masksToBounds=true;
    }
    
    func setTextFieldBoader(_ borderW:CGFloat,borderC:UIColor) {
        self.layer.borderWidth=borderW;
        self.layer.borderColor=borderC.cgColor;
    }
    
    func roundCornersView(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


//MARK :- UIView Extension

extension UIView {
    
    func makeCircular() {
        self.layer.cornerRadius = self.bounds.width/2
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.clipsToBounds = true
    }
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
    }
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner, radius: CGFloat) {
        let mask =   _round(corners: corners, radius: radius)
        self.layer.mask = mask
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }
    
    
    func addBorder(edges: UIRectEdge, color: UIColor = UIColor.white, thickness: CGFloat = 1.0) -> [UIView] {
        
        var borders = [UIView]()
        
        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["bottom": bottom]))
            borders.append(bottom)
        }
        
        return borders
    }
    
    func roundViewCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}

private extension UIView {
    
    func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
}


//MARK
//MARK :- UIButton Extension
extension UIButton {
    func btnRoundCorner() {
        self.layer.cornerRadius = 10
    }
    
    func btnCornerRadious(height : CGFloat) {
        self.layer.cornerRadius = height / 2
    }
}


//--------------MARK:- UIAlertController Extension -

let UIAlertControllerBlocksCancelButtonIndex : Int = 0;
let UIAlertControllerBlocksDestructiveButtonIndex : Int = 1;
let UIAlertControllerBlocksFirstOtherButtonIndex : Int = 2;
typealias UIAlertControllerPopoverPresentationControllerBlock = (_ popover:UIPopoverPresentationController?)->Void
typealias UIAlertControllerCompletionBlock = (_ alertController:UIAlertController?,_ action:UIAlertAction?,_ buttonIndex:Int?)->Void
extension UIAlertController {
    //MARK:- showInViewController -
    class func showInViewController(viewController:UIViewController!,withTitle title:String?,withMessage message:String?,withpreferredStyle preferredStyle:UIAlertController.Style?,cancelButtonTitle cancelTitle:String?,destructiveButtonTitle destructiveTitle:String?,otherButtonTitles otherTitles:[String?]?,popoverPresentationControllerBlock:UIAlertControllerPopoverPresentationControllerBlock?,tapBlock:UIAlertControllerCompletionBlock?) -> UIAlertController!{
        
        let strongController : UIAlertController! = UIAlertController(title: title, message: message, preferredStyle: preferredStyle!)
        strongController.view.tintColor = UIColor.black
        if (cancelTitle != nil)
        {
            let cancelAction : UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: { (action:UIAlertAction) in
                if (tapBlock != nil){
                    tapBlock!(strongController,action,UIAlertControllerBlocksCancelButtonIndex)
                }
            })
            strongController.addAction(cancelAction)
        }
        if (destructiveTitle != nil)
        {
            let destructiveAction : UIAlertAction = UIAlertAction(title: destructiveTitle, style:.destructive, handler: { (action:UIAlertAction) in
                if (tapBlock != nil){
                    tapBlock!(strongController,action,UIAlertControllerBlocksDestructiveButtonIndex)
                }
            })
            strongController.addAction(destructiveAction)
        }
        if (otherTitles != nil)
        {
            for btnx in 0..<otherTitles!.count
            {
                let otherButtonTitle:String = otherTitles![btnx]!
                
                let otherAction : UIAlertAction = UIAlertAction(title: otherButtonTitle, style: .default, handler: { (action:UIAlertAction) in
                    if (tapBlock != nil){
                        tapBlock!(strongController,action,UIAlertControllerBlocksFirstOtherButtonIndex+btnx)
                    }
                })
                strongController.addAction(otherAction)
                
            }
        }
        
        if (popoverPresentationControllerBlock != nil)
        {
            popoverPresentationControllerBlock!(strongController.popoverPresentationController!)
        }
        
        DispatchQueue.main.async {
            viewController.present(strongController, animated: true, completion:{})
        }
        
        return strongController
    }
    //MARK:- showAlertInViewController -
    class func showAlertInViewController(viewController:UIViewController!,withTitle title:String?,message:String?,cancelButtonTitle cancelTitle:String?,destructiveButtonTitle destructiveTitle:String?,otherButtonTitles otherTitles:[String?]?,tapBlock:UIAlertControllerCompletionBlock?) -> UIAlertController!{
        
        return self.showInViewController(viewController: viewController, withTitle: title, withMessage: message, withpreferredStyle:.alert, cancelButtonTitle: cancelTitle, destructiveButtonTitle: destructiveTitle, otherButtonTitles: otherTitles, popoverPresentationControllerBlock: nil, tapBlock: tapBlock)
    }
    //MARK:- showActionSheetInViewController -
    class func showActionSheetInViewController(viewController:UIViewController!,withTitle title:String?,message:String?,cancelButtonTitle cancelTitle:String?,destructiveButtonTitle destructiveTitle:String?,otherButtonTitles otherTitles:[String?]?,tapBlock:UIAlertControllerCompletionBlock?) -> UIAlertController!{
        
        return self.showInViewController(viewController: viewController, withTitle: title, withMessage: message, withpreferredStyle:.actionSheet, cancelButtonTitle: cancelTitle, destructiveButtonTitle: destructiveTitle, otherButtonTitles: otherTitles, popoverPresentationControllerBlock: nil, tapBlock: tapBlock)
    }
    class func showActionSheetInViewController(viewController:UIViewController!,withTitle title:String?,message:String?,cancelButtonTitle cancelTitle:String?,destructiveButtonTitle destructiveTitle:String?,otherButtonTitles otherTitles:[String?]?,popoverPresentationControllerBlock:UIAlertControllerPopoverPresentationControllerBlock?,tapBlock:UIAlertControllerCompletionBlock?) -> UIAlertController!{
        
        return self.showInViewController(viewController: viewController, withTitle: title, withMessage: message, withpreferredStyle:.actionSheet, cancelButtonTitle: cancelTitle, destructiveButtonTitle: destructiveTitle, otherButtonTitles: otherTitles, popoverPresentationControllerBlock: popoverPresentationControllerBlock, tapBlock: tapBlock)
    }
    
}

extension String{
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func insert(seperator: String, afterEveryXChars: Int, intoString: String) -> String {
        
        var output = ""
        intoString.enumerated().forEach { index, c in
            if index % afterEveryXChars == 0 && index > 0
            {
                output += seperator
            }
            output.append(c)
        }
        //        insert(":", afterEveryXChars: 2, intoString: "11231245")
        print(output)
        return output
    }
    func capitalizingFirstLetter() -> String {
        let first = String(prefix(1)).capitalized
        let other = String(dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement)//stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSString.CompareOptions.LiteralSearch, range: nil)
    }
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    func localizedKey() -> String {
        let strKey = self.removeWhitespace().lowercased()
        print("localization ==> \(strKey) = \(self)")
        let value = NSLocalizedString(strKey, comment: "")
        return value == strKey ? self : value
    }
}



extension UIImage {
    class func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    func addCenterConstraintsOf(item:UIView ,itemSize size:CGSize!){
        item.translatesAutoresizingMaskIntoConstraints = false
        let width : NSLayoutConstraint = NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: size.width)
        let height : NSLayoutConstraint = NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: size.height)
        let xConstraint : NSLayoutConstraint = NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint : NSLayoutConstraint = NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([width,height,xConstraint,yConstraint])
        item.setNeedsDisplay()
    }
}


extension DispatchQueue {
    static var userInteractive: DispatchQueue { return DispatchQueue.global(qos: .userInteractive) }
    static var userInitiated: DispatchQueue { return DispatchQueue.global(qos: .userInitiated) }
    static var utility: DispatchQueue { return DispatchQueue.global(qos: .utility) }
    static var background: DispatchQueue { return DispatchQueue.global(qos: .background) }
    
    func after(_ delay: TimeInterval, execute closure: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: closure)
    }
    
    func syncResult<T>(_ closure: () -> T) -> T {
        var result: T!
        sync { result = closure() }
        return result
    }
}
extension CALayer {
    var borderColorFromUIColor: UIColor {
        get {
            return UIColor.init(cgColor: self.borderColor!)
        } set {
            self.borderColor = newValue.cgColor
        }
    }
    
}
extension UIViewController{
    func showAlert(title:String? = kAlertTitle , message:String?, completion: (() -> Swift.Void)? = nil){
        _ =  UIAlertController.showAlertInViewController(viewController: self, withTitle: title, message: message, cancelButtonTitle: "ok", destructiveButtonTitle: nil, otherButtonTitles: nil) { (alert, acrtion, btnIndex) in
            if (completion != nil){
                completion!()
            }
        }
    }
    func showAlertAction(title:String? = kAlertTitle , message:String?,cancel:String = "ok", Other:String, completion: ((Int) -> Swift.Void)? = nil){
        _ =  UIAlertController.showAlertInViewController(viewController: self, withTitle: title, message: message, cancelButtonTitle: cancel, destructiveButtonTitle: nil, otherButtonTitles: [Other]) { (alert, action, btnIndex) in
            if (completion != nil){
                completion!(btnIndex!)
            }
        }
    }
}
extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String, size: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Arial-BoldMT", size: size)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String, size: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Arial", size: size)!]
        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(normalString)
        
        return self
    }
}
