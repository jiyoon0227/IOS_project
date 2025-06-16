import UIKit

class EmotionViewController: UIViewController {
    
    
    var selectedDate: Date?
    var selectedEmotion: String?
    var selectedEmotionName: String?
    var existingDiaryText: String?
    
        override func viewDidLoad() {
            super.viewDidLoad()
        }

    
    @IBAction func emotionTapped(_ sender: UIButton) {
        if let emotionID = sender.accessibilityIdentifier {
                   selectedEmotion = emotionID
                   print("선택된 감정: \(emotionID)")

                   // 일기 기록 확인 후 DiaryViewController로 이동
                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   if let diaryVC = storyboard.instantiateViewController(withIdentifier: "DiaryViewController") as? DiaryViewController {

                       diaryVC.selectedEmotion = selectedEmotion
                       diaryVC.selectedDate = selectedDate

                       // 이전 일기 데이터 불러오기
                       if let date = selectedDate {
                           let savedEntries = UserDefaults.standard.array(forKey: "emotionEntries") as? [[String: Any]] ?? []
                           for entry in savedEntries {
                               if let timestamp = entry["date"] as? Double,
                                  Calendar.current.isDate(Date(timeIntervalSince1970: timestamp), inSameDayAs: date) {

                                   diaryVC.selectedEmotion = entry["emotion"] as? String
                                   diaryVC.existingDiaryText = entry["diary"] as? String
                                   break
                               }
                           }
                       }

                       navigationController?.pushViewController(diaryVC, animated: true)
                   }
               }
           }
       }
