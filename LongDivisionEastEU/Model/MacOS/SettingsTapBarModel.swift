//
//  SettingsTapBar.swift
//  LongDivisionEastEU
//
//  Created by Anatolii Kravchuk on 12.02.2024.
//

import SwiftUI

class SettingsTabBarModel: ObservableObject {
    @Published var activeBar: Tab = .back
    @Published private(set) var isTabBarAddded: Bool = false
    private var id: String = UUID().uuidString
    
    
    func addTabBar() {
        guard !isTabBarAddded else {return}
        
        if let applicationWindow = NSApplication.shared.mainWindow {
            let customTabBar = NSHostingView(rootView: FloatingTabBarView().environmentObject(self))
            let floatingWindow = NSWindow()
            floatingWindow.styleMask = .borderless
            floatingWindow.contentView = customTabBar
            floatingWindow.backgroundColor = .clear
            floatingWindow.title = id
            
            let windowSize = applicationWindow.frame.size
            let windowOrigin = applicationWindow.frame.origin
            
            floatingWindow.setFrameOrigin(.init(x: windowOrigin.x - 50,
                                                y: windowOrigin.y + (windowSize.height - 180) / 2))
            
            applicationWindow.addChildWindow(floatingWindow, ordered: .above)
        } else {
            print("No window dound")
        }
    }
    
    func updateTabPosition() {
        if let floatingWindow = NSApplication.shared.windows.first(where: { $0.title == id }),
           let applicationWindow = NSApplication.shared.mainWindow {
            let windowSize = applicationWindow.frame.size
            let windowOrigin = applicationWindow.frame.origin
            
            floatingWindow.setFrameOrigin(.init(x: windowOrigin.x - 50,
                                                y: windowOrigin.y + (windowSize.height - 180) / 2))
        }
    }
}



enum Tab: String, CaseIterable {
    case back = "rectangle.portrait.and.arrow.forward"
    case size = "arrowshape.left.arrowshape.right"
    case colorPick = "paintpalette"
}

struct HideTabBar: NSViewRepresentable {
    func updateNSView(_ nsView: NSViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if let tabView = nsView.superview?.superview?.superview as? NSTabView {
                tabView.tabViewType = .noTabsNoBorder
                tabView.tabViewBorderType = .none
                tabView.tabPosition = .none
            }
        }
    }
    
    func makeNSView(context: Context) -> some NSView {
        return .init()
    }
    
    
}

fileprivate struct FloatingTabBarView: View {
    @EnvironmentObject var tabModel: SettingsTabBarModel
    @Namespace private var animation
    private let animationID: UUID = .init()
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Button {
                    tabModel.activeBar = tab
                } label: {
                    Image(systemName: tab.rawValue)
                        .font(.title3)
                        .foregroundStyle(tabModel.activeBar == tab ? .primary : Color.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background {
                            if tabModel.activeBar == tab {
                                Circle()
                                    .fill(Color.gray.opacity(0.7))
                                    .matchedGeometryEffect(id: animationID, in: animation)
                            }
                        }
                        .contentShape(.rect)
                        .animation(.bouncy, value: tabModel.activeBar)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(5)
        .frame(width: 45, height: 180)
        .windowBackground()
        .clipShape(.capsule)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: 50)
        .contentShape(.capsule)
    }
}

extension View {
    @ViewBuilder
    func customOnChange<Value: Equatable> (value: Value, result: @escaping (Value) -> ()) -> some View {
        if #available(macOS 14, *) {
            self
                .onChange(of: value) { oldValue, newValue in
                    result(newValue)
                }
        } else {
            self
                .onChange(of: value, perform: result)
                }
        }
    //Background:
    @ViewBuilder
    func windowBackground() -> some View {
        if #available(macOS 14, *) {
            self
                .background(Color.background)
        } else {
            self
                .background(.background)
        }
    }
    
    }

