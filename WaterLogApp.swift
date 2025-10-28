import SwiftUI

@main
struct WaterLogApp: App {
    /**
     * @StateObject: 앱의 생명주기(App Life Cycle) 동안
     * WaterDataViewModel 인스턴스를 '단 한 번' 생성하고,
     * 앱 전역에서 이 데이터를 관리하도록 합니다.
     */
    @StateObject private var viewModel = WaterDataViewModel()

    var body: some Scene {
        WindowGroup {
            // MainContentView를 앱의 첫 화면으로 지정합니다.
            MainContentView()
                /**
                 * .environmentObject(viewModel):
                 * MainContentView 및 그 하위의 모든 View(e.g., SettingsView)에서
                 * 'viewModel'을 쉽게 공유하고 접근할 수 있도록 주입해줍니다. (3-4주차 MVVM)
                 */
                .environmentObject(viewModel)
        }
    }
}
