//
//  EUIView.swift
//  Forward_iOs
//
//  Created by Joe on 20 Sep.
//  Copyright © 2018 Giovanni Simonicca. All rights reserved.
//

import UIKit

extension UIView{
    @objc public func all_sub_views() -> [UIView]{
        var ret : [UIView] = []
        for sub_view in subviews{
            ret.append(sub_view)
            let sub = sub_view.all_sub_views()
            ret.append(contentsOf: sub)
        }
        return ret;
    }
    public func hide_view(){
        if self.isHidden == false {
            self.isHidden = true
        }
    }
    public func show_view(){
        if self.isHidden == true {
            self.isHidden = false
        }
    }
    public func hide(_ hide: Bool = true){
        if self.isHidden != hide {
            self.isHidden = hide
        }
    }
    
    public func show(_ show: Bool = true){
        hide(!show)
    }
    
    public func removeLayerAnimationsRecursively() {
        layer.removeAllAnimations()
        subviews.forEach { $0.removeLayerAnimationsRecursively() }
    }
    
    public func setAnchorPoint(anchorPoint: CGPoint) {
        let view = self
        var newPoint = CGPoint(x:view.bounds.size.width * anchorPoint.x, y:view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x:view.bounds.size.width * view.layer.anchorPoint.x, y:view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }

}
extension UIView{
    public func safe_layout() -> UILayoutGuide? {
        guard let super_view = self.superview else {
            //ALog.log_warn("missing superview safe_layout")
            return nil
        }
        translatesAutoresizingMaskIntoConstraints = false
        if let scroll = super_view as? UIScrollView {
            return scroll.contentLayoutGuide
        }
        return super_view.safeAreaLayoutGuide
    }
    
    @discardableResult public func util_align(top : CGFloat? = nil,
                                       bottom: CGFloat? = nil,
                                       left: CGFloat? = nil,
                                       right: CGFloat? = nil,
                                       width: CGFloat? = nil,
                                       height: CGFloat? = nil,
                                       center_x: CGFloat? = nil,
                                       center_y: CGFloat? = nil) -> [NSLayoutConstraint]{
        translatesAutoresizingMaskIntoConstraints = false
        
        var ret = [NSLayoutConstraint]()
        if let topx = top {
            if let a = util_align_top_anchor(pixel: topx) {
                ret.append(a)
            }
        }
        
        if let bottomx = bottom {
            if let a = util_align_bottom_anchor(pixel: bottomx) {
                ret.append(a)
            }
        }
        
        if let lefx = left {
            if let a = util_align_left_anchor(pixel: lefx) {
                ret.append(a)
            }
        }
        
        if let righx = right {
            if let a = util_align_right_anchor(pixel: righx){
                ret.append(a)
            }
        }
        
        if let wx = width {
            let a = util_width_anchor(pixel: wx)
            ret.append(a)
        }
        
        if let hx = height {
            let a = util_height_anchor(pixel: hx)
            ret.append(a)
            
        }
        
        if let center_xx = center_x {
            if let a = util_align_center_x_anchor(pixel: center_xx) {
                ret.append(a)
            }
        }

        if let center_yy = center_y {
            if let a = util_align_center_y_anchor(pixel: center_yy) {
                ret.append(a)
            }
        }

        return ret
    }
    
    @objc public func util_fill_superview(){
        guard let safe = safe_layout() else {
            return
        }
        widthAnchor.constraint(equalTo: safe.widthAnchor,     constant: 0).isActive = true
        heightAnchor.constraint(equalTo: safe.heightAnchor,   constant: 0).isActive = true
        centerXAnchor.constraint(equalTo: safe.centerXAnchor, constant: 0).isActive = true
        centerYAnchor.constraint(equalTo: safe.centerYAnchor, constant: 0).isActive = true
    }

