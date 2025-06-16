import UIKit
import FSCalendar
import DGCharts

class HomeViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    var recordedDates: [Date] = []

    @IBOutlet weak var calender: FSCalendar!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadRecordedDates()

        calender.delegate = self
        calender.dataSource = self

        // 달력 설정
        calender.scrollEnabled = true
        calender.scrollDirection = .horizontal
        calender.appearance.headerMinimumDissolvedAlpha = 1.0
        calender.appearance.headerTitleColor = .black
        calender.appearance.weekdayTextColor = .darkGray
        calender.appearance.selectionColor = .systemPurple
        calender.appearance.todayColor = .systemRed

        // 일기 저장 시 알림 수신
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDiarySaved(_:)),
            name: NSNotification.Name("DiarySaved"),
            object: nil
        )
    }

    @IBAction func showAlarmSettings(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let alarmVC = storyboard.instantiateViewController(withIdentifier: "AlarmSettingsViewController") as? AlarmSettingsViewController {
                alarmVC.modalPresentationStyle = .formSheet
                present(alarmVC, animated: true, completion: nil)
            }
        }
    @IBAction func showStatsTapped(_ sender: UIButton) {
        print("통계 보기 버튼 눌림")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let statsVC = storyboard.instantiateViewController(withIdentifier: "StatsViewController") as? StatsViewController {
            statsVC.selectedMonth = calender.currentPage  // 현재 보고 있는 달을 넘겨줌
            navigationController?.pushViewController(statsVC, animated: true)
        }
    }

    func calculateEmotionStatsForCurrentMonth() -> [String: Int] {
        let savedEntries = UserDefaults.standard.array(forKey: "emotionEntries") as? [[String: Any]] ?? []
        var stats: [String: Int] = [:]
        let calendar = Calendar.current
        let now = Date()

        for entry in savedEntries {
            if let timestamp = entry["date"] as? Double,
               let emotion = entry["emotion"] as? String {
                let date = Date(timeIntervalSince1970: timestamp)
                if calendar.isDate(date, equalTo: now, toGranularity: .month) {
                    stats[emotion, default: 0] += 1
                }
            }
        }
        return stats
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let entry = fetchEntry(for: date),
           let diaryVC = storyboard.instantiateViewController(withIdentifier: "DiaryViewController") as? DiaryViewController {
            diaryVC.selectedDate = date
            diaryVC.selectedEmotion = entry["emotion"] as? String
            diaryVC.existingDiaryText = entry["diary"] as? String
            navigationController?.pushViewController(diaryVC, animated: true)
        } else {
            if let emotionVC = storyboard.instantiateViewController(withIdentifier: "EmotionViewController") as? EmotionViewController {
                emotionVC.selectedDate = date
                navigationController?.pushViewController(emotionVC, animated: true)
            }
        }
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return recordedDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) ? 1 : 0
    }

    func saveRecordedDates() {
        let timestamps = recordedDates.map { $0.timeIntervalSince1970 }
        UserDefaults.standard.set(timestamps, forKey: "recordedDates")
    }

    func loadRecordedDates() {
        if let timestamps = UserDefaults.standard.array(forKey: "recordedDates") as? [TimeInterval] {
            recordedDates = timestamps.map { Date(timeIntervalSince1970: $0) }
        }
    }

    @objc func handleDiarySaved(_ notification: Notification) {
        if let date = notification.userInfo?["date"] as? Date {
            recordedDates.append(date)
            saveRecordedDates()
            calender.reloadData()
        }
    }

    func fetchEntry(for date: Date) -> [String: Any]? {
        let entries = UserDefaults.standard.array(forKey: "emotionEntries") as? [[String: Any]] ?? []
        for entry in entries {
            if let timestamp = entry["date"] as? TimeInterval {
                let savedDate = Date(timeIntervalSince1970: timestamp)
                if Calendar.current.isDate(savedDate, inSameDayAs: date) {
                    return entry
                }
            }
        }
        return nil
    }
}
