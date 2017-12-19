//
//  AddReservationViewController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/19/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import EventKit
import  MessageUI

class AddReservationViewController : UIViewController, MFMailComposeViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var calendar: EKCalendar!
    
    let eventNameLabel: UILabel = {
        let label = UILabel()
        label.text = " Event Name"
//        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    let eventNameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Event Name"
        tf.layer.borderWidth = 1
        
        return tf
    }()
    
    
    
    let eventDatePicker : UIDatePicker = {
       let picker = UIDatePicker()
        picker.tintColor = .white
        
       return picker
        
    }()
    
    
    let partyNumberLabel: UILabel = {
        let label = UILabel()
        label.text = " Number Of Guests"
//        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    let eventDateLabel: UILabel = {
        let label = UILabel()
        label.text = " Number Of Guests"
        //        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    
    
    let partyNumberPicker : UIPickerView = {
        let picker = UIPickerView()
//        picker.tintColor = .white
        
        return picker
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
//        view.endEditing(true)
//        super.touchesBegan(touches, withEvent: event)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillParty()
        view.backgroundColor = .white
        partyNumberPicker.delegate = self
        partyNumberPicker.dataSource = self
        
        navigationItem.title = " Resevations"
        setupBarbuttonItems()
        view.addSubview(eventNameLabel)
        view.addSubview(eventNameTextField)
        view.addSubview(partyNumberLabel)
        
        view.addSubview(partyNumberPicker)
        view.addSubview(eventDateLabel)
        view.addSubview(eventDatePicker)
        
        eventDateLabel.anchor(top: partyNumberPicker.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        
        
        
        partyNumberPicker.anchor(top: partyNumberLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 2, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 100)
        
        
        partyNumberLabel.anchor(top: eventNameTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        
        
        
        eventDatePicker.anchor(top: eventDateLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 200)
//        eventDatePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        eventNameTextField.anchor(top: eventNameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 2, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        eventNameLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 80, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
//        eventNameLabel.alpha = 0
        
        
    }
    
    private func setupBarbuttonItems() {
       navigationController?.navigationBar.tintColor = .black
       navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Event", style: .plain, target: self, action: #selector(addEvent))
    }
    @objc func addEvent() {
        print(" adding event ...")
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            sendReservationsError()
        }

    }
   
    fileprivate func configureMailController() -> MFMailComposeViewController {
        let mailControllerVC = MFMailComposeViewController()
        mailControllerVC.mailComposeDelegate = self
        mailControllerVC.setToRecipients(["keevin.mitchell@gmail.com", "caffeNapolinyc191@gmail.com"])
        
        mailControllerVC.setSubject(eventNameTextField.text!)
        
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"  //MM/DD/YYYY
        dateFormatter.dateFormat = "MM-d-yyyy"
        let dateTxt = dateFormatter.string(from: self.eventDatePicker.date)
        self.view.endEditing(true)
        
        mailControllerVC.setMessageBody(eventNameTextField.text! + " is reserving" + " a party for \(String(describing: numberPicked))" + " on " + dateTxt, isHTML: false)
        return mailControllerVC
        
    }
    
    fileprivate func sendReservationsError(){
        let sendReservationsErrorAlert = UIAlertController(title: "Could not send resvations email", message: "This device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendReservationsErrorAlert.addAction(dismiss)
        self.present(sendReservationsErrorAlert, animated: true, completion: nil)
        
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    //MARK:- PickerView delegate methods
    let loopingMargin: Int = 40
//    var persons: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14"]
    
    var numberPicked = 1
    var persons = [String]()
    
   
    
    fileprivate func fillParty() {
//        var i = 1
        for i in 1..<100 {
            let newI = i+1
            persons.append("\(newI)")
        }
        
        
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return view.frame.width - 40
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return persons.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return persons[row % persons.count]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let currentIndex = row % persons.count
//        partyNumberPicker.selectRow((loopingMargin / 2) * persons.count + currentIndex, inComponent: 0, animated: false)
//        print(row)
        eventNameTextField.resignFirstResponder()
        numberPicked = row
    }
   // MARK: UITextField delegate methods
    

}

