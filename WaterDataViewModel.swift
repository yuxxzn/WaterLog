import Foundation
import SwiftUI // @AppStorage, ObservableObject 등을 사용하기 위해 import
import Combine // ObservableObject를 위해 필요

/**
 * @class WaterDataViewModel
 * 앱의 메인 뷰 모델(ViewModel)로서, 모든 데이터와 비즈니스 로직을 관리합니다.
 * @conforms ObservableObject: SwiftUI View가 이 객체의 변경 사항을 구독(observe)할 수 있게 합니다.
 */
class WaterDataViewModel: ObservableObject {
    
    // MARK: - 1. 목표 섭취량 (영구 저장)
    
    /**
     * @property targetGoal
     * 사용자가 설정한 일일 목표 섭취량 (ml)
     * @AppStorage: UserDefaults와 값을 자동으로 동기화하여 앱을 재시작해도 유지됩니다.
     */
    @AppStorage("targetGoal") var targetGoal: Double = 2000.0

    // MARK: - 2. 오늘 섭취 기록
    
    /**
     * @property intakeRecords
     * 오늘 섭취한 물의 기록을 배열로 저장합니다.
     * @Published: 이 프로퍼티가 변경될 때마다 SwiftUI View가 자동으로 업데이트됩니다.
     */
    @Published var intakeRecords: [WaterIntakeRecord] = []
    
    /// UserDefaults에 기록을 저장하기 위한 고유 키
    private let recordsKey = "todayIntakeRecords"

    // MARK: - 3. 계산된 프로퍼티 (Computed Properties)
    
    /// 현재까지 섭취한 총량 (ml)
    var totalIntakeToday: Double {
        // intakeRecords 배열의 모든 'amount' 값을 합산합니다.
        intakeRecords.reduce(0) { $0 + $1.amount }
    }
    
    /// 목표 달성률 (0.0 ~ 1.0 사이의 값)
    var progressPercentage: Double {
        if targetGoal == 0 { return 0 } // 0으로 나누기 방지
        // 현재 섭취량 / 목표량. 최대값은 1.0 (100%)
        return min(totalIntakeToday / targetGoal, 1.0)
    }

    // MARK: - 4. 초기화 (Initializer)
    
    init() {
        // 앱이 시작될 때 UserDefaults에서 저장된 기록을 불러옵니다.
        loadRecords()
        // 앱이 시작될 때 오늘 날짜가 맞는지 확인하고, 날짜가 다르면 초기화합니다.
        checkForDailyReset()
    }
    
    // MARK: - 5. 비즈니스 로직 (핵심 기능)

    /**
     * [기능 2] 물 마신 양 추가
     * @param amount: 추가할 물의 양 (ml)
     */
    func addWater(amount: Double) {
        let newRecord = WaterIntakeRecord(amount: amount, date: Date())
        // 배열의 맨 앞에 추가하여 리스트에서 최신순으로 보이게 함 (선택 사항)
        // 또는 intakeRecords.append(newRecord)로 뒤에 추가
        intakeRecords.insert(newRecord, at: 0)
        saveRecords() // 변경 사항을 UserDefaults에 저장
    }
    
    /**
     * [기능 4] 리스트에서 특정 기록 삭제
     * @param offsets: List에서 사용자가 스와이프하여 삭제한 항목의 인덱스
     */
    func deleteRecord(at offsets: IndexSet) {
        intakeRecords.remove(atOffsets: offsets)
        saveRecords() // 변경 사항을 UserDefaults에 저장
    }

    /**
     * [기능 5] 일일 초기화 기능
     * 앱 실행 시 마지막 기록 날짜를 확인하여, 오늘이 아니면 데이터를 초기화합니다.
     */
    func checkForDailyReset() {
        // 저장된 기록이 없으면 함수 종료
        guard let firstRecord = intakeRecords.first else { return }
        
        // 마지막 기록의 날짜가 오늘(isDateInToday)이 아니면
        if !Calendar.current.isDateInToday(firstRecord.date) {
            // 모든 기록을 삭제
            intakeRecords.removeAll()
            saveRecords() // 비워진 상태를 UserDefaults에 저장
        }
    }
    
    /**
     * [설정] 오늘 기록 모두 삭제
     * 설정 화면의 '오늘 기록 초기화' 버튼과 연결됩니다.
     */
    func clearTodayRecords() {
        intakeRecords.removeAll()
        saveRecords()
    }

    // MARK: - 6. 데이터 영속성 (Persistence)
    
    /**
     * [저장] 현재 섭취 기록(intakeRecords)을 JSON 형태로 변환하여 UserDefaults에 저장합니다.
     */
    private func saveRecords() {
        do {
            // Codable 객체 배열을 JSON 데이터로 인코딩
            let encodedData = try JSONEncoder().encode(intakeRecords)
            UserDefaults.standard.set(encodedData, forKey: recordsKey)
        } catch {
            print("데이터 저장 실패: \(error.localizedDescription)")
        }
    }
    
    /**
     * [불러오기] 앱 실행 시 UserDefaults에 저장된 JSON 데이터를 불러와 intakeRecords 배열을 복원합니다.
     */
    private func loadRecords() {
        guard let savedData = UserDefaults.standard.data(forKey: recordsKey) else { return }
        
        do {
            // JSON 데이터를 Codable 객체 배열로 디코딩
            let decodedRecords = try JSONDecoder().decode([WaterIntakeRecord].self, from: savedData)
            self.intakeRecords = decodedRecords
        } catch {
            print("데이터 불러오기 실패: \(error.localizedDescription)")
        }
    }
}
