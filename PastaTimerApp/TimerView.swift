//
//  TimerView.swift
//  PastaTimerApp
//
//  Created by 안윤진 on 2023/02/22.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel: EnvironmentViewModel //주석 1 참고
    @State var secondsLeft: Int = 0
    @State var timer: Timer?
    @State var isTimerActive: Bool = false //타이머를 활성화하는 변수
    var timeLimit: Int = 100
    var selectedIndex: Int = 0 { //선택된 파스타 버튼의 인덱스
    didSet {
                    // selectedIndex가 바뀌면 초기화
                    self.secondsLeft = viewModel.time[selectedIndex]
                    self.timeLimit = viewModel.time[selectedIndex]
                    self.timer?.invalidate()
                    self.isTimerActive = false
                }
    }

    init(viewModel: EnvironmentViewModel) {
        //viewModel을 인자로 받아 초기화
                self.viewModel = viewModel //주석 1: StateObject로 받으면 self.~으로 초기화할 수 없어서 ObservedObject로 선언
                self.selectedIndex = viewModel.isClicked.firstIndex(of: true) ?? 0
                _secondsLeft = State(initialValue: viewModel.time[selectedIndex])
                timeLimit = viewModel.time[selectedIndex]
            }
    
    var body: some View{
        VStack{
            Text("\(secondsLeftToMinutesSeconds(seconds:secondsLeft))")
                .font(.system(size: 64, weight: .semibold))
                .foregroundColor(Color("outline"))
                .multilineTextAlignment(.center)
            Spacer()
            HStack(spacing:16){
                Button(action: {
                    self.secondsLeft = timeLimit
                    isTimerActive = false
                }){
                    Image("resetIcon")
                        .resizable()
                        .frame(width: 22.0, height: 22.0)
                }.buttonStyle(SubButton())
                
                Button(action: {
                    if !isTimerActive {
                        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            if secondsLeft > 0 {
                                secondsLeft -= 1
                            } else {
                                //0초 이하의 시간이 남았다면 멈춤
                                timer?.invalidate()
                                isTimerActive = false
                            }
                        }
                        isTimerActive = true
                    }
                }){
                   Image("startIcon")
                        .resizable()
                        .frame(width: 22.0, height: 22.0)
                }.buttonStyle(StartButton())
                
                Button(action: {
                    // 타이머 멈춤
                    timer?.invalidate()
                    isTimerActive = false
                }) {
                    Image("pauseIcon")
                        .resizable()
                        .frame(width: 22.0, height: 22.0)
                }.buttonStyle(SubButton())
            }
        }
    }
    //초를 받아 분:초 스트링으로 바꿔 변환
            func secondsLeftToMinutesSeconds(seconds: Int) -> String {
                let minutes = (seconds % 3600) / 60
                let seconds = (seconds % 3600) % 60
                return String(format: "%02d:%02d", minutes, seconds)
            }
            
        }


//버튼 스타일
struct StartButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 128, height: 96)
            .foregroundColor(Color.black)
            .background(Color("pink"))
            .cornerRadius(32)
        
        
    }
}

struct SubButton: ButtonStyle {
func makeBody(configuration: Configuration) -> some View {
    configuration.label
        .frame(width: 80, height: 80)
        .foregroundColor(Color.black)
        .background(Color("lightpink"))
        .cornerRadius(24)
        
        
}
}
