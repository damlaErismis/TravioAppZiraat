//
//  Extentions.swift
//  TravioProject
//
//  Created by Burak Özer on 13.10.2023.
//

import Foundation
import UIKit
import Foundation
import SwiftUI

// MARK: Font Status
enum FontStatus {
    
    case poppinsRegular10
    case poppinsRegular12
    case poppinsRegular14
    case poppinsRegular16
    case poppinsLight10
    case poppinsLight14
    case poppinsLight16
    case poppinsMedium12
    case poppinsMedium14
    case poppinsMedium20
    case poppinsMedium24
    case poppinsSemiBold30
    case poppinsSemiBold16
    case poppinsSemiBold14
    case poppinsSemiBold24
    case poppinsSemiBold32
    case poppinsSemiBold36
    case poppinsBold30

    var defineFont:UIFont? {
        switch self {
        case .poppinsRegular10:
            return UIFont(name: "Poppins-Regular", size: 10)
        case .poppinsRegular12:
            return UIFont(name: "Poppins-Regular", size: 12)
        case .poppinsRegular14:
            return UIFont(name: "Poppins-Regular", size: 14)
        case .poppinsRegular16:
            return UIFont(name: "Poppins-Regular", size: 16)
        case .poppinsLight10:
            return UIFont(name:"Poppins-Light", size: 10)
        case .poppinsLight14:
            return UIFont(name:"Poppins-Light", size: 14)
        case .poppinsLight16:
            return UIFont(name:"Poppins-Light", size: 16)
        case .poppinsMedium12:
            return UIFont(name: "Poppins-Medium", size: 12)
        case .poppinsMedium14:
            return UIFont(name: "Poppins-Medium", size: 14)
        case .poppinsMedium20:
            return UIFont(name: "Poppins-Medium", size: 20)
        case .poppinsMedium24:
            return UIFont(name: "Poppins-Medium", size: 24)
        case .poppinsSemiBold30:
            return UIFont(name:"Poppins-SemiBold", size: 30)
        case .poppinsSemiBold14:
            return UIFont(name: "Poppins-SemiBold", size: 14)
        case .poppinsSemiBold16:
            return UIFont(name: "Poppins-SemiBold", size: 16)
        case .poppinsSemiBold24:
            return UIFont(name: "Poppins-SemiBold", size: 24)
        case .poppinsSemiBold32:
            return UIFont(name: "Poppins-SemiBold", size: 32)
        case .poppinsSemiBold36:
            return UIFont(name: "Poppins-SemiBold", size: 36)
        case .poppinsBold30:
            return UIFont(name: "Poppins-Bold", size: 30)
        }
    }
}

// MARK: Corner Mask
extension CACornerMask {
    static let bottomLeft = CACornerMask.layerMinXMaxYCorner
    static let bottomRight = CACornerMask.layerMaxXMaxYCorner
    static let topLeft = CACornerMask.layerMinXMinYCorner
    static let topRight = CACornerMask.layerMaxXMinYCorner
    
}

extension UIView {
    // For insert layer in Foreground
    func addBlackGradientLayerInForeground(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        self.layer.addSublayer(gradient)
    }
    // For insert layer in background
    func addBlackGradientLayerInBackground(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func dropShadow() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 2, height: 4)
        self.layer.shadowRadius = 5
    }
}

// MARK: UIColor
extension UIColor {
    
    static let viewColor = UIColor(hexString: "#F8F8F8")
    static let fontColor = UIColor(hexString: "#3d3d3d")
    static let mainColor = UIColor(hexString: "#38ada9")
    static let textButtonColor = UIColor(hexString: "#17C0EB")
    static let grayText = UIColor(hexString: "#999999")
    static let darkGrayText = UIColor(hexString: "#3c3c3c")
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


// MARK: - Format Type
enum FormatType:String {
    case longFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case longWithoutZone = "yyyy-MM-dd'T'HH:mm:ss"
    case withoutYear = "dd MMMM"
    case localeStandard = "dd.MM.yyyy"
    case standard = "yyyy-MM-dd"
    case dateAndTime = "dd.MM.yyyy'T'HH:mm"
    case time = "HH:mm"
}

// MARK: - Font Type
enum FontType:String {
    case bold = "Bold"
    case medium = "Medium"
}

// MARK: - UIStack View
extension UIStackView {
    func addArrangedSubviews(_ view: UIView...) {
        view.forEach({ v in
            self.addArrangedSubview(v)
        })
    }
}

// MARK: - UIView
extension UIView {

