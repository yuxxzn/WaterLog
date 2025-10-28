# WaterLog: 물 마시기 트래커 SwiftUI 앱
AI와의 협업을 통해 개발한 SwiftUI 기반 일일 물 섭취량 추적 앱입니다. (중간고사 과제)

1. 앱 소개 (Introduction)
WaterLog는 사용자가 일일 물 섭취량을 쉽게 기록하고, 설정한 목표를 달성할 수 있도록 도와주는 간단하고 직관적인 건강 관리 앱입니다. MVVM 아키텍처를 기반으로 SwiftUI를 사용하여 개발

2. 주요 기능 (Key Features)
본 앱은 과제에서 요구하는 5가지 필수 기능을 구현

1) 목표 섭취량 설정 (Goal Setting)
설정 화면(SettingsView)에서 슬라이더를 이용해 500ml부터 5000ml까지 일일 목표 섭취량을 100ml 단위로 설정할 수 있다.
설정된 값은 @AppStorage를 통해 앱을 종료해도 유지

2) 물 마신 양 추가 (Add Intake)
메인 화면(MainContentView)에서 +100ml, +250ml, +500ml 버튼 클릭 한 번으로 간편하게 섭취량을 추가할 수 있다.

3) 진행률 시각화 (Progress Visualization)
메인 화면 중앙에 커스텀 CircularProgressView를 배치하여, 목표 대비 현재 섭취량을 원형 그래프와 퍼센티지(%)로 한눈에 보여준다.
섭취량 추가 시 그래프가 부드러운 애니메이션과 함께 즉시 업데이트

4. 시간별 기록 리스트 (Timestamped List)
메인 화면 하단의 List에 오늘 물을 마신 모든 기록이 시간 역순(최신순)으로 표시 ([14:35] - 250ml)
WaterIntakeRecord 모델을 사용하여 개별 섭취 시간과 용량을 모두 저장
항목을 스와이프하여 개별 기록을 삭제할 수 있다. (.onDelete)

5. 일일 초기화 기능 (Daily Reset)
앱 실행 시(onAppear) 마지막 기록의 날짜와 오늘 날짜를 비교
날짜가 변경되면(!isDateInToday) 모든 섭취 기록(intakeRecords)을 자동으로 비워 새로운 날을 시작

3. 기술 스택 (Tech Stack)
UI Framework: SwiftUI
Architecture: MVVM (Model-View-ViewModel)
State Management:
  @StateObject: 앱 전역의 WaterDataViewModel 인스턴스 관리
  @EnvironmentObject: 뷰 계층 간 ViewModel 공유
  @Published: 섭취 기록 배열(intakeRecords) 변경 시 UI 자동 업데이트

Data Persistence:
  @AppStorage (UserDefaults): 사용자의 목표 섭취량(targetGoal) 영구 저장
  JSONEncoder / JSONDecoder (Codable): 섭취 기록 배열(intakeRecords)을 JSON으로 변환하여 UserDefaults에 저장
Language: Swift
Asynchronous Programming: Combine (for ObservableObject)

4. 프로젝트 구조 (Project Structure)

본 프로젝트는 MVVM 아키텍처에 따라 파일을 그룹화했습니다.

WaterLog/
├── WaterLogApp.swift       (앱 진입점, ViewModel 초기화)
|
├── Model/
│   └── WaterIntakeRecord.swift (데이터 모델 정의)
|
├── ViewModel/
│   └── WaterDataViewModel.swift (앱의 모든 로직, 데이터 관리)
|
└── View/
    ├── MainContentView.swift    (메인 화면 UI)
    ├── SettingsView.swift     (설정 화면 UI)
    └── CircularProgressView.swift (커스텀 원형 그래프 UI)
