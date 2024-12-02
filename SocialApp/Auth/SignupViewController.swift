//
//  SignupViewController.swift
//  SocialApp
//
//  Created by DREAMWORLD on 29/11/24.
//

import UIKit
import CoreLocation
import Photos
import CropViewController
import PhoneNumberKit
import Charts

class SignupViewController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var svPhoneNumber: UIStackView!
    @IBOutlet weak var svLastName: UIStackView!
    @IBOutlet weak var svFirstName: UIStackView!
    @IBOutlet weak var svFullName: UIStackView!

    @IBOutlet weak var imgConfirmPassEye: UIImageView!
    @IBOutlet weak var imgPassEye: UIImageView!

    @IBOutlet weak var txtPhone: PhoneNumberTextField! {
        didSet {
            txtPhone.maxDigits = 10
            txtPhone.withPrefix = false
        }
    }
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFullName: UITextField!

    @IBOutlet weak var lblPhoneError: UILabel!
    @IBOutlet weak var lblFullNameError: UILabel!
    @IBOutlet weak var lblFirstNameError: UILabel!
    @IBOutlet weak var lblLastNameError: UILabel!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var lblPassError: UILabel!
    @IBOutlet weak var lblConfirmPassError: UILabel!

    @IBOutlet weak var vwBackView: UIView!

    var isProfileImagePicked = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    @IBAction func btnSignInAction(_ sender: Any) {

    }

    @IBAction func btnSignUpAction(_ sender: Any) {
        if validateInputs() {
            if self.isProfileImagePicked {
                self.registerUser()
            } else {
                self.showAlert(title: "Please Select Profile Image.", message: "")
            }
        }
    }

    @IBAction func btnBackAction(_ sender: Any) {

    }

    @IBAction func btnCountryAction(_ sender: Any) {

    }
}

//MARK: - All Methods
extension SignupViewController {

    func setupUI() {

        self.svFullName.isHidden = isFullNameAllow ? false : true
        self.svFirstName.isHidden = isFullNameAllow ? true : false
        self.svLastName.isHidden = isFullNameAllow ? true : false
        self.svPhoneNumber.isHidden = isPhoneNumberAllow ? false : true

        imgPassEye.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility)))
        imgConfirmPassEye.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleConfirmPasswordVisibility)))
        imgProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageAction)))
    }

    func validateInputs() -> Bool {
        hideErrorMessages() // Ensure all error messages are hidden initially

        var isValid = true // Track overall validity of the form

        // Validate Full Name or First/Last Name
        if isFullNameAllow {
            if let fullName = txtFullName.text, fullName.isEmpty {
                self.lblFullNameError.text = "Full Name cannot be empty."
                self.lblFullNameError.isHidden = false
                isValid = false
            }
        } else {
            if let firstName = txtFirstName.text, firstName.isEmpty {
                self.lblFirstNameError.text = "First Name cannot be empty."
                self.lblFirstNameError.isHidden = false
                isValid = false
            }

            if let lastName = txtLastName.text, lastName.isEmpty {
                self.lblLastNameError.text = "Last Name cannot be empty."
                self.lblLastNameError.isHidden = false
                isValid = false
            }
        }

        // Validate Email
        if let email = txtEmail.text, !isValidEmail(email) {
            self.lblEmailError.text = "Enter a valid email address."
            self.lblEmailError.isHidden = false
            isValid = false
        }

        // Validate Phone Number
        if isPhoneNumberAllow, let phone = txtPhone.text, (phone.isEmpty || phone.trimmingCharacters(in: .whitespaces).count == 0) {
            self.lblPhoneError.text = "Phone Number cannot be empty."
            self.lblPhoneError.isHidden = false
            isValid = false
        }

        // Validate Password
        if let password = txtPassword.text, !isValidPassword(password) {
            self.lblPassError.text = "Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, and one number."
            self.lblPassError.isHidden = false
            isValid = false
        }

        // Validate Confirm Password
        if let confirmPassword = txtConfirmPassword.text, confirmPassword != txtPassword.text {
            self.lblConfirmPassError.text = "Passwords do not match."
            self.lblConfirmPassError.isHidden = false
            isValid = false
        }

        return isValid // Return true only if all fields are valid
    }

    func hideErrorMessages() {
        [lblFullNameError, lblFirstNameError, lblLastNameError, lblEmailError, lblPhoneError, lblPassError, lblConfirmPassError].forEach { label in
            guard let lbl = label else { return }
            lbl.isHidden = true
        }
    }

    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()

        if status == .notDetermined {
            // Request permission
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    DispatchQueue.main.async {
                        self.openPhotoLibrary()
                    }
                } else {
                    self.showPermissionAlert()
                }
            }
        } else if status == .authorized {
            openPhotoLibrary()
        } else {
            showPermissionAlert()
        }
    }

    func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }

    func showPermissionAlert() {
        self.showPermissionAlert(
            title: "Permission Denied",
            message: "Please allow photo library access in Settings to select a profile image."
        )
    }
}

//MARK: - Obj C Target Methods
extension SignupViewController {

    @objc func togglePasswordVisibility() {
        txtPassword.isSecureTextEntry.toggle()
        imgPassEye.image = txtPassword.isSecureTextEntry ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
    }

    @objc func toggleConfirmPasswordVisibility() {
        txtConfirmPassword.isSecureTextEntry.toggle()
        imgConfirmPassEye.image = txtConfirmPassword.isSecureTextEntry ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
    }

    @objc func profileImageAction() {
        self.checkPhotoLibraryPermission()
    }
}

//MARK: - API Methods
extension SignupViewController {

    func registerUser() {

        var param: [String: Any] = [
            "email": self.txtEmail.text ?? "",
            "password": self.txtPassword.text ?? "",
            "confirm_password": self.txtConfirmPassword.text ?? "",
            "device_type": "iOS",
            "device_token": FCM_TOKEN.isEmpty ? UUID().uuidString : FCM_TOKEN
        ]

        if isFullNameAllow {
            param["name"] = self.txtFullName.text ?? ""
        } else {
            param["first_name"] = self.txtFirstName.text ?? ""
            param["last_name"] = self.txtLastName.text ?? ""
        }

        if isPhoneNumberAllow {
            param["phone"] = self.txtPhone.nationalNumber.trimmingCharacters(in: .whitespaces)
        }

        guard let imgData = self.imgProfile.image?.pngData() else { 
            self.showAlert(title: "Opps!", message: "Somthing went wrong! \nTry after some time.")
            return
        }

        APIManager.postMethodImage(url: API_Constants.REGISTER_USER, param: param, doc: [(parameter_name: "image", data: imgData, type: "image")], is_header_allow: false) { resDict in
            self.showAlert(title: "Social App", message: "Your Registration is Done!")
        }
    }

}

//MARK: - Image Picker Delegate Methods
extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let selectedImage = info[.originalImage] as? UIImage {
            let cropViewController = CropViewController(croppingStyle: .circular, image: selectedImage)
            cropViewController.delegate = self
            self.present(cropViewController, animated: true)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true) {
            self.imgProfile.image = image
            self.isProfileImagePicked = true
        }
    }
}