    /// Add multiple subview to a view.
    /// - Parameter view: It is a subviews array which add to parent view
    func addSubviews(_ view: UIView...) {
        view.forEach({ v in
            self.addSubview(v)
        })
    }
    
    func roundAllCorners(radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addShadow(shadowColor: UIColor,
                   offsetX: CGFloat, offsetY: CGFloat,
                   shadowOpacity: Float,
                   shadowRadius: CGFloat) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }
    
    @available(iOS 13, *)
    private struct Preview: UIViewRepresentable {
        typealias UIViewType = UIView
        let view: UIView
        func makeUIView(context: Context) -> UIView {
            return view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
        }
    }
    
    @available(iOS 13, *)
    func showPreview() -> some View {
        // inject self (the current UIView) for the preview
        Preview(view: self)
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.duration = 0.4
        animation.values = [-10.0, 5.0, -5.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
    
    func addView() ->UIView{
        let view = UIView()
        self.addSubview(view)
        return view
    }
    
    func addLabel(text:String? = nil, fontSize: CGFloat = 14, fontType:FontType = .medium, color:UIColor = .black, align:NSTextAlignment = .left) ->UILabel {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-\(fontType.rawValue)", size: fontSize)
        label.textColor = color
        label.text = text
        self.addSubview(label)
        return label
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func animateBorderColor(toColor: UIColor, duration: Double) {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = toColor.cgColor
        animation.duration = duration
        layer.add(animation, forKey: "borderColor")
        layer.borderColor = toColor.cgColor
    }
    
    func addDashedBorder(color: UIColor) {
        let color = color.cgColor
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width-2, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: (frameSize.width / 2), y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [4, 4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0).cgPath
        self.layer.addSublayer(shapeLayer)
    }
    
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }
    
    var globalPoint :CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}

// MARK: - UITextField
extension UITextField {
    
    enum TextType {
        case emailAddress
        case password
        case generic
    }
    
    var textType: TextType {
        get {
            if keyboardType == .emailAddress {
                return .emailAddress
            } else if isSecureTextEntry {
                return .password
            }
            return .generic
        }
        set {
            switch newValue {
            case .emailAddress:
                keyboardType = .emailAddress
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = false
                
            case .password:
                keyboardType = .asciiCapable
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = true
                
            case .generic:
                isSecureTextEntry = false
            }
        }
    }
    
    var placeholder: String? {
        get {
            attributedPlaceholder?.string
        }
        
        set {
            guard let newValue = newValue else {
                attributedPlaceholder = nil
                return
            }
            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray]
            let attributedText = NSAttributedString(string: newValue, attributes: attributes)
            attributedPlaceholder = attributedText
        }
    }
    
    var hasValidEmail: Bool {
        
        return text!.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                           options: String.CompareOptions.regularExpression,
                           range: nil, locale: nil) != nil
    }
    
    var leftViewTintColor: UIColor? {
        get {
            guard let iconView = leftView as? UIImageView else { return nil }
            return iconView.tintColor
        }
        set {
            guard let iconView = leftView as? UIImageView else { return }
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = newValue
        }
    }
    
    func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: 18 + padding, height: 18))
        let imageView = UIImageView(image: image)
        imageView.frame = iconView.bounds
        imageView.contentMode = .scaleAspectFit
        iconView.addSubview(imageView)
        leftView = iconView
        leftViewMode = .always
    }
}

extension UIButton {
    
    func centerTextAndImage(imageAboveText: Bool = false, spacing: CGFloat) {
        if imageAboveText {
            
            guard
                let imageSize = imageView?.image?.size,
                let text = titleLabel?.text,
                let font = titleLabel?.font else { return }
            let titleSize = text.size(withAttributes: [.font: font])

            let titleOffset = -(imageSize.height + spacing)
            titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: titleOffset, right: 0.0)
            
            let imageOffset = -(titleSize.height + spacing)
            imageEdgeInsets = UIEdgeInsets(top: imageOffset, left: 0.0, bottom: 0.0, right: -titleSize.width)
            
            let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
            contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
        } else {
            let insetAmount = spacing / 2
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }
    
}

// MARK: - UIViewController

extension UIViewController {
    @available(iOS 13, *)
    private struct Preview: UIViewControllerRepresentable {
        
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    @available(iOS 13, *)
    func showPreview() -> some View {
        Preview(viewController: self)
    }
    
