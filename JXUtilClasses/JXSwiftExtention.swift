
import UIKit
import Alamofire
import HandyJSON

//MARK: Global Define

let JX_SCREEN_WIDTH = UIScreen.main.bounds.size.width
let JX_SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let JX_SCREEN_BOUNDS = UIScreen.main.bounds

let hasNotch = ((JX_SCREEN_HEIGHT == 812.0 ) || (JX_SCREEN_HEIGHT  == 896.0)) ? true : false
let JX_StatusBarHeight = hasNotch ? 44.0 : 20.0
let JX_NavBarHeight = hasNotch ? 88.0 : 64.0
let JX_TabbarHeight = hasNotch ? 49.0+34.0 : 49.0
let JX_TabbarMargin = hasNotch ? 34.0 : 0

let scaleCoefficient4_7 = 375/JX_SCREEN_WIDTH

public class JXSwiftExtention {

    static func adjustFont(fontSize:CGFloat) -> (UIFont){
        
      let font =  UIFont.systemFont(ofSize: fontSize * scaleCoefficient4_7)
        
        return font
    }
    
    
    static func getBundle(bundleName:String) -> (Bundle?) {
        
        let BundlePath = Bundle.main.path(forResource: bundleName , ofType: "bundle")
        
        let bundle = Bundle(path: BundlePath ?? "")
        
        return bundle ?? nil
    }
    
    
}

open class JXBaseModel : NSObject ,HandyJSON {
    
    required override public init() {}
    
    open override var description:String{
        get{
            var dict = [String:AnyObject]()
            var count:UInt32 =  0
            let properties = class_copyPropertyList(type(of: self), &count)
            for i in 0..<count {
                let t = property_getName((properties?[Int(i)])!)
                if let n = NSString(cString: t!, encoding: String.Encoding.utf8.rawValue) as String?
                {
                    let v = self.value(forKey: n ) ?? "nil"
                    dict[n] = v as AnyObject?
                }
            }
            return "\(type(of: self)):\(dict)\n"
        }
    }
    
    open override var debugDescription:String{
        get{
            return self.description
        }
    }
}

public class JX_NetworkManager {
    
    public enum RequestType {
        case GET
        case POST
    }
    
    public enum RequestStatus {
        case SUCCESS
        case FAILURE
        case NETWORK_ERROR
        case REQ_ERROR
    }
    
    // For Alamofire
    public class func requestData(showHUD:Bool? = false , type : RequestType , URLString:String , parameters:Parameters , dataCarrier:UIScrollView? = nil , completedClosure : @escaping ((_ resulet : Any)->()) , failureClosure: @escaping (_ resulet : Any)->()) {
        
        let requestType = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        print("{====Request_Url : \(URLString)====}")
        print("{====Request_Para : \(parameters)====}")
        
        if showHUD != nil {
            //show some HUD
        }
        
        
        Alamofire.request(URLString,method: requestType , parameters: parameters).responseJSON { (response) in
            
            /* do some custom action
             SVProgressHUD.dismiss()
             
             if dataCarrier?.mj_header != nil {
             dataCarrier?.mj_header.endRefreshing()
             }
             */
            
            //判断网络状况
            guard
                let data = response.data,
                let utf8DataStr = String(data: data, encoding: .utf8)
                else{
                    
                    print("ErrorCode:\(response.result.error ?? "" as! Error)")
                    return
            }
            
            //do some error handle action or pass it to upper layer
            if let baseModel = JXBaseModel.deserialize(from: utf8DataStr){
                /*
                 if baseModel.status == 1{
                 completedClosure(utf8DataStr)
                 }else{
                 SVProgressHUD.showError(withStatus: "请求错误\nErrorCode:\(baseModel.errorCodeMsg ?? "未定义错误") ")
                 failureClosure(utf8DataStr)
                 }
                 */
            }
        }
        
        
    }
    
    
    
}


//SYSTEM CLASS EXTENTION
extension Array where Element: Equatable {
    
    //remove the objet of specified index
    mutating func remove(object: Element) {
        
        if let index = index(of: object) {
            
            remove(at: index)
        }
    }
}

//MARK: - UIApplication
extension UIApplication {
    
