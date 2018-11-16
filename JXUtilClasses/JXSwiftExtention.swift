
import UIKit

//MARK: - 

public final class JxUtils<Base> {
    public var base: Base
    public init(_ base : Base){
        self.base = base
    }
}

public protocol JxUtilsCompatiable {
    
    associatedtype Compatiabvarype
    var Jx: Compatiabvarype { get }
    static var JxClass: Compatiabvarype.Type { get }
}

public extension JxUtilsCompatiable {
    
    public var Jx: JxUtils<Self> {
        return JxUtils(self)
    }
    public static var JxClass: JxUtils<Self>.Type {
        return JxUtils<Self>.self
    }
}

extension NSObject: JxUtilsCompatiable { }

extension JxUtils where Base : UIImage{
    
}



//SYSTEM CLASS EXTENTION

//MARK: - Array
extension Array where Element: Equatable {
    
    mutating func remove(object: Element) {
        
        if let index = index(of: object) {
            
            remove(at: index)
        }
    }
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
    
}

//MARK: - UIView
extension UIView {
    
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


//MARK: - Other Common Function

func SCREEN_WIDTH() -> CGFloat{
    return UIScreen.main.bounds.size.width
}

func SCREEN_HEIGHT() -> CGFloat{
    return UIScreen.main.bounds.size.height
}

func SCREEN_BOUNDS() -> CGRect{
    return UIScreen.main.bounds
}

func loadNib(nibName:String) -> [Any]? {
    
  return Bundle.main.loadNibNamed(nibName, owner: nil, options: [:])
    
}

