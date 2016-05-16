//
//  MediaAddViewController.swift
//  FlashSound
//
//  Created by Ian on 5/16/16.
//  Copyright © 2016 ianchengtw_ios_30_apps_in_30_days. All rights reserved.
//

import UIKit
import MediaPlayer

class MediaAddViewController: UIViewController {

    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var mediaNameLabel: UILabel!
    @IBOutlet weak var mediaPickButton: UIButton!
    @IBOutlet weak var imagePickButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    private var selectedMediaItemCollection: MPMediaItemCollection? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaPickButton.layer.cornerRadius = 10
        mediaPickButton.layer.borderWidth = 2
        mediaPickButton.layer.borderColor = mediaPickButton.titleLabel?.textColor.CGColor
        
        imagePickButton.layer.cornerRadius = 10
        imagePickButton.layer.borderWidth = 2
        imagePickButton.layer.borderColor = mediaPickButton.titleLabel?.textColor.CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonWasPressed(sender: UIBarButtonItem) {
        
        if selectedMediaItemCollection != nil {
            
            storage.addItem(
                title: titleInput.text ?? "",
                mediaItemCollection: selectedMediaItemCollection ?? MPMediaItemCollection(),
                image: imageView.image ?? UIImage()
            )
            
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }

    @IBAction func mediaPickButtonWasPressed(sender: UIButton) {
        
        self.presentPicker(sender)
        
    }
    
    @IBAction func imagePickButtonWasPressed(sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func presentPicker (sender:AnyObject) {
        
        let picker = MPMediaPickerController(mediaTypes: .Music)
        picker.showsCloudItems = false
        picker.delegate = self
//        picker.allowsPickingMultipleItems = true
        picker.modalPresentationStyle = .Popover
        picker.preferredContentSize = CGSizeMake(500,600)
        
        self.presentViewController(picker, animated: true, completion: nil)
        
        if let pop = picker.popoverPresentationController {
            
            if let b = sender as? UIBarButtonItem {
                
                pop.barButtonItem = b
                
            }
            
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MediaAddViewController: MPMediaPickerControllerDelegate {
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if let name = mediaItemCollection.representativeItem?.title {
            mediaNameLabel.text = name
        }
        
        selectedMediaItemCollection = mediaItemCollection
        
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension MediaAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleToFill
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
