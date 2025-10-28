import SwiftUI

/**
 * @struct CircularProgressView
 * 6주차 강의 자료(roontams.tistory.com/13)를 참고하여 만든
 * 커스텀 원형 프로그레스 바(View)입니다.
 */
struct CircularProgressView: View {
    
    // 입력값
    let progress: Double     // 진행률 (0.0 ~ 1.0)
    let totalIntake: Double  // 현재 섭취량
    let targetGoal: Double   // 목표 섭취량

    var body: some View {
        // [기능] 1주차 Layout: ZStack으로 뷰들을 겹침
        ZStack {
            // 1. 배경 원 (회색)
            Circle()
                .stroke(
                    Color.gray.opacity(0.3),
                    lineWidth: 30
                )

            // 2. 진행률 원 (파란색)
            Circle()
                // .trim: 원의 일부만 그리도록 함
                // from: 0.0 (시작점, 12시 방향)
                // to: progress (진행률 값)
                .trim(from: 0.0, to: progress)
                .stroke(
                    Color.blue,
                    style: StrokeStyle(lineWidth: 30, lineCap: .round) // 둥근 끝 처리
                )
                .rotationEffect(.degrees(-90)) // 12시 방향에서 시작하도록 회전
                .animation(.easeOut, value: progress) // 진행률 변경 시 부드러운 애니메이션

            // 3. 중앙 텍스트
            // [기능 3] 진행률 시각화 (텍스트)
            VStack(spacing: 10) {
                Text("\(totalIntake, specifier: "%.0f") ml")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("/ \(targetGoal, specifier: "%.0f") ml")
                    .font(.headline)
                    .foregroundStyle(.gray)
                
                Text("\(progress * 100, specifier: "%.0f")% 달성!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
                    .padding(.top, 5)
            }
        }
    }
}

// Xcode 미리보기용 (Preview)
struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        // 60% 진행된 상태를 미리보기
        CircularProgressView(progress: 0.6, totalIntake: 1200, targetGoal: 2000)
            .frame(width: 200, height: 200)
    }
}
