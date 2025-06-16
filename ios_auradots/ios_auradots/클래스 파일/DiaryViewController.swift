import UIKit

class DiaryViewController: UIViewController {

    @IBOutlet weak var emotionImageView: UIButton!
    @IBOutlet weak var diaryTextView: UITextView!
    var selectedDate: Date?
       var selectedEmotion: String?  // 전달받은 감정
       var existingDiaryText: String? // 이전 일기 내용

    override func viewDidLoad() {
            super.viewDidLoad()
            setupEmotion()

            // 이전 일기 텍스트 표시
            if let existing = existingDiaryText {
                diaryTextView.text = existing
            }
        }

        func setupEmotion() {
            guard let emotion = selectedEmotion else { return }

            let emotionImageName: String
            switch emotion {
            case "happy": emotionImageName = "emoji_happy"
            case "surprised": emotionImageName = "emoji_surprised"
            case "sad": emotionImageName = "emoji_sad"
            case "sick": emotionImageName = "emoji_sick"
            case "tired": emotionImageName = "emoji_tired"
            case "angry": emotionImageName = "emoji_angry"
            default: emotionImageName = "emoji_default"
            }

            emotionImageView.setImage(UIImage(named: emotionImageName), for: .normal)
        }

        @IBAction func saveDiary(_ sender: UIButton) {
            guard let diaryText = diaryTextView.text, !diaryText.isEmpty else {
                print("일기 내용이 비어 있습니다.")
                return
            }

            print(" 저장된 감정: \(selectedEmotion ?? "")")
            print(" 저장된 날짜: \(selectedDate ?? Date())")
            print("✅입력된 일기: \(diaryText)")

            if let date = selectedDate, let emotion = selectedEmotion {
                var entries = UserDefaults.standard.array(forKey: "emotionEntries") as? [[String: Any]] ?? []

                // 동일 날짜가 있을 경우 덮어쓰기
                if let index = entries.firstIndex(where: {
                    guard let timestamp = $0["date"] as? Double else { return false }
                    return Calendar.current.isDate(Date(timeIntervalSince1970: timestamp), inSameDayAs: date)
                }) {
                    entries[index] = [
                        "date": date.timeIntervalSince1970,
                        "emotion": emotion,
                        "diary": diaryText
                    ]
                } else {
                    entries.append([
                        "date": date.timeIntervalSince1970,
                        "emotion": emotion,
                        "diary": diaryText
                    ])
                }

                UserDefaults.standard.set(entries, forKey: "emotionEntries")
            }

            if let date = selectedDate {
                NotificationCenter.default.post(
                    name: NSNotification.Name("DiarySaved"),
                    object: nil,
                    userInfo: ["date": date]
                )
            }

            navigationController?.popViewController(animated: true)
        }
    }
