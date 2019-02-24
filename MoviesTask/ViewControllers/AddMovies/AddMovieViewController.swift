//
//  AddMovieViewController.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/23/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import UIKit

class AddMovieViewController: UIViewController {
    
    var releaseDatePickerView: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tvOverview: UITextView!
    @IBOutlet weak var tfMovieName: UITextField!
    @IBOutlet weak var tfReleaseDate: UITextField!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
        self.setupDatePicker()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterNotifications()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
   @objc func keyboardDidShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    func setupDatePicker(){
        
        self.releaseDatePickerView = UIDatePicker()
        self.releaseDatePickerView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 320, height: 216))
        self.releaseDatePickerView.addTarget(self, action: #selector(self.updateReleaseDateFromPicker(_:)), for: UIControl.Event.valueChanged)
        self.releaseDatePickerView.maximumDate = Date()
        self.releaseDatePickerView.datePickerMode = UIDatePicker.Mode.date
        let toolBar = UIToolbar().ToolbarPicker(title: "Next", selector: #selector(self.toolbarBtnPressed))
        self.tfReleaseDate.inputView = self.releaseDatePickerView
        self.tfReleaseDate.inputAccessoryView = toolBar
        self.tfMovieName.inputAccessoryView = toolBar
        self.tvOverview.inputAccessoryView = toolBar


    }
    
    @objc func toolbarBtnPressed(){
       
        if self.tfMovieName.isFirstResponder {
//            self.tfMovieName.resignFirstResponder()
            self.tfReleaseDate.becomeFirstResponder()

        }
        else if tfReleaseDate.isFirstResponder {
//            self.tfReleaseDate.resignFirstResponder()
            self.tvOverview.becomeFirstResponder()

        }
        else if tvOverview.isFirstResponder {
            self.tvOverview.resignFirstResponder()
        }
    }
    @objc func updateReleaseDateFromPicker(_ sender: Any) {
        
        let birthDate = self.releaseDatePickerView.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: birthDate)
        
        self.tfReleaseDate.text = dateString
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
