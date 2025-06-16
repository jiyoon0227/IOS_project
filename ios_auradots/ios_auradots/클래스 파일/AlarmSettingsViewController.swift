import UIKit

class AlarmSettingsViewController: UIViewController {
    
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 저장된 값 불러오기
        let isReminderOn = UserDefaults.standard.bool(forKey: "reminderEnabled")
        let savedTime = UserDefaults.standard.object(forKey: "reminderTime") as? Date ?? Date()
        
        reminderSwitch.isOn = isReminderOn
        timePicker.date = savedTime}
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "reminderEnabled")
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {        UserDefaults.standard.set(sender.date, forKey: "reminderTime")
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {   dismiss(animated: true, completion: nil)
    }
}