    func addChild(this child: UIViewController, contentView:UIView ) {
        addChild(child)
        contentView.addSubview(child.view)
        
        UIView.transition(with: contentView, duration: 0.5, options: .curveLinear, animations: {
            child.didMove(toParent: self)
        }, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeChildFromParent() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

// MARK: - String

extension String {
    
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    var isValidPassword:Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{6,8}"
        
        /*       Minimum 6 and Maximum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
         */
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    
    func maskToPhoneNumber() -> String {
        let isMoreThanTenDigit = self.count > 10
        _ = self.startIndex
        var newstr = ""
        if isMoreThanTenDigit {
            newstr = "\(self.dropFirst(self.count - 10))"
        }
        else if self.count == 10{
            newstr = "\(self)"
        }
        else {
            return "number has only \(self.count) digits"
        }
        
        if  newstr.count == 10 {
            let internationalString = "\(newstr.dropLast(7)) \(newstr.dropLast(4).dropFirst(3)) \(newstr.dropFirst(6).dropLast(2)) \(newstr.dropFirst(8))"
            newstr = internationalString
        }
        
        return newstr
    }
    
    /// It formats a String Value to Date easily.
    /// - Parameter formatType: If method is called without parameters, it formats string with standard format style(dd.MM.yyyy). If you want to define another format you can it.
    /// .standard = dd.MM.yyyy -> 28.02.2020
    /// .longDate = yyyy-MM-dd'T'HH:mm:ss.SSSZ -> 2021-01-28 14:00:00.000
    /// .withoutYear = "dd MMMM" -> 27 April
    /// .dateAndTime = "dd.MM.yyyy'T'HH:mm" 27.01.2021 14:00
    /// - Returns: Method returns formatted date from String that define by user.
    func formatToDate(formatType: FormatType = .localeStandard)-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "tr")
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = formatType.rawValue
        let date = dateFormatter.date(from: self)
        
        return date
    }
    
}

// MARK: - User Defaults
extension UserDefaults {
    
    enum Keys: String, CaseIterable {
        case tokenObject
        case currentUser
    }
    
    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }
    
    func setEncodedObject<T:Codable>(object:T,key:Keys) {
        
        if let encoded = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(encoded, forKey: key.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getEncodedObject<T:Codable>(key:Keys, object:T.Type) -> T?{
        if let data = UserDefaults.standard.data(forKey: key.rawValue), let dataObject = try? JSONDecoder().decode(object, from: data) {
            return dataObject
        }
        return nil
    }
}

// MARK: - UIDatePicker
extension UIDatePicker {
    
    public var roundedDate: Date {
        let referenceTimeInterval = self.date.timeIntervalSinceReferenceDate
        let remainingSeconds = referenceTimeInterval.truncatingRemainder(dividingBy: TimeInterval(minuteInterval*60))
        let timeRoundedToInterval = referenceTimeInterval - remainingSeconds
        return Date(timeIntervalSinceReferenceDate: timeRoundedToInterval)
    }
}

// MARK: - Date
extension Date {
    
    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month], from: self)
        components.hour = 3
        return  calendar.date(from: components)!
    }
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    
    func formatToString(formatType:FormatType = .localeStandard)-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatType.rawValue
        formatter.locale = Locale(identifier: "tr")
        return formatter.string(from: self)
    }
}

// MARK: - Optional
extension Optional {
    
    func ifNil(_ default:Wrapped) -> Wrapped {
        return self ?? `default`
    }
}

// MARK: - Array
extension Array {
    
    public subscript(safe index: Int) -> Element? {
        guard startIndex <= index && index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}

extension UIImageView{
    func animateImage(_ image: UIImage?, animated: Bool = true) {
        let duration = animated ? 0.3 : 0.0
        UIView.transition(with: self, duration: duration, options: .curveEaseIn, animations: {
            self.image = image
        }, completion: nil)
    }
}

// MARK: -UIImage
extension UIImage {
    
    class func colorToImage(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 2.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

// MARK: - UIWindow

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

// MARK: - CALayer

extension CALayer {
    func addShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        self.shadowColor = color.cgColor
        self.shadowOpacity = opacity
        self.shadowOffset = offset
        self.shadowRadius = radius
    }
}

class VerticalAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        var newRect = rect
        switch contentMode {
        case .top:
            newRect.size.height = sizeThatFits(rect.size).height
        case .bottom:
            let height = sizeThatFits(rect.size).height
            newRect.origin.y += rect.size.height - height
            newRect.size.height = height
        default:
            ()
        }
        super.drawText(in: newRect)
    }
}

