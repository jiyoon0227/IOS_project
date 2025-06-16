import UIKit
import DGCharts

class StatsViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    // HomeViewController에서 전달받을 감정 통계 데이터
    var emotionCounts: [String: Int] = [:]
    var selectedMonth: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        let emotionCounts = calculateEmotionStatsForCurrentMonth()
        setupChart(emotionCounts: emotionCounts)
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

    func setupChart(emotionCounts: [String: Int]) {
        let emotions = ["happy", "surprised", "sad", "sick", "tired", "angry"]

        let entries: [BarChartDataEntry] = emotions.enumerated().map { index, emotion in
            let count = emotionCounts[emotion] ?? 0
            return BarChartDataEntry(x: Double(index), y: Double(count))
        }

        let dataSet = BarChartDataSet(entries: entries, label: "이번 달 감정 빈도")

        // 감정별로 다른 색상 부여
        dataSet.colors = [
            UIColor.systemYellow,  // happy
            UIColor.systemBlue,    // surprised
            UIColor.systemTeal,    // sad
            UIColor.systemRed,     // sick
            UIColor.systemPurple,  // tired
            UIColor.systemGreen    // angry
        ]

        // 숫자 포맷
        dataSet.valueFormatter = DefaultValueFormatter(decimals: 0)

        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.6
        barChartView.data = data

        // X축 감정 레이블 설정
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: emotions)
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.drawGridLinesEnabled = false

        // Y축 설정
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.axisMinimum = 0

        // 차트 외관
        barChartView.legend.enabled = true
        barChartView.chartDescription.enabled = false
        barChartView.animate(yAxisDuration: 1.2)
    }
}
