import SwiftUI

struct MainContentView: View {
    // WaterLogApp에서 주입(inject)한 viewModel을 받아서 사용합니다.
    @EnvironmentObject var viewModel: WaterDataViewModel

    var body: some View {
        // [기능] 5주차 Navigation: 화면 이동을 위한 NavigationStack
        NavigationStack {
            VStack(spacing: 20) {
                
                // MARK: - 1. 진행률 시각화 (핵심 영역)
                // 6주차 Custom UI: ZStack을 활용한 원형 그래프
                CircularProgressView(
                    progress: viewModel.progressPercentage,
                    totalIntake: viewModel.totalIntakeToday,
                    targetGoal: viewModel.targetGoal
                )
                .frame(width: 250, height: 250) // 크기 지정
                .padding(.top, 30)

                // MARK: - 2. 섭취량 추가 버튼
                // 1주차 Layout: HStack으로 버튼들을 가로 배치
                HStack(spacing: 20) {
                    // 2주차 Button: 버튼 클릭 시 viewModel의 addWater 함수 호출
                    DrinkButton(amount: 100)
                    DrinkButton(amount: 250)
                    DrinkButton(amount: 500)
                }
                .padding(.horizontal)

                // MARK: - 3. 시간별 기록 리스트
                // 2주차 List: viewModel의 intakeRecords 배열을 표시
                List {
                    // [기능 4] 시간별 기록 리스트
                    ForEach(viewModel.intakeRecords) { record in
                        HStack {
                            // 날짜 포맷팅
                            Text(record.date, style: .time)
                                .font(.headline)
                                .frame(width: 80, alignment: .leading)
                            
                            // 섭취량
                            Text("\(record.amount, specifier: "%.0f") ml")
                                .font(.body)
                        }
                    }
                    // [기능 4-1] 스와이프하여 삭제
                    .onDelete(perform: viewModel.deleteRecord)
                }
                .listStyle(.plain) // 기본 리스트 스타일
                .frame(maxHeight: .infinity) // 리스트가 남은 공간을 모두 차지하도록
                
                Spacer()
            }
            .navigationTitle("WaterLog") // 상단 네비게이션 바 제목
            .toolbar {
                // 우측 상단 설정 버튼
                ToolbarItem(placement: .navigationBarTrailing) {
                    // 5주차 NavigationLink: 클릭 시 SettingsView로 이동
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .font(.title2)
                            .foregroundStyle(.blue) // .foregroundColor(.blue) 대신 권장됨
                    }
                }
            }
            .onAppear {
                // [기능 5] 뷰가 나타날 때마다 일일 초기화가 필요한지 체크
                viewModel.checkForDailyReset()
            }
        }
    }
}

// MARK: - 메인 화면 하단의 음료 추가 버튼 (Sub-View)
struct DrinkButton: View {
    @EnvironmentObject var viewModel: WaterDataViewModel
    let amount: Double

    var body: some View {
        Button(action: {
            // 버튼 클릭 시 viewModel의 addWater 함수 호출
            viewModel.addWater(amount: amount)
        }) {
            Text("+\(amount, specifier: "%.0f") ml")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity) // 버튼이 가로로 꽉 차게
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
                .shadow(radius: 5)
        }
    }
}

// Xcode 미리보기용 (Preview)
struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
            // 미리보기에서도 viewModel이 필요하므로 가짜(dummy) viewModel을 주입
            .environmentObject(WaterDataViewModel())
    }
}
