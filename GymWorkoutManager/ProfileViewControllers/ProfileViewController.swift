//
//  ProfileViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/5/14.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit
import RealmSwift
import JVFloatLabeledTextField


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    // MARK: - IBOutlet
    @IBOutlet var profilePicture: RoundButton!
    @IBOutlet var headerView: UIView!
    @IBOutlet var name: JVFloatLabeledTextField!
    @IBOutlet var bodyWeight: JVFloatLabeledTextField!
    @IBOutlet var age: JVFloatLabeledTextField!
    @IBOutlet var bodyHeight: JVFloatLabeledTextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!

    // MARK: - Variables
    var curentUser:Person?
    
    @IBAction func female(sender: AnyObject) {
        femaleButton.backgroundColor = GWMColorPurple
        maleButton.backgroundColor = GWMColorYellow
        DatabaseHelper.sharedInstance.beginTransaction()
        curentUser?.sex = "female"
        DatabaseHelper.sharedInstance.commitTransaction()
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        if cusers?.count <= 0 {
            curentUser!.id = NSUUID.init().UUIDString
            DatabaseHelper.sharedInstance.insert(curentUser!)
        }

    }
    @IBAction func male(sender: AnyObject) {
        maleButton.backgroundColor = GWMColorPurple
        femaleButton.backgroundColor = GWMColorYellow
        DatabaseHelper.sharedInstance.beginTransaction()
        curentUser?.sex = "male"
        DatabaseHelper.sharedInstance.commitTransaction()
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        if cusers?.count <= 0 {
            curentUser!.id = NSUUID.init().UUIDString
            DatabaseHelper.sharedInstance.insert(curentUser!)
        }
    }
    
    // MARK: Profile Image
    @IBAction func selectPicture(sender: AnyObject) {
        let alert = UIAlertController(title: "Profile image", message: "Upload your profile image.", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (UIAlertAction) in
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = UIImagePickerControllerSourceType.Camera
            myPickerController.allowsEditing = true
            self.presentViewController(myPickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .Default, handler: { (UIAlertAction) in
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            myPickerController.allowsEditing = true
            self.presentViewController(myPickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        DatabaseHelper.sharedInstance.beginTransaction()
        curentUser?.name = name.text ?? ""
        curentUser?.age = Int(age.text ?? "0") ?? 0
        curentUser?.weight = bodyWeight.text ?? ""
        curentUser?.height = bodyHeight.text ?? ""
        DatabaseHelper.sharedInstance.commitTransaction()
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        if cusers?.count <= 0 {
            curentUser!.id = NSUUID.init().UUIDString
            DatabaseHelper.sharedInstance.insert(curentUser!)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let i = info[UIImagePickerControllerOriginalImage] as? UIImage
        let image = fixOrientation(i!)
        DatabaseHelper.sharedInstance.beginTransaction()
        if let imageSourceData = UIImagePNGRepresentation(image) {
            if curentUser!.profilePicture != nil {
                curentUser!.profilePicture = nil
            }
            curentUser!.profilePicture = imageSourceData
        }
        let sizedImage = resizeToAspectFit(profilePicture.frame.size, bounds: profilePicture.bounds, sourceImage: UIImage(data: curentUser!.profilePicture!)!)
        profilePicture.backgroundColor = UIColor(patternImage: sizedImage)
        profilePicture.setTitle("", forState: .Normal)

        DatabaseHelper.sharedInstance.commitTransaction()
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        if cusers?.count <= 0 {
            curentUser!.id = NSUUID.init().UUIDString
            DatabaseHelper.sharedInstance.insert(curentUser!)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func fixOrientation(image:UIImage) -> UIImage {
        if (image.imageOrientation == UIImageOrientation.Up) {
            return image
        }
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.drawInRect(rect)
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    
    private func resizeToAspectFit(viewSize: CGSize, bounds: CGRect, sourceImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(viewSize)
        sourceImage.drawInRect(bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func profilePictureStyleSheet() {
        profilePicture.layer.borderWidth = 1
        profilePicture.backgroundColor = GWMColorPurple
        profilePicture.layer.shadowColor = UIColor.blackColor().CGColor
        profilePicture.layer.shadowOffset = CGSize(width: 0, height: 0)
        profilePicture.layer.shadowRadius = 15
        profilePicture.layer.shadowOpacity = 0.8
    }
    
    // MARK: Navigation Controller
    private func navigationControllerStyleSheet() {
        self.navigationController?.navigationBar.topItem?.title = "Profile"
        // make the navigation bar edge disappear
        let navBarLineView = UIView(frame: CGRectMake(0,
            CGRectGetHeight((navigationController?.navigationBar.frame)!),
            CGRectGetWidth((self.navigationController?.navigationBar.frame)!),
            1))
        navBarLineView.backgroundColor = GWMColorYellow
        self.navigationController?.navigationBar.addSubview(navBarLineView)

        self.tabBarController?.tabBar.backgroundColor = GWMColorYellow
        self.tabBarController?.tabBar.tintColor = GWMColorPurple
        self.tabBarController?.tabBar.barTintColor = GWMColorYellow
        self.tabBarController?.tabBar.translucent = false
    }
    
    // MARK: textFieldStyleSheet
    private func setLayer(input:JVFloatLabeledTextField) -> CALayer {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = GWMColorYellow.CGColor
        border.frame = CGRect(x: 0, y: input.frame.size.height - width, width:  input.frame.size.width, height: input.frame.size.height)
        border.borderWidth = width
        return border
    }
    
    private func textFieldStyleSheet() {
        name.layer.addSublayer(setLayer(name))
        name.textColor = UIColor.whiteColor()
        name.layer.masksToBounds = true
        
        bodyWeight.layer.addSublayer(setLayer(bodyWeight))
        bodyWeight.textColor = UIColor.whiteColor()
        bodyWeight.layer.masksToBounds = true
        
        bodyHeight.layer.addSublayer(setLayer(bodyHeight))
        bodyHeight.textColor = UIColor.whiteColor()
        bodyHeight.layer.masksToBounds = true
        
        age.layer.addSublayer(setLayer(age))
        age.textColor = UIColor.whiteColor()
        age.layer.masksToBounds = true
    }
    
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePictureStyleSheet()
        navigationControllerStyleSheet()
        textFieldStyleSheet()
        
        let backgroundImage = resizeToAspectFit(self.view.frame.size,bounds: self.view.bounds, sourceImage: UIImage(named: "profileBackground.jpg")!)
        self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        let image = resizeToAspectFit(headerView.frame.size,bounds: headerView.bounds, sourceImage: UIImage(named: "profileHeader.png")!)
        self.headerView.backgroundColor = UIColor(patternImage: image)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        self.navigationController?.navigationBar.topItem?.title = "Profile"
        curentUser = cusers?.first
        if curentUser == nil {
            curentUser = Person()
        }
        
        if let user = curentUser {
            DatabaseHelper.sharedInstance.beginTransaction()
            if let userPicture = user.profilePicture{
                let sizedImage = resizeToAspectFit(profilePicture.frame.size, bounds: profilePicture.bounds, sourceImage: UIImage(data: userPicture)!)
                profilePicture.backgroundColor = UIColor(patternImage: sizedImage)
                profilePicture.setTitle("", forState: .Normal)
            }
            name.text = user.name
            bodyHeight.text = user.height
            bodyWeight.text = user.weight
            if case user.age = 0 {
                return
            } else {
                age.text = "\(user.age)"

            }
            if user.sex == "male" {
                maleButton.backgroundColor = GWMColorPurple
                femaleButton.backgroundColor = GWMColorYellow
            } else if user.sex == "female" {
                femaleButton.backgroundColor = GWMColorPurple
                maleButton.backgroundColor = GWMColorYellow
            }
            DatabaseHelper.sharedInstance.commitTransaction()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}