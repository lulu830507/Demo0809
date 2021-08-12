//
//  PhotoViewController.swift
//  Demo0809
//
//  Created by 林思甯 on 2021/8/10.
//

import UIKit
import CoreImage.CIFilterBuiltins

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var sizeSegment: UISegmentedControl!
    @IBOutlet var images: [UIImageView]!
    
    @IBOutlet var sliders: [UISlider]!
    // 調整的照片
    @IBOutlet weak var testPhoto: UIImageView!
    
    let context = CIContext(options: nil)
    var chooseColor: String = ""
    //鏡像
    var count: CGFloat = 1
    //轉向
    var degree = CGFloat.pi / 180
    var number: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.layer.cornerRadius = 10
        
        
    }
    
    @IBAction func ChangePage(_ sender: UIPageControl) {
        let point = CGPoint(x: scrollView.bounds.width*CGFloat(sender.currentPage), y: 0)
        scrollView.setContentOffset(point, animated: true)
    }
    
    @IBAction func selectPhoto(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        testPhoto.image = image
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func turnRight(_ sender: Any) {
        //轉向使用
        testPhoto.transform = CGAffineTransform(rotationAngle: degree * 90 * number)
        number += 1
        //轉一次９０度因此３６０就歸０度
        if number == 4 {
            number = 0
        }
    }
    
    @IBAction func mirrorChange(_ sender: Any) {
        
        count *= -1
        testPhoto.transform = CGAffineTransform(scaleX: count, y: 1)
    }
    
    @IBAction func resize(_ sender: UISegmentedControl) {
        
        let length: Int = 350 //調整比例
        var width: Int
        var height: Int
        
        switch sender.selectedSegmentIndex {
        case 0:
            width = length
            height = length
        case 1:
            width = length
            height = Int(Double(length) / 16 * 9)
        case 2:
            width = length
            height = Int(Double(length) / 4 * 3)
        default:
            width = length
            height = length
        }
    }
    
    
    @IBAction func update(_ sender: UISlider) {
        let ciImage = CIImage(image: testPhoto.image!)
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        switch sender.tag {
        case 0:
            filter?.setValue(sliders[0].value, forKey: kCIInputBrightnessKey)
        case 1:
            filter?.setValue(sliders[1].value, forKey: kCIInputContrastKey)
        case 2:
            filter?.setValue(sliders[2].value, forKey: kCIInputSaturationKey)
        default:
            break
        }
        if let outputImage = filter?.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let newImage = UIImage(cgImage: cgImage)
                testPhoto.image = newImage
        }
        
    }
    @IBAction func changeFilter(_ sender: UIButton) {
        
        let ciImage = CIImage(image: testPhoto.image!)
        var name = ""
        switch sender.tag {
        case 1:
            name = "CIColorMonochrome"
        case 2:
            name = "CIPhotoEffectFade"
        case 3:
            name = "CIPhotoEffectInstant"
        case 4:
            name = "CIPhotoEffectMono"
        case 5:
            name = "CIPhotoEffectNoir"
        default:
            break
        }
        
        let filter = CIFilter(name: name)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let outputImage = filter?.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let newImage = UIImage(cgImage: cgImage)
            testPhoto.image = newImage
        }
    }
    
    
    
}
extension PhotoViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/scrollView.bounds.width
        pagecontrol.currentPage = Int(page)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        for pageView in scrollView.subviews {
            if pageView.isKind(of: UIView.self) {
                return pageView
            }
        }
        return nil
    }
}
