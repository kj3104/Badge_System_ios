//
//  BadgeCreateDetailViewController.swift
//  BadgeSystem
//
//  Created by Kaji Satoshi on 2016/10/29.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import UIKit

class BadgeCreateDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var badgeCat = "academy"
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailField: UIPlaceHolderTextView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var underActiveFieldRect = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        detailField.delegate = self
        
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.white.cgColor
        detailField.layer.borderWidth = 1
        detailField.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
        let topColor = UIColor(red:151/255, green:233/255, blue:81/255, alpha:1)
        let bottomColor = UIColor(red:206/255, green:233/255, blue:0, alpha:1)
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        detailField.placeHolder = "詳細"
        detailField.placeHolderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        selectedImage.image = UIImage(named: badgeCat)
        NotificationCenter.default.addObserver(self, selector: #selector(shownKeyboard), name:Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hiddenKeyboard), name:Notification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == nameField {
            underActiveFieldRect = detailField.frame
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == detailField{
            underActiveFieldRect = nextButton.frame
        }
        return true
    }
    
    func shownKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] {
                scrollView.contentInset = UIEdgeInsets.zero
                scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
                let convertedKeyboardFrame = scrollView.convert(keyboardFrame, from: nil)
                let offsetY: CGFloat =  underActiveFieldRect.maxY - convertedKeyboardFrame.minY + 15
                if offsetY < 0 {
                    return
                }
                updateScrollViewSize(moveSize: offsetY, duration: animationDuration as! TimeInterval)
                
            }
        }
    }
    
    func hiddenKeyboard(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        
    }
    
    func updateScrollViewSize(moveSize: CGFloat, duration: TimeInterval) {
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(duration)
        
        let contentInsets = UIEdgeInsetsMake(0, 0, moveSize, 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.contentOffset = CGPoint(x: 0,y :moveSize)
        UIView.commitAnimations()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func OnNext(_ sender: AnyObject) {
        CreateBadgeManager.sharedManager.name = nameField.text!
        CreateBadgeManager.sharedManager.desc = detailField.text!
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let detail = storyboard.instantiateViewController(withIdentifier: "CreateBadgeTo") as! BadgeCreateDestiantionViewController
        self.navigationController?.pushViewController(detail, animated: true)
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