    @discardableResult @objc public func util_align_center_x_anchor(pixel: CGFloat = 0) -> NSLayoutConstraint?{
        guard let safe = safe_layout() else {
            return nil
        }
        let a = centerXAnchor.constraint(equalTo: safe.centerXAnchor, constant: pixel)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc public func util_align_center_y_anchor(pixel: CGFloat = 0) -> NSLayoutConstraint?{
        guard let safe = safe_layout() else {
            return nil
        }
        let a = centerYAnchor.constraint(equalTo: safe.centerYAnchor, constant: pixel)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc public func util_fill_height_anchor(safe_area: Bool = true) -> NSLayoutConstraint?{
        if !safe_area {
            guard let super_view = self.superview else {
                //ALog.log_warn("missing superview")
                return nil
            }
            translatesAutoresizingMaskIntoConstraints = false
            let a : NSLayoutConstraint = heightAnchor.constraint(equalTo: super_view.heightAnchor, constant: 0)
            a.isActive = true
            return a
        }
        guard let safe = safe_layout() else {
            return nil
        }
        let a : NSLayoutConstraint = heightAnchor.constraint(equalTo: safe.heightAnchor, constant: 0)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc public func util_fill_width_anchor() -> NSLayoutConstraint?{
        guard let safe = safe_layout() else {
            return nil
        }
        let a : NSLayoutConstraint = widthAnchor.constraint(equalTo: safe.widthAnchor, constant: 0)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc public func  util_fill_width_anchor(safe_area: Bool = true) -> NSLayoutConstraint?{
        if !safe_area {
            guard let super_view = self.superview else {
                //ALog.log_warn("missing superview util_fill_width_anchor")
                return nil
            }
            translatesAutoresizingMaskIntoConstraints = false
            let a : NSLayoutConstraint = widthAnchor.constraint(equalTo: super_view.widthAnchor, constant: 0)
            a.isActive = true
            return a
        }
        guard let safe = safe_layout() else {
            return nil
        }
        let a : NSLayoutConstraint = widthAnchor.constraint(equalTo: safe.widthAnchor, constant: 0)
        a.isActive = true
        return a
    }

    
    @discardableResult @objc public func util_align_bottom_anchor(pixel : CGFloat, safe_area: Bool = true) -> NSLayoutConstraint?{
        if !safe_area {
            guard let super_view = self.superview else {
                ////ALog.log_warn("missing superview util_align_bottom_anchor")
                return nil
            }
            translatesAutoresizingMaskIntoConstraints = false
            let a : NSLayoutConstraint = bottomAnchor.constraint(equalTo: super_view.bottomAnchor, constant: -pixel)
            a.isActive = true
            return a
        }
        
        guard let safe = safe_layout() else {
            return nil
        }
        let a : NSLayoutConstraint = bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -pixel)
        a.isActive = true
        return a
    }
    
    
    @discardableResult @objc public func util_align_top_anchor(pixel : CGFloat, safe_area: Bool = true) -> NSLayoutConstraint?{
        if !safe_area {
            guard let super_view = self.superview else {
                //ALog.log_warn("missing superview util_align_top_anchor")
                return nil
            }
            translatesAutoresizingMaskIntoConstraints = false
            let a : NSLayoutConstraint = topAnchor.constraint(equalTo: super_view.topAnchor, constant: -pixel)
            a.isActive = true
            return a
        }
        guard let safe = safe_layout() else {
            return nil
        }
        let a : NSLayoutConstraint = topAnchor.constraint(equalTo: safe.topAnchor, constant: pixel)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc public func util_align_left_anchor(pixel : CGFloat, safe_area: Bool = true) -> NSLayoutConstraint?{
        if !safe_area {
            guard let super_view = self.superview else {
                //ALog.log_warn("missing superview util_align_left_anchor")
                return nil
            }
            translatesAutoresizingMaskIntoConstraints = false
            let a : NSLayoutConstraint = leftAnchor.constraint(equalTo: super_view.leftAnchor, constant: -pixel)
            a.isActive = true
            return a
        }
        guard let safe = safe_layout() else {
            return nil
        }
        let a : NSLayoutConstraint = leftAnchor.constraint(equalTo: safe.leftAnchor, constant: pixel)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc public func util_align_right_anchor(pixel : CGFloat, safe_area: Bool = true) -> NSLayoutConstraint?{
        if !safe_area {
            guard let super_view = self.superview else {
                //ALog.log_warn("missing superview util_align_right_anchor")
                return nil
            }
            translatesAutoresizingMaskIntoConstraints = false
            let a : NSLayoutConstraint = rightAnchor.constraint(equalTo: super_view.rightAnchor, constant: -pixel)
            a.isActive = true
            return a
        }
        guard let safe = safe_layout() else {
            return nil
        }
        let a : NSLayoutConstraint = rightAnchor.constraint(equalTo: safe.rightAnchor, constant: -pixel)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc public func util_height_anchor(pixel : CGFloat) -> NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let a : NSLayoutConstraint = heightAnchor.constraint(equalToConstant: pixel)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc public func util_height_anchor_less_than(pixel : CGFloat) -> NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let a : NSLayoutConstraint = heightAnchor.constraint(lessThanOrEqualToConstant: pixel)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc public func util_width_anchor(pixel : CGFloat) -> NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let a : NSLayoutConstraint = widthAnchor.constraint(equalToConstant: pixel)
        a.isActive = true
        return a
    }

    @discardableResult @objc public func util_width_anchor_less_than(pixel : CGFloat) -> NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let a : NSLayoutConstraint = widthAnchor.constraint(lessThanOrEqualToConstant: pixel)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc public func util_width_anchor_greater_than(pixel : CGFloat) -> NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let a : NSLayoutConstraint = widthAnchor.constraint(greaterThanOrEqualToConstant: pixel)
        a.isActive = true
        return a
    }

    @discardableResult @objc public func util_align_top_anchor_to_bottom_of_view(view: UIView, pixel : CGFloat) -> NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let a : NSLayoutConstraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: pixel)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc func util_align_bottom_anchor_to_bottom_of_view(view: UIView, pixel : CGFloat) -> NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let a : NSLayoutConstraint = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -pixel)
        a.isActive = true
        return a
    }

    @discardableResult @objc public func util_align_top_anchor_to_top_of_view(view: UIView, pixel : CGFloat) -> NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let a : NSLayoutConstraint = topAnchor.constraint(equalTo: view.topAnchor, constant: pixel)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc public func util_align_bottom_anchor_to_top_of_view(view: UIView, pixel : CGFloat) -> NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let a : NSLayoutConstraint = bottomAnchor.constraint(equalTo: view.topAnchor, constant: pixel)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc func util_align_right_anchor_to_left_of_view(view: UIView, pixel : CGFloat) -> NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let a : NSLayoutConstraint = rightAnchor.constraint(equalTo: view.leftAnchor, constant: -pixel)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc public func util_align_right_anchor_to_right_of_view(view: UIView, pixel : CGFloat) -> NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let a : NSLayoutConstraint = rightAnchor.constraint(equalTo: view.rightAnchor, constant: pixel)
        a.isActive = true
        return a
    }
    
    
    @discardableResult @objc public func util_align_left_anchor_to_right_of_view(view: UIView, pixel : CGFloat) -> NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let a : NSLayoutConstraint = leftAnchor.constraint(equalTo: view.rightAnchor, constant: pixel)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc public func util_align_left_anchor_to_left_of_view(view: UIView, pixel : CGFloat) -> NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        let a : NSLayoutConstraint = leftAnchor.constraint(equalTo: view.leftAnchor, constant: pixel)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc public func util_align_center_x_anchor_to_center_x_of_view(view: UIView, pixel : CGFloat) -> NSLayoutConstraint?{
        translatesAutoresizingMaskIntoConstraints = false
        let a : NSLayoutConstraint = centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: pixel)
        a.isActive = true
        return a
    }
    
    @discardableResult @objc public func util_align_center_y_anchor_to_center_y_of_view(view: UIView, pixel : CGFloat) -> NSLayoutConstraint?{
        translatesAutoresizingMaskIntoConstraints = false
        let a : NSLayoutConstraint = centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: pixel)
        a.isActive = true
        return a
    }
}

extension UIView {
    public func setShadowWithCornerRadius(corners : CGFloat){
        self.layer.cornerRadius = corners
        let shadowPath2             = UIBezierPath(rect: self.bounds)
        self.layer.masksToBounds    = false
        self.layer.shadowColor      = UIColor.lightGray.cgColor
        self.layer.shadowOffset     = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
        self.layer.shadowOpacity    = 0.5
        self.layer.shadowPath       = shadowPath2.cgPath
    }
}
