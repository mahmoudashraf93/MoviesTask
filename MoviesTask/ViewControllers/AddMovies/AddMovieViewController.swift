//
//  AddMovieViewController.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/23/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import UIKit
protocol AddMovieVCDelegate {
    func didAdd(_ movie: UserAddedMoviesListViewModel )
}
class AddMovieViewController: UIViewController {
    
    var releaseDatePickerView: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    var imagePicker: ImagePicker!
    var delegate: AddMovieVCDelegate?
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var btnAddPoster: UIButton!
    @IBOutlet weak var tvOverview: UITextView!
    @IBOutlet weak var tfMovieName: UITextField!
    @IBOutlet weak var tfReleaseDate: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
        self.setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterNotifications()
    }
    func setupViews(){
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        let width = CGFloat(1.0)
        tvOverview.layer.borderColor = UIColor.white.cgColor
        tvOverview.layer.borderWidth = width
        tvOverview.clipsToBounds = true
        tvOverview.layer.masksToBounds = false
        
        self.setupDatePicker()
    }
    @IBAction func btnAddPressed(_ sender: Any) {
        
        var imageData = UIImage(named: Constants.PlaceHolders.imagePlaceHolderName)!.pngData()
        if let postedImage = self.imgPoster.image {
            imageData = postedImage.pngData()
        }
        // validate input
        if self.isValidInput() {
            let movie = UserAddedMoviesListViewModel(titleText: self.tfMovieName.text!, releaseDateText: self.tfReleaseDate.text, overviewText: self.tvOverview.text, imageData: imageData)
            self.delegate?.didAdd(movie)
            self.dismiss(animated: true, completion: nil)
        }
    }
    private func isValidInput() -> Bool {
        if self.tfMovieName.text == "" {
            self.presentAlertView(withTitle: "Invalid Input", message: "Please type a movie title", cancelActionTitle: nil  , confirmActionTitle: "OK", cancelAction: nil, confirmAction: nil)
            
            return false
        }
        
        return true
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
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        let toolBar = UIToolbar().ToolbarPicker(title: "Next", selector: #selector(self.toolbarBtnPressed), cancelSelector: #selector(self.toolbarCancelBtnPressed))
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
    @objc func toolbarCancelBtnPressed(){
        self.view.endEditing(true)
        
    }
    @objc func updateReleaseDateFromPicker(_ sender: Any) {
        
        let birthDate = self.releaseDatePickerView.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: birthDate)
        
        self.tfReleaseDate.text = dateString
    }
    
    @IBAction func btnAddPosterPressed(_ sender: Any) {
        self.imagePicker.present(from: self.view)
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

extension AddMovieViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.btnAddPoster.isHidden = true
        self.imgPoster.image = image
    }
}