   open static func getPreviousController(currentViewController:UIViewController)->(UIViewController?){
        
        if currentViewController.navigationController != nil{
            let navCon = currentViewController.navigationController!
            return navCon.viewControllers[navCon.viewControllers.count - 2]
        }else{
            return nil
        }
    }
    
    
    open func activeViewController()->UIViewController?{
        
        if delegate?.window == nil {return nil}
        var normalWindow = delegate?.window!
        if normalWindow?.windowLevel != UIWindowLevelNormal {
            for obj in windows {
                if obj.windowLevel == UIWindowLevelNormal {
                    normalWindow = obj
                    break
                }
            }
        }
        
        //当最上层是弹出框时
        return p_nextTop(for: normalWindow?.rootViewController)
        
    }
    
    
    func p_nextTop(for inViewController: UIViewController?) -> UIViewController? {
        var inViewController = inViewController
        while ((inViewController?.presentedViewController) != nil) {
            inViewController = inViewController?.presentedViewController
        }
        if (inViewController is UITabBarController) {
            let selectedVC: UIViewController? = p_nextTop(for: (inViewController as? UITabBarController)?.selectedViewController)
            return selectedVC
        } else if (inViewController is UINavigationController) {
            let selectedVC: UIViewController? = p_nextTop(for: (inViewController as? UINavigationController)?.visibleViewController)
            return selectedVC
        } else {
            return inViewController
        }
    }
    
    //class end
}

//MARK: - UIColor
extension UIColor {
    
    class func RGBA_COLOR(red:CGFloat , green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor {
        
        return UIColor(red: red/255.0, green:green/255.0 , blue: blue/255.0, alpha: alpha)
        
    }
    
    class func HEX_COLOR(HEX_Value: Int , alpha:CGFloat) -> (UIColor) {
        return UIColor(red: ((CGFloat)((HEX_Value & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((HEX_Value & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(HEX_Value & 0xFF)) / 255.0,
                       alpha: alpha)
    }
}

//MARK: - UIView
extension UIView{
    
    func centerX() -> CGFloat {
        return center.x
    }
    
    func setCenterX(_ centerX: CGFloat) {
        var center: CGPoint = self.center
        center.x = centerX
        self.center = center
    }
    // Retrieve and set the center Y
    func centerY() -> CGFloat {
        return center.y
    }
    func setCenterY(_ centerY: CGFloat) {
        var center: CGPoint = self.center
        center.y = centerY
        self.center = center
    }
    // Retrieve and set the origin x
    func x() -> CGFloat {
        return frame.origin.x
    }
    func setX(_ x: CGFloat) {
        var frame: CGRect = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    // Retrieve and set the origin y
    func y() -> CGFloat {
        return frame.origin.y
    }
    
    func setY(_ y: CGFloat) {
        var frame: CGRect = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    
    // Retrieve and set the origin
    func origin() -> CGPoint {
        return frame.origin
    }
    
    func setOrigin(_ aPoint: CGPoint) {
        var newframe: CGRect = frame
        newframe.origin = aPoint
        frame = newframe
    }
    
    // Retrieve and set the size
    func size() -> CGSize {
        return frame.size
    }
    
    func setSize(_ aSize: CGSize) {
        var newframe: CGRect = frame
        newframe.size = aSize
        frame = newframe
    }
    
    // Query other frame locations
    func bottomRight() -> CGPoint {
        let x: CGFloat = frame.origin.x + frame.size.width
        let y: CGFloat = frame.origin.y + frame.size.height
        return CGPoint(x: x, y: y)
    }
    
    func bottomLeft() -> CGPoint {
        let x: CGFloat = frame.origin.x
        let y: CGFloat = frame.origin.y + frame.size.height
        return CGPoint(x: x, y: y)
    }
    
}

//MARK: - UIImage
extension UIImage{
    
    class func convertViewToImage(view:UIView) -> UIImage {
        
        let size = view.bounds.size
        
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
        
    }
    
    //渲染Image颜色
    func image(withTintColor tintColor: UIColor?) -> UIImage? {
        //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
        UIGraphicsBeginImageContextWithOptions(size, _: false, _: 0.0)
        tintColor?.setFill()
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(bounds)
        //Draw the tinted image in context
        draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
        let tintedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
    
}

//MARK: - Other Common Function
func loadNib(BundleName : String?,nibName:String) -> [Any]? {
    
    if  BundleName == nil {
         return Bundle.main.loadNibNamed(nibName, owner: nil, options: [:])
    }else{
        return JXSwiftExtention.getBundle(bundleName: BundleName!)?.loadNibNamed(nibName, owner: nil, options: [:])
    }
    
}

