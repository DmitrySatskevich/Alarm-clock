//
//  ViewController.swift
//  Alarm-clock
//
//  Created by dzmitry on 19.10.22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var progressViewOutlet: UIProgressView!
    @IBOutlet private var sliderOutlet: UISlider!
    @IBOutlet private weak var textFieldWeak: UITextField!
    @IBOutlet private var datePickerOutlet: UIDatePicker!
    @IBOutlet private var setThisTimeOutlet: UIButton!
    @IBOutlet private var labelTimeOutlet: UILabel!
    @IBOutlet private var switchOutlet: UISwitch!
    @IBOutlet private var clearOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setValueForTextField()
        datePickerOutlet.datePickerMode = .time
        addDoneButtonTo(textFieldWeak)
    }

    @IBAction func sliderAction(_ sender: UISlider) {
        textFieldWeak.text = string(from: sender)
        progressViewOutlet.progress = sliderOutlet.value
    }
    
    @IBAction func setThisTimeActionButton(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        labelTimeOutlet.text = formatter.string(from: datePickerOutlet.date)
    }
    
    
    @IBAction func switchActionPressed(_ sender: UISwitch) {
        if sender.isOn {
            clearOutlet.isEnabled = true
            setThisTimeOutlet.isEnabled = true
            labelTimeOutlet.isEnabled = true
        } else {
            clearOutlet.isEnabled = false
            setThisTimeOutlet.isEnabled = false
            labelTimeOutlet.text = "00:00"
        }
    }
    
    
    @IBAction func clearActionButton(_ sender: UIButton) {
        labelTimeOutlet.text = ""
    }
    
    @IBAction func textFieldAction(_ sender: UITextField) {
        guard let text = sender.text else { return }

        if let currentValue = Float(text) {
            switch sender.tag {
            case 0:
                sliderOutlet.value = currentValue
                progressViewOutlet.progress = currentValue
            default: break
            }
        } else {
            showAlert(title: "Wrong format!", message: "Please enter correct value")
        }
    }
    
    // MARK: - Private
    
    private func setupUI() {
        textFieldWeak.text = String(sliderOutlet.value)
        textFieldWeak.layer.cornerRadius = 10
        setThisTimeOutlet.layer.cornerRadius = 15
        labelTimeOutlet.layer.masksToBounds = true
        labelTimeOutlet.layer.cornerRadius = 15
        clearOutlet.layer.cornerRadius = 15
    }
    
    private func setValueForTextField() {
        textFieldWeak.text = string(from: sliderOutlet)
    }
    
    private func string(from slider: UISlider) -> String {
        return String(format: "%.2f", slider.value)
    }
}

// MARK: - ViewController + UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
}

extension ViewController {
    // Метод для отображения кнопки "Готово" на цифровой клавиатуре
    private func addDoneButtonTo(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        textField.inputAccessoryView = keyboardToolbar
        keyboardToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapDone))
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        
        keyboardToolbar.items = [flexBarButton, doneButton]
    }

    @objc private func didTapDone() {
        view.endEditing(true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
