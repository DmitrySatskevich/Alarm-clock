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
    @IBOutlet private var textFieldOutlet: UITextField!
    @IBOutlet private var datePickerOutlet: UIDatePicker!
    @IBOutlet private var setThisTimeOutlet: UIButton!
    @IBOutlet private var labelTimeOutlet: UILabel!
    @IBOutlet private var switchOutlet: UISwitch!
    @IBOutlet private var clearOutlet: UIButton!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setValueForTextField()
        addDoneButtonTo(textFieldOutlet)
    }

    @IBAction func sliderAction(_ sender: UISlider) {
        textFieldOutlet.text = string(from: sender)
        progressViewOutlet.progress = sliderOutlet.value
    }
    
    @IBAction func setThisTimeActionButton() {
        getDateFromPicker()
    }
    
    
    @IBAction func switchActionPressed(_ sender: UISwitch) {
        if sender.isOn {
            clearOutlet.isEnabled = true
            setThisTimeOutlet.isEnabled = true
            labelTimeOutlet.isEnabled = true
        } else {
            clearOutlet.isEnabled = false
            setThisTimeOutlet.isEnabled = false
            labelTimeOutlet.text = "00 : 00"
        }
    }
    
    
    @IBAction func clearActionButton(_ sender: UIButton) {
        
    }
    
    // MARK: - Private
    
    private func setupUI() {
        textFieldOutlet.text = String(sliderOutlet.value)
        textFieldOutlet.layer.cornerRadius = 10
        setThisTimeOutlet.layer.cornerRadius = 15
        labelTimeOutlet.layer.masksToBounds = true
        labelTimeOutlet.layer.cornerRadius = 15
        clearOutlet.layer.cornerRadius = 15
    }
    
    private func setValueForTextField() {
        textFieldOutlet.text = string(from: sliderOutlet)
    }
    
    private func string(from slider: UISlider) -> String {
        return String(format: "%.2f", slider.value)
    }
    
    private func getDateFromPicker() {
        datePicker.datePickerMode = .time
        let formater = DateFormatter()
        formater.dateFormat = "HH : mm"
        labelTimeOutlet.text = formater.string(from: datePicker.date)
    }
}

// MARK: - ViewController + UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    // Скрываем клавиатуру нажатием на "Done"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Скрытие клавиатуры по тапу за пределами Text View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true) // Скрывает клавиатуру, вызванную для любого объекта
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if let currentValue = Float(text) {
            switch textField.tag {
            case 0: sliderOutlet.value = currentValue
            default: break
            }
        }
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
}
