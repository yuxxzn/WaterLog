import Foundation

/**
 * @struct WaterIntakeRecord
 * 개별 물 섭취 기록을 위한 데이터 모델입니다.
 *
 * @property id: UUID - 리스트(List)에서 각 항목을 고유하게 식별하기 위해 필요합니다. (Identifiable)
 * @property amount: Double - 섭취량 (ml)
 * @property date: Date - 섭취 시간
 *
 * @conforms Identifiable: SwiftUI 리스트에서 객체를 고유하게 식별할 수 있게 합니다.
 * @conforms Codable: UserDefaults에 JSON 형태로 쉽게 저장하고 불러오기 위해 필요합니다.
 */
struct WaterIntakeRecord: Identifiable, Codable {
    var id: UUID = UUID()
    let amount: Double
    let date: Date
}
