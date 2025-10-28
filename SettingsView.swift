import SwiftUI

struct SettingsView: View {
    // MainContentView와 동일한 viewModel을 공유합니다.
    @EnvironmentObject var viewModel: WaterDataViewModel

    var body: some View {
        // [기능] 2주차 Form: 설정 항목들을 깔끔하게 그룹화
        Form {
            // MARK: - 1. 목표 섭취량 설정
            Section(header: Text("일일 목표 섭취량")) {
                VStack(alignment: .leading) {
                    Text("\(viewModel.targetGoal, specifier: "%.0f") ml")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    /**
                     * [기능 1] 목표 물 섭취량 설정
                     * Slider: viewModel의 targetGoal 값을 500 ~ 5000 사이에서 조절
                     *
                     * @AppStorage로 선언된 targetGoal은
                     * 값이 변경되는 즉시 UserDefaults에 자동 저장됩니다.
                     */
                    Slider(
                        value: $viewModel.targetGoal,
                        in: 500...5000, // 최소 500ml ~ 최대 5000ml
                        step: 100 // 100ml 단위로 조절
                    )
                }
                .padding(.vertical, 10)
            }
            
            // MARK: - 2. 데이터 관리
            Section(header: Text("데이터 관리")) {
                // 오늘 기록 초기화 버튼
                Button(action: {
                    // [설정] 오늘 기록 초기화
                    viewModel.clearTodayRecords()
                }) {
                    Text("오늘 기록 모두 삭제")
                        .foregroundStyle(.red) // .foregroundColor(.red) 대신 권장됨
                }
            }
            
            // MARK: - 3. 앱 정보 (선택 사항)
            Section(header: Text("앱 정보")) {
                HStack {
                    Text("버전")
                    Spacer()
                    Text("1.0.0")
                        .foregroundStyle(.gray)
                }
            }
        }
        .navigationTitle("설정") // 네비게이션 바 제목
        .navigationBarTitleDisplayMode(.inline) // 제목을 상단 중앙에 작게 표시
    }
}

// Xcode 미리보기용 (Preview)
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        // SettingsView는 NavigationStack 안에서 봐야 자연스럽습니다.
        NavigationStack {
            SettingsView()
                .environmentObject(WaterDataViewModel())
        }
    }
}
