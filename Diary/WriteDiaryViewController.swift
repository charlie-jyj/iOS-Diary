//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by UAPMobile on 2022/01/10.
//

import UIKit

// 열거형에 연관값을 주어 edit될 diary를 stored
enum DiaryEditorMode {
    case new
    case edit(IndexPath, Diary)
}

protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectRegister(diary: Diary)
}

class WriteDiaryViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    weak var delegate: WriteDiaryViewDelegate?
    var diaryEditorMode: DiaryEditorMode = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
        self.confirmButton.isEnabled = false  // 조건 충족 전에는 비활성화
        self.configureInputField()
        self.configureEditMode()
    }
    
    private func configureEditMode() {
        switch self.diaryEditorMode {
        // 수정 버튼을 통해 디테일 페이지에 넘어온 경우,
        // associated value가 모두 let(var)이면 place a single let(var) annotation before the case name
        case let .edit(_, diary):
            self.titleTextField.text = diary.title
            self.contentsTextView.text = diary.contents
            self.dateTextField.text = self.dateToString(date: diary.date)
            self.diaryDate = diary.date
            self.confirmButton.title = "수정"
        default:
            break
        }
    }
    
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor  // border 색상은 UIColor 가 아닌 cgColor로
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)  // associate target object and action method with the control
        self.datePicker.locale = Locale(identifier: "ko_KR")
        self.dateTextField.inputView = self.datePicker // setting이 끝난 datePicker 객체를 inputView 에 할당
        
    }
    
    // inputfield 의 입력에 따라 qualified
    private func configureInputField() {
        self.contentsTextView.delegate = self
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        // datepicker 는 키보드 입력을 받는 control이 아니기 때문에 dateTextFieldDidChange가 호출 되지 않는다. => datepicker 로 날짜를 골랐을 때 editingChanged event 발생하게
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    //date 다루기
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date
        self.dateTextField.text = formatter.string(from: datePicker.date)
        self.dateTextField.sendActions(for: .editingChanged)  // editingChanged 를 trigger
        
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func dateTextFieldDidChange(_ dateField: UITextField) {
        self.validateInputField()
    }
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text else { return }
        guard let contents = self.contentsTextView.text else { return }
        guard let date = self.diaryDate else { return }
        //let diary = Diary(title: title, contents: contents, date: date, isStar: false)  // 즐겨찾기가 해제 되는 문제 발생
        
        switch self.diaryEditorMode {
        case .new:
            let diary = Diary(
                uuidString:UUID().uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: false)
            self.delegate?.didSelectRegister(diary: diary)
        case let .edit(indexPath, diary):
            let diary = Diary(
                uuidString:diary.uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: diary.isStar)
            debugPrint("write:\(diary)")
            NotificationCenter.default.post(
                name: NSNotification.Name("editDiary"),
                object: diary,
                userInfo: nil)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func validateInputField() {
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.contentsTextView.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true)
    }
    
    // user가 화면을 touch하면 call
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension WriteDiaryViewController: UITextViewDelegate {
    // textview 입력 시 호출
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}
