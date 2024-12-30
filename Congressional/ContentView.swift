//
//  ContentView.swift
//  Congressional
//
//  Created by Saathvik Valvekar on 12/19/24.
//
import SwiftUI
import Charts
import UserNotifications
import UIKit
import AVFoundation


@main
struct FinancialApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        UITabBar.appearance().barTintColor = UIColor.black
    }
    
    var body: some View {
        ZStack {
            TabView {
                TutorialsView()
                    .tabItem {
                        Label("Courses", systemImage: "book.fill")
                    }
                QuizView()
                    .tabItem {
                        Label("Quizzes", systemImage: "questionmark.circle.fill")
                    }
                }
            .accentColor(.red)
        }
    }
}

struct TutorialsView: View {
    let tutorialTopics = ["Budgeting", "Investing", "Credit Score", "Saving", "Spending"]
    let tutorialSubsections = [
        "Budgeting": 6,
        "Investing": 5,
        "Credit Score": 4,
        "Saving": 4,
        "Spending": 4
    ]
    
    @State private var viewedSections = Array(repeating: Set<Int>(), count: 5)
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Courses")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 45)
                    Spacer(minLength: 20)
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(0..<tutorialTopics.count, id: \.self) { index in
                                NavigationLink(destination: TutorialDetailView(
                                    topic: tutorialTopics[index],
                                    numSubsections: tutorialSubsections[tutorialTopics[index]] ?? 0,
                                    viewedSections: $viewedSections[index])) {
                                        tutorialButton(
                                            title: tutorialTopics[index],
                                            index: index + 1,
                                            numSubsections: tutorialSubsections[tutorialTopics[index]] ?? 0,
                                            viewedSections: $viewedSections[index]
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
    
    private func tutorialButton(title: String, index: Int, numSubsections: Int, viewedSections: Binding<Set<Int>>) -> some View {
        HStack {
            NavigationLink(destination: StoryModeView(topic: title)) { // Navigate to StoryModeView
                Rectangle()
                    .fill(colorForIndexLight(index))
                    .frame(width: 50) // Keep the color strip size the same
                    .cornerRadius(5)
                    .overlay(
                        Image(systemName: "bubble.left.and.bubble.right.fill") // Use an appropriate SF Symbol
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25) // Adjust the icon size as needed
                            .foregroundColor(.white)
                    )
            }
            VStack(alignment: .center) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 5)
                HStack(spacing: 7) {
                    Spacer()
                    ForEach(0..<numSubsections, id: \.self) { subIndex in
                        Circle()
                            .fill(viewedSections.wrappedValue.contains(subIndex) ? Color.white : Color.gray)
                            .frame(width: 13, height: 15)
                            .onTapGesture {
                                viewedSections.wrappedValue.insert(subIndex)
                            }
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, minHeight: 200)
            .background(colorForIndex(index))
            .cornerRadius(10)
            .padding(.leading, 5)
        }
        .cornerRadius(10)
    }



    
    private func colorForIndex(_ index: Int) -> Color {
        switch index {
        case 1:
            return Color.purple.opacity(0.8)
        case 2:
            return Color(red: 0.7, green: 0.2, blue: 0)
        case 3:
            return Color(red: 0.0, green: 0.6, blue: 0.6)
        case 4:
            return Color(red: 0.3, green: 0.8, blue: 0.5)
        case 5:
            return Color(red: 0.7, green: 0.0, blue: 0.1)
        default:
            return Color.clear
        }
    }
    
    private func colorForIndexLight(_ index: Int) -> Color {
        switch index {
        case 1:
            return Color.purple.opacity(0.4)
        case 2:
            return Color(red: 1.0, green: 0.6, blue: 0.5)
        case 3:
            return Color(red: 0.4, green: 0.8, blue: 0.8)
        case 4:
            return Color(red: 0.5, green: 0.9, blue: 0.7)
        case 5:
            return Color(red: 0.9, green: 0.3, blue: 0.4)
        default:
            return Color.clear
        }
    }
}

struct TutorialDetailView: View {
    var topic: String
    var numSubsections: Int
    @Binding var viewedSections: Set<Int>
    @State private var currentSection = 0
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Text("\(topic) - Section \(currentSection + 1)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                
                SubTopicView(title: getSectionTitle(), content: getSectionContent())
                    .foregroundColor(.white)
                
                HStack {
                    if currentSection > 0 {
                        Button(action: {
                            currentSection -= 1
                        }) {
                            Text("Back")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                    Spacer()
                    if currentSection < numSubsections - 1 {
                        Button(action: {
                            viewedSections.insert(currentSection) // Mark as viewed
                            currentSection += 1
                        }) {
                            Text("Next")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            if viewedSections.isEmpty {
                viewedSections.insert(0) // Mark the first section as viewed
            }
        }
    }
    
    private func getSectionTitle() -> String {
        switch topic {
        case "Budgeting":
            return ["Income Management", "Expense Categorization", "Fixed vs. Variable Expenses", "Savings Allocation", "Debt Management", "Emergency Fund Planning"][currentSection]
        case "Investing":
            return ["Investment Types", "Risk Tolerance Assessment", "Time Horizon Planning", "Portfolio Diversification", "Tracking and Rebalancing"][currentSection]
        case "Credit Score":
            return ["Benefit of a Good Credit Score", "Building Credit", "Maintaining a Credit Score", "Improving a Low Credit Score"][currentSection]
        case "Saving":
            return ["Types of Savings Accounts", "Creating a Savings Plan", "Short Term vs. Long Term Savings", "Compound and Simple Interest"][currentSection]
        case "Spending":
            return ["Tracking Spending", "Needs vs. Wants", "Spending Limits", "Impulse Purchases"][currentSection]
        default:
            return ""
        }
    }
    
    private func getSectionContent() -> String {
        switch topic {
        case "Budgeting":
            return [
                "Income management involves understanding your sources of income and ensuring your spending stays below your income. Regularly track your earnings and plan how to allocate them effectively. Set priorities for expenses and allocate parts of your income to different categories such as saving, spending, and investing.",
                "Categorizing expenses is essential for financial awareness and control. Common categories include food, rent, transportation, and entertainment. Tracking expenses by category allows for better decisions about saving and spending. You can also spot patterns where small, frequent expenses, like Starbucks runs, accumulate over time, and take steps to reduce those costs.",
                "Fixed expenses are expenses that remain the same each month and are consistent, recurring costs. Examples include rent payments, car payments, and subscriptions. Since they are predictable, fixed expenses are easier to plan for and should be prioritized in your budget. Variable expenses fluctuate each month and require careful monitoring to prevent overspending.",
                "Savings allocation involves determining how much money should be set aside for future goals. This includes establishing an emergency fund, saving for short-term purchases, and planning for long-term investments. Assessing your current financial situation will help determine the appropriate amounts to save.",
                "Debt management is about keeping your debt under control and working towards paying it off. Focus on high-interest debts first, like credit cards. Consider strategies such as the snowball method, where you pay off smaller debts first, or the avalanche method, where you prioritize debts with higher interest rates.",
                "Emergency funds are savings set aside to cover unexpected expenses or loss of income. Aim for 3-6 months' worth of living expenses. This fund helps reduce financial stress and provides a safety net during difficult times."
            ][currentSection]
        case "Investing":
            return [
                "Investment types vary, including stocks, bonds, mutual funds, and real estate. Each has different risk levels and potential returns. It's essential to understand these types before investing your money.",
                "Assessing your risk tolerance helps determine how much risk you can handle in your investments. Higher-risk investments may yield higher returns but also come with more volatility.",
                "Time horizon planning refers to how long you plan to invest before needing access to the money. Longer time horizons generally allow for more aggressive investment strategies, while shorter time frames might necessitate more conservative approaches.",
                "Portfolio diversification involves spreading your investments across different asset classes to reduce risk. It can help protect your portfolio from significant losses during market downturns.",
                "Tracking and rebalancing your portfolio ensures it aligns with your investment goals and risk tolerance. Regularly reviewing your investments allows you to adjust your strategy as needed."
            ][currentSection]
        case "Credit Score":
            return [
                "A good credit score can save you money through lower interest rates on loans and credit cards. It also helps in securing rental agreements and job opportunities. Additionally, a strong credit score can lead to better insurance rates and higher chances of loan approval.",
                "Building credit involves using credit responsibly. Start with a secured credit card or a small loan, and ensure you make payments on time to establish a positive credit history. Over time, this will demonstrate to lenders that you can manage credit effectively.",
                "Maintaining a good credit score requires consistent on-time payments, keeping credit utilization low, and avoiding unnecessary credit inquiries. Regularly reviewing your credit report to check for errors or discrepancies is also important in sustaining a healthy score.",
                "Improving a low credit score can be achieved by paying off debts, ensuring timely payments, and avoiding new debt until the score improves."
            ][currentSection]
        case "Saving":
            return [
                "Types of savings accounts include traditional savings, high-yield savings, and money market accounts. Each offers different interest rates and accessibility features.",
                "Creating a savings plan involves setting clear goals and determining how much to save each month. Automating savings through direct deposit can help you stay on track.",
                "Short-term savings are intended for immediate needs, while long-term savings focus on future goals like retirement. Understanding your goals will guide your saving strategy.",
                "Compound interest can significantly increase your savings over time. The sooner you start saving, the more you benefit from compound interest."
            ][currentSection]
        case "Spending":
            return [
                "Tracking your spending is essential for maintaining financial health. Use apps or spreadsheets to log expenses, helping you identify spending patterns.",
                "Differentiating needs from wants helps prioritize spending. Focus on necessities first before allocating funds for wants.",
                "Setting spending limits helps avoid overspending and ensures you stay within budget. Adjust your budget as necessary based on spending habits.",
                "Impulse purchases can derail budgets. Implement strategies like the 24-hour rule to delay purchases and ensure they align with your financial goals."
            ][currentSection]
        default:
            return ""
        }
    }
}


struct StoryModeView: View {
    var topic: String
    @State private var isVoiceEnabled = true // State to manage voice on/off

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Text("\(topic) - Story Mode")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()

                ScrollView {
                    Text("Welcome to the \(topic) Story Mode!")
                        .foregroundColor(.white)
                        .font(.system(size: 30)) // Increased font size
                        .padding()

                    Text("Here you can learn about budgeting through an interactive conversation.")
                        .foregroundColor(.white)
                        .font(.system(size: 24)) // Increased font size
                        .padding()

                    // Toggle button for voice
                    Button(action: {
                        isVoiceEnabled.toggle() // Toggle the voice state
                    }) {
                        Image(systemName: isVoiceEnabled ? "speaker.2.fill" : "speaker.slash.fill") // Icon changes based on state
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(isVoiceEnabled ? .green : .red) // Green for on, red for off
                    }
                    .padding() // Padding around the button

                    NavigationLink(destination: BudgetingConversationView(isVoiceEnabled: isVoiceEnabled)) {
                        Text("Start the Budgeting Conversation")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .font(.system(size: 24)) // Increased font size
                    }
                    .padding()
                }
            }
        }
    }
}


struct BudgetingConversationView: View {
    @State private var currentMessageIndex = 0
    private let speechSynthesizer = AVSpeechSynthesizer() // Create speech synthesizer instance
    var isVoiceEnabled: Bool // New property to manage voice state

    let budgetingMessages = [
        ("Father", "Hey, son, do you have a minute? I want to talk to you about something important."),
        ("Son", "Sure, Dad. What’s up?"),
        ("Father", "Well, I was thinking it’s time we talk about managing your income. You know, once you start earning, whether from a part-time job, allowance, or later when you start working full-time, you’ll need to understand how to handle it."),
        ("Son", "Oh, like budgeting and stuff?"),
        ("Father", "Exactly! Think of it this way—your income is like a pie, and you’ve got to decide how to slice it up."),
        ("Son", "That sounds interesting. What do you mean by slicing it?"),
        ("Father", "Well, some of it should go towards savings, some for spending, and maybe even a little for fun. It's about balancing your needs and wants."),
        ("Son", "I get that. How much should I save?"),
        ("Father", "A good rule is to save about 20% of what you earn. This helps you build a safety net for the future."),
        ("Son", "What if I want to buy something right now?"),
        ("Father", "You can do that too! Just make sure you budget for it. If you plan ahead, you can save up for bigger purchases."),
        ("Son", "Okay, so I’ll keep track of what I earn and spend?"),
        ("Father", "Exactly! You can use an app or a simple notebook. Tracking your income will help you see where your money goes."),
        ("Son", "Got it! Thanks for the advice, Dad. I’ll start budgeting right away."),
        ("Father", "I’m proud of you, son. Managing money well is an important skill for life!")
    ]
    let investingMessages = [
        ("Father", "Hey, son, have you ever thought about investing?"),
        ("Son", "Investing? Like in stocks and stuff?"),
        ("Father", "Exactly. Investing is a way to grow your money over time. Instead of just saving it, you can make it work for you."),
        ("Son", "How does that work?"),
        ("Father", "Well, when you invest in things like stocks, bonds, or mutual funds, you're essentially putting your money into companies or assets that can grow in value."),
        ("Son", "So, it’s kind of like a long-term savings plan?"),
        ("Father", "Yes, but with the potential to earn more. The key is to start early and be patient. Over time, the value of your investments can grow."),
        ("Son", "That sounds cool, but isn’t it risky?"),
        ("Father", "There’s always some risk, but you can manage it by diversifying—spreading your investments across different areas to minimize loss."),
        ("Son", "How do I know what to invest in?"),
        ("Father", "You can start small, maybe with a mutual fund or an app that lets you invest in fractional shares. Always do your research and understand what you're putting your money into."),
        ("Son", "Okay, I’ll look into it. It sounds like a smart way to plan for the future."),
        ("Father", "It is, son. The earlier you start, the more time your money has to grow.")
    ]
    let creditScoreMessages = [
        ("Father", "Son, have you ever heard of a credit score?"),
        ("Son", "Yeah, I’ve heard about it, but what exactly is it?"),
        ("Father", "A credit score is a number that shows how responsible you are with borrowing money. It helps lenders decide if they can trust you to pay back what you owe."),
        ("Son", "Why is it so important?"),
        ("Father", "Because when you want to borrow money for things like a car or a house, or even get a credit card, your credit score will determine if you get approved and what interest rates you’ll pay."),
        ("Son", "Okay, how do I get a good credit score?"),
        ("Father", "It’s all about being responsible with credit. Pay your bills on time, keep your credit card balances low, and avoid taking on too much debt."),
        ("Son", "Does applying for a lot of credit hurt my score?"),
        ("Father", "Yes, too many applications for credit can lower your score. It’s better to apply only when you really need it."),
        ("Son", "What’s a good score to aim for?"),
        ("Father", "A score of 700 or above is generally considered good. The higher your score, the better financial opportunities you’ll have."),
        ("Son", "Got it. I’ll make sure to keep my score in check."),
        ("Father", "Good! A strong credit score is a valuable tool in managing your financial future.")
    ]
    let savingMessages = [
        ("Father", "Hey son, have you thought about building up your savings?"),
        ("Son", "I’ve saved a little, but it’s not much."),
        ("Father", "That’s okay. The important thing is to start. Savings are crucial for emergencies and for bigger goals you might have."),
        ("Son", "What kind of emergencies are you talking about?"),
        ("Father", "Unexpected expenses, like car repairs or medical bills. Having money set aside can help you avoid debt when things like that come up."),
        ("Son", "How much should I have saved?"),
        ("Father", "A good rule is to have at least 3 to 6 months' worth of living expenses saved up. Start small, but aim to build it up over time."),
        ("Son", "Should I save for other things too?"),
        ("Father", "Definitely. You can save for things like vacations, a new phone, or even long-term goals like buying a house."),
        ("Son", "What’s the best way to save?"),
        ("Father", "Set up an automatic transfer to a savings account whenever you get paid. That way, you’re saving without thinking about it."),
        ("Son", "That makes sense. I’ll start automating my savings."),
        ("Father", "Good plan! Consistent saving is the foundation of financial security.")
    ]
    let spendingMessages = [
        ("Father", "Son, have you ever thought about how you spend your money?"),
        ("Son", "Yeah, I try not to spend too much, but it’s hard sometimes."),
        ("Father", "It can be, but managing your spending is just as important as earning and saving. You need to make sure you’re spending on what truly matters."),
        ("Son", "How do I know if I’m spending too much?"),
        ("Father", "One way is to track your spending for a month. Write down everything you buy. You’ll start to see where your money goes."),
        ("Son", "That sounds helpful. But what if I want to buy something I really like?"),
        ("Father", "It’s okay to spend on things you enjoy, but the key is balance. Make sure you’re not overspending on wants while ignoring needs."),
        ("Son", "Got it. So I need to prioritize."),
        ("Father", "Exactly. Make sure you cover your essential expenses like bills and groceries first. Then, if you have money left, you can treat yourself."),
        ("Son", "That makes sense. I’ll try to be more mindful of how I spend."),
        ("Father", "Great! Smart spending habits will help you avoid unnecessary debt and build a strong financial foundation.")
    ]


    var body: some View {
        ZStack {
            // Wood grain background image
            Image("background-wood-grain")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer() // Move everything down a bit by adding space at the top

                // Characters at the top with animation
                HStack {
                    // Father on the left
                    Image("Cartoon_Dad")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 225, height: 225) // Bigger size

                    Spacer()

                    // Son on the right
                    Image("Cartoon_Son")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 225, height: 225) // Bigger size
                }
                .animation(.easeInOut(duration: 0.5)) // Smooth animation for character transitions

                // Conversation text in the middle
                VStack {
                    Text(budgetingMessages[currentMessageIndex].0)
                        .font(.system(size: 25)) // Lowered font size for speaker name
                        .foregroundColor(.white)

                    Text(budgetingMessages[currentMessageIndex].1)
                        .font(.system(size: 20)) // Lowered font size for conversation
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center) // Center-align text
                        .padding(.horizontal, 40) // Add horizontal padding to prevent text cutoff
                }
                .onAppear {
                    if isVoiceEnabled {
                        speakText(for: budgetingMessages[currentMessageIndex]) // Speak the first message when the view appears if voice is enabled
                    }
                }

                Spacer() // Move the conversation text down a bit

                // Next and Back buttons moved higher and closer to the center
                HStack {
                    if currentMessageIndex > 0 {
                        Button(action: {
                            currentMessageIndex -= 1
                            if isVoiceEnabled {
                                speakText(for: budgetingMessages[currentMessageIndex]) // Speak the previous message if voice is enabled
                            }
                        }) {
                            Text("Back")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                    Spacer()
                    if currentMessageIndex < budgetingMessages.count - 1 {
                        Button(action: {
                            currentMessageIndex += 1
                            if isVoiceEnabled {
                                speakText(for: budgetingMessages[currentMessageIndex]) // Speak the next message if voice is enabled
                            }
                        }) {
                            Text("Next")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                }
                .padding(.bottom, 200) // Brought the buttons up higher
                .padding(.horizontal, 60) // Centered the buttons horizontally
            }
            .padding(.top, 50) // Added padding to bring the rest of the content down
        }
    }

    // Function to handle text-to-speech with different voices for each character
    func speakText(for message: (String, String)) {
        let utterance = AVSpeechUtterance(string: message.1)
        utterance.rate = 0.5 // Adjust the speed of the speech
        
        if message.0 == "Father" {
            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Daniel-compact")
        } else if message.0 == "Son" {
            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Rishi-compact")
        }

        speechSynthesizer.speak(utterance)
    }
}


struct SubTopicView: View {
    var title: String
    var content: String
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 28))
                .padding()
            Text(content)
                .font(.system(size: 18))
                .padding()
        }
        .background(Color.black)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
}

struct QuizView: View {
    @State private var selectedAnswers = [String: [Int: Int]]()

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                HStack {
                    // Left column with vertical scroll for quiz buttons
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            Text("Quizzes")
                                .font(.system(size: 45, weight: .bold))
                                .foregroundColor(.white) // Changed text color to white
                                .padding(.top, 50)
                                .multilineTextAlignment(.center)
                            
                            QuizButton(quizTitle: "Budgeting", index: 1, selectedAnswers: $selectedAnswers)
                            QuizButton(quizTitle: "Investing", index: 2, selectedAnswers: $selectedAnswers)
                            QuizButton(quizTitle: "Credit Score", index: 3, selectedAnswers: $selectedAnswers)
                            QuizButton(quizTitle: "Saving", index: 4, selectedAnswers: $selectedAnswers)
                            QuizButton(quizTitle: "Spending", index: 5, selectedAnswers: $selectedAnswers)
                        }
                        .padding()
                    }
                    .frame(width: 200)
                    .background(Color.gray.opacity(0.2)) // Darker gray background for the button column

                    // Quiz content area
                    Spacer()
                    Text("Select a quiz to begin")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white) // Changed text color to white
                        .padding()
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Custom view for each quiz button
struct QuizButton: View {
    var quizTitle: String
    var index: Int
    @Binding var selectedAnswers: [String: [Int: Int]]

    var body: some View {
        NavigationLink(destination: QuizDetailView(topic: quizTitle, questions: questionsForQuiz(quizTitle), selectedAnswers: $selectedAnswers)) {
            Text(quizTitle)
                .font(.system(size: 26, weight: .bold))
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(colorForIndex(index))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.bottom, 15)
    }

    // Function to return questions based on quiz title
    func questionsForQuiz(_ title: String) -> [Question] {
        switch title {
        case "Budgeting":
            return budgetingQuestions.shuffled() // Randomize order
        case "Investing":
            return investingQuestions.shuffled() // Randomize order
        case "Credit Score":
            return creditScoreQuestions.shuffled() // Randomize order
        case "Saving":
            return savingQuestions.shuffled() // Randomize order
        case "Spending":
            return spendingQuestions.shuffled() // Randomize order
        default:
            return []
        }
    }

    // Function to return the color based on the index
    private func colorForIndex(_ index: Int) -> Color {
        switch index {
        case 1:
            return Color.purple.opacity(0.8)
        case 2:
            return Color(red: 0.7, green: 0.2, blue: 0)
        case 3:
            return Color(red: 0.0, green: 0.6, blue: 0.6)
        case 4:
            return Color(red: 0.3, green: 0.8, blue: 0.5)
        case 5:
            return Color(red: 0.7, green: 0.0, blue: 0.1)
        default:
            return Color.clear
        }
    }
}
struct QuizDetailView: View {
    var topic: String
    var questions: [Question]
    @Binding var selectedAnswers: [String: [Int: Int]]
    @State private var currentQuestionIndex = 0
    @State private var correctAnswersCount = 0
    @State private var showFeedbackMessage: String? = nil
    @State private var selectedChoice: Int?
    @State private var flashColor: Color?
    @State private var showNextButton = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            // Background circles
                      Circle()
                          .fill(Color.gray.opacity(0.2))
                          .frame(width: 400, height: 400)
                          .position(x: 100, y: 650)
                      Circle()
                          .fill(Color.gray.opacity(0.2))
                          .frame(width: 150, height: 150)
                          .position(x: 400, y: 25)
                      Circle()
                          .fill(Color.gray.opacity(0.2))
                          .frame(width: 200, height: 200)
                          .position(x: 500, y: 100)
                      
            ScrollView {
                VStack {
                    // Question tracker
                    Text("Question \(currentQuestionIndex + 1) out of \(questions.count)")
                        .font(.headline)
                        .padding(10)
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                        .foregroundColor(.black)

                    if currentQuestionIndex < questions.count {
                        let question = questions[currentQuestionIndex]
                        Text(question.text)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(.bottom, 20)

                        VStack(spacing: 16) {
                            ForEach(0..<question.choices.count, id: \.self) { choiceIndex in
                                Button(action: {
                                    handleAnswerSelection(choiceIndex: choiceIndex)
                                }) {
                                    Text(question.choices[choiceIndex])
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(selectedChoice == choiceIndex ? (flashColor ?? Color.white) : Color.white)
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                        .padding(.vertical, 4)
                                }
                                .animation(.easeInOut(duration: 0.5), value: flashColor)
                            }
                        }
                        .padding(.bottom, 40)

                        // Progress bar
                        ProgressView(value: Double(currentQuestionIndex + 1), total: Double(questions.count))
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            .padding(.bottom, 20)

                        if let feedback = showFeedbackMessage {
                            Text(feedback)
                                .foregroundColor(.red)
                                .padding()
                        }

                        // Show next button only if the answer was wrong
                        if showNextButton {
                            Button(action: moveToNextQuestion) {
                                Text("Next")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.top, 20)
                        }

                    } else {
                        // Show summary when all questions are answered
                        ResultsView(totalQuestions: questions.count, correctAnswers: correctAnswersCount, questions: questions) {
                            resetQuiz()
                        }
                    }
                }
                .padding()
            }
        }
    }

    private func handleAnswerSelection(choiceIndex: Int) {
        let question = questions[currentQuestionIndex]
        selectedChoice = choiceIndex

        if choiceIndex == question.correctAnswer {
            correctAnswersCount += 1
            flashColor = Color.green
            showFeedbackMessage = "Correct!"
            showNextButton = false // Hide next button on correct answer
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                moveToNextQuestion()
            }
        } else {
            flashColor = Color.red
            showFeedbackMessage = "Wrong! Correct answer: \(question.choices[question.correctAnswer])\n\nExplanation: \(question.explanation)"
            showNextButton = true // Show next button on incorrect answer
        }
    }

    private func moveToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            showFeedbackMessage = nil
            selectedChoice = nil
            flashColor = nil
            showNextButton = false // Reset the next button state
        }
    }

    private func resetQuiz() {
        correctAnswersCount = 0
        currentQuestionIndex = 0
        showFeedbackMessage = nil
        selectedChoice = nil
        flashColor = nil
        showNextButton = false
    }
}


struct ResultsView: View {
    var totalQuestions: Int
    var correctAnswers: Int
    var questions: [Question]
    var onRetake: () -> Void

    var body: some View {
        VStack {
            Text("Quiz Completed!")
                .font(.largeTitle)
                .padding()
            Text("You got \(correctAnswers) out of \(totalQuestions) right.")
                .font(.title)
                .padding()
            Text("Your score: \(Int((Double(correctAnswers) / Double(totalQuestions)) * 100))%")
                .font(.headline)
                .padding()

            // Display explanations for wrong answers
            ForEach(0..<questions.count, id: \.self) { index in
                if questions[index].userAnswer != nil && questions[index].userAnswer != questions[index].correctAnswer {
                    Text("Question \(index + 1): \(questions[index].text)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                    Text("Correct answer: \(questions[index].choices[questions[index].correctAnswer])")
                        .foregroundColor(.green)
                    Text("Explanation: \(questions[index].explanation)")
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                }
            }

            HStack {
                Button(action: onRetake) {
                    Text("Retake Quiz")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}

// Modified Question model to include the correct answer, explanation, and user answer
struct Question {
    var text: String
    var choices: [String]
    var correctAnswer: Int
    var explanation: String
    var userAnswer: Int? // Store user's selected answer

    mutating func setUserAnswer(_ answer: Int) {
        self.userAnswer = answer
    }
}

struct Subsection {
    let title: String
    let content: String
    let quiz: [Question]? // Optional quiz for each subsection
}
// Course struct to define courses and their subsections
struct Course {
    let title: String
    let subsections: [Subsection]
}
let budgetingQuestions = [
    Question(text: "What is the first step in creating a budget?", choices: [
        "Tracking your spending.",
        "Setting financial goals.",
        "Choosing a budgeting method.",
        "Calculating your net worth."
    ], correctAnswer: 1, explanation: "The first step in creating a budget is to set financial goals, as this provides direction for how to allocate funds."),
    
    Question(text: "What is a common budgeting method?", choices: [
        "The 50/30/20 rule.",
        "Spending everything you earn.",
        "Ignoring your expenses.",
        "Budgeting by intuition."
    ], correctAnswer: 0, explanation: "The 50/30/20 rule suggests allocating 50% of income to needs, 30% to wants, and 20% to savings."),
    
    Question(text: "Why is it important to track your spending?", choices: [
        "To see where you can overspend.",
        "To understand your spending habits.",
        "To find ways to spend more.",
        "To avoid making a budget."
    ], correctAnswer: 1, explanation: "Tracking your spending helps you understand where your money goes, allowing for better budgeting decisions."),
    
    Question(text: "What is the purpose of an emergency fund?", choices: [
        "To cover unexpected expenses.",
        "To buy luxury items.",
        "To pay off debts.",
        "To invest in stocks."
    ], correctAnswer: 0, explanation: "An emergency fund is designed to cover unforeseen expenses, providing financial security."),
    
    Question(text: "How often should you review your budget?", choices: [
        "Once a year.",
        "Every month.",
        "Never.",
        "Only when you overspend."
    ], correctAnswer: 1, explanation: "Regular monthly reviews of your budget help you stay on track and adjust as necessary."),
    
    Question(text: "What is discretionary spending?", choices: [
        "Necessary expenses like rent.",
        "Non-essential expenses like entertainment.",
        "Fixed expenses like insurance.",
        "Savings contributions."
    ], correctAnswer: 1, explanation: "Discretionary spending refers to non-essential expenses, such as dining out or entertainment."),
    
    Question(text: "Which of the following is a benefit of budgeting?", choices: [
        "More financial stress.",
        "Increased impulse buying.",
        "Better control over finances.",
        "Less awareness of spending."
    ], correctAnswer: 2, explanation: "Budgeting helps you take control of your finances and reduce stress by clearly defining where your money goes."),
    
    Question(text: "What should you do if you exceed your budget?", choices: [
        "Ignore it.",
        "Adjust your budget or spending.",
        "Increase your spending.",
        "Stop budgeting altogether."
    ], correctAnswer: 1, explanation: "If you exceed your budget, it's important to analyze the reasons and adjust your spending or budget accordingly.")
]
let investingQuestions = [
    Question(text: "What is a key factor in determining your investment strategy?", choices: [
        "The level of risk an investor is willing to take.",
        "The amount of money needed to invest.",
        "The potential return of an investment.",
        "The duration of an investment."
    ], correctAnswer: 0, explanation: "Risk tolerance refers to the level of risk an investor is comfortable taking with their investments."),
    
    Question(text: "What does diversification in investing mean?", choices: [
        "Investing in only one asset.",
        "Spreading investments across various assets to reduce risk.",
        "Investing only in stocks.",
        "Concentrating funds in a single market."
    ], correctAnswer: 1, explanation: "Diversification involves spreading investments across different assets to mitigate risk."),
    
    Question(text: "Which of the following is considered a safer investment?", choices: [
        "Stocks",
        "Real estate",
        "Bonds",
        "Cryptocurrency"
    ], correctAnswer: 2, explanation: "Bonds are generally considered safer than stocks and cryptocurrencies, providing fixed interest over time."),
    
    Question(text: "What is a stock?", choices: [
        "A loan made to a corporation.",
        "A share in the ownership of a company.",
        "A type of bond.",
        "An investment that guarantees returns."
    ], correctAnswer: 1, explanation: "A stock represents a share in the ownership of a company and its assets."),
    
    Question(text: "What is the purpose of a mutual fund?", choices: [
        "To pool money from multiple investors to invest in a diversified portfolio.",
        "To provide loans to individuals.",
        "To save money for retirement only.",
        "To invest in a single stock."
    ], correctAnswer: 0, explanation: "A mutual fund collects money from multiple investors to invest in a diversified portfolio of stocks and bonds."),
    
    Question(text: "What is compound interest?", choices: [
        "Interest earned on the initial deposit only.",
        "Interest earned on both the principal and previously earned interest.",
        "Interest applied once a year.",
        "A fixed percentage rate of return."
    ], correctAnswer: 1, explanation: "Compound interest allows you to earn interest on both your principal and any previously earned interest."),
    
    Question(text: "What is a 401(k)?", choices: [
        "A type of investment in real estate.",
        "A retirement savings plan that allows workers to save a portion of their paycheck.",
        "An insurance policy.",
        "A mutual fund."
    ], correctAnswer: 1, explanation: "A 401(k) is a retirement savings plan allowing employees to save and invest part of their paycheck for retirement."),
    
    Question(text: "Which is a characteristic of a high-yield savings account?", choices: [
        "Higher interest rates compared to traditional savings accounts.",
        "No minimum balance requirements.",
        "Limited access to funds.",
        "Only available through physical banks."
    ], correctAnswer: 0, explanation: "High-yield savings accounts offer better interest rates than traditional accounts, encouraging savings growth.")
]
let creditScoreQuestions = [
    Question(text: "What is a credit score?", choices: [
        "A number that represents your income level.",
        "A number that reflects your creditworthiness.",
        "The amount of debt you owe.",
        "A score that shows how much credit you can buy."
    ], correctAnswer: 1, explanation: "A credit score is a numerical expression of your creditworthiness, used by lenders to assess risk."),
    
    Question(text: "Which factor does NOT influence your credit score?", choices: [
        "Payment history",
        "Credit utilization",
        "Income level",
        "Length of credit history"
    ], correctAnswer: 2, explanation: "Income level does not directly influence your credit score; it focuses on how you manage debt."),
    
    Question(text: "What is the credit utilization ratio?", choices: [
        "The amount of available credit you use.",
        "The number of credit accounts you have.",
        "The total debt you owe.",
        "The average age of your credit accounts."
    ], correctAnswer: 0, explanation: "Credit utilization ratio measures how much of your available credit you're using, impacting your credit score."),
    
    Question(text: "How can you improve your credit score?", choices: [
        "By opening multiple new credit accounts at once.",
        "By making payments on time and reducing debt.",
        "By ignoring your credit report.",
        "By taking out a large loan."
    ], correctAnswer: 1, explanation: "Improving your credit score involves making timely payments and reducing overall debt."),
    
    Question(text: "What is considered a good credit score range?", choices: [
        "300-579",
        "580-669",
        "670-739",
        "740 and above"
    ], correctAnswer: 3, explanation: "A credit score of 740 or above is typically considered excellent, indicating strong credit management."),
    
    Question(text: "What happens if you have a low credit score?", choices: [
        "You will always be denied credit.",
        "You may face higher interest rates and difficulty obtaining loans.",
        "You won't be able to rent an apartment.",
        "You will not be able to get a credit card."
    ], correctAnswer: 1, explanation: "A low credit score can lead to higher interest rates and make it difficult to obtain loans, as lenders view you as a higher risk."),
    
    Question(text: "How often should you check your credit report?", choices: [
        "Once a year.",
        "Once every few years.",
        "Only when applying for a loan.",
        "Every month."
    ], correctAnswer: 0, explanation: "You should check your credit report at least once a year to ensure accuracy and identify any potential issues. A credit report is a statement that has information about your credit activity and current credit situation such as loan paying history and the status of your credit accounts."),
    
    Question(text: "Which of the following actions can negatively impact your credit score?", choices: [
        "Paying your bills on time.",
        "Using credit cards responsibly.",
        "Applying for multiple loans in a short time.",
        "Keeping old credit accounts open."
    ], correctAnswer: 2, explanation: "Applying for multiple loans in a short period can indicate to lenders that you may be in financial trouble, potentially lowering your score.")
]
let savingQuestions = [
    Question(text: "What is the purpose of an emergency fund?", choices: [
        "To pay for everyday expenses.",
        "To save for retirement.",
        "To cover unexpected expenses.",
        "To invest in stocks."
    ], correctAnswer: 2, explanation: "An emergency fund is specifically set aside to cover unforeseen expenses, such as medical emergencies or car repairs."),
    
    Question(text: "Which of the following is an example of a good savings goal", choices: [
        "Saving enough for a vacation next year.",
        "Spending all income each month.",
        "Not saving at all.",
        "Using savings to fund non-essential purchases."
    ], correctAnswer: 0, explanation: "Setting a savings goal, like saving for a vacation, encourages discipline and helps you plan for future expenses."),
    
    Question(text: "What does 'paying yourself first' mean?", choices: [
        "Paying all your bills before anything else.",
        "Saving a portion of your income before spending on anything else.",
        "Only saving after all expenses are covered.",
        "Spending your savings as soon as you receive them."
    ], correctAnswer: 1, explanation: "'Paying yourself first' means setting aside savings before any other expenses, ensuring that you prioritize your financial health."),
    
    Question(text: "Which is NOT a good savings strategy?", choices: [
        "Setting specific savings goals.",
        "Automating your savings.",
        "Spending all your disposable income.",
        "Tracking your savings progress."
    ], correctAnswer: 2, explanation: "Spending all disposable income contradicts saving; effective strategies include setting goals and tracking progress."),
    
    Question(text: "What is a high-yield savings account?", choices: [
        "An account with high fees.",
        "An account that offers higher interest rates than regular savings accounts.",
        "An account with a fixed interest rate.",
        "An account with no withdrawal limits."
    ], correctAnswer: 1, explanation: "High-yield savings accounts offer better interest rates than traditional accounts, helping your savings grow faster."),
    
    Question(text: "Why is it important to review your savings plan periodically?", choices: [
        "To make unnecessary changes.",
        "To ensure it still aligns with your financial goals.",
        "To increase your spending.",
        "To avoid saving."
    ], correctAnswer: 1, explanation: "Regularly reviewing your savings plan ensures it remains aligned with your evolving financial goals and priorities."),
    
    Question(text: "What is a common mistake when saving money?", choices: [
        "Setting realistic goals.",
        "Not having an emergency fund.",
        "Automating savings.",
        "Tracking expenses."
    ], correctAnswer: 1, explanation: "A common mistake is failing to have an emergency fund, which can lead to financial stress during unexpected events."),
    
    Question(text: "How can interest help your savings grow?", choices: [
        "It adds to your total savings over time.",
        "It decreases the amount you save.",
        "It has no effect on savings.",
        "It only applies to checking accounts."
    ], correctAnswer: 0, explanation: "Interest earns you additional money on your savings, allowing your funds to grow over time through compounding.")
]
let spendingQuestions = [
    Question(text: "What is the difference between needs and wants?", choices: [
        "Needs are essential; wants are non-essential.",
        "Needs are what you want; wants are what you need.",
        "Both are the same.",
        "Wants are more important than needs."
    ], correctAnswer: 0, explanation: "Needs are essential for survival, like food and shelter, while wants are things that enhance life but are not necessary."),
    
    Question(text: "What is a spending limit?", choices: [
        "The maximum amount you can earn.",
        "A set amount you allocate for different categories of expenses.",
        "The amount you can spend without a budget.",
        "A limit on how much you can save."
    ], correctAnswer: 1, explanation: "A spending limit is a predetermined amount allocated for various expense categories, helping you manage your finances."),
    
    Question(text: "How can impulse purchases affect your budget?", choices: [
        "They help you stay within budget.",
        "They can derail your budget and lead to overspending.",
        "They have no effect on your budget.",
        "They are necessary for financial planning."
    ], correctAnswer: 1, explanation: "Impulse purchases can lead to unplanned expenses, potentially disrupting your budget and causing overspending."),
    
    Question(text: "What is one strategy to avoid impulse buying?", choices: [
        "Always buy on credit.",
        "Wait 24 hours before making non-essential purchases.",
        "Shop online only.",
        "Ignore your budget."
    ], correctAnswer: 1, explanation: "Waiting 24 hours before making a non-essential purchase allows you to consider whether it is truly needed, reducing impulse buys."),
    
    Question(text: "What does it mean to track your spending?", choices: [
        "Recording every dollar spent to understand where money goes.",
        "Only tracking large expenses.",
        "Forgetting about small purchases.",
        "Not keeping any records."
    ], correctAnswer: 0, explanation: "Tracking spending involves recording all expenses to better understand spending habits and make informed financial decisions."),
    
    Question(text: "What is a budget?", choices: [
        "A plan for how to spend and save money.",
        "A way to restrict your spending.",
        "Only a tool for saving.",
        "A plan to spend without limits."
    ], correctAnswer: 0, explanation: "A budget is a detailed plan that outlines how to allocate income for spending and savings."),
    
    Question(text: "Which of these is an example of discretionary spending?", choices: [
        "Rent",
        "Utilities",
        "Groceries",
        "Dining out"
    ], correctAnswer: 3, explanation: "Dining out is considered discretionary spending as it is non-essential, unlike rent and utilities."),
    
    Question(text: "How can setting spending limits help you?", choices: [
        "It allows for unlimited spending.",
        "It helps manage finances and prevent overspending.",
        "It has no impact on your financial health.",
        "It encourages higher spending."
    ], correctAnswer: 1, explanation: "Setting spending limits helps you manage your finances more effectively and avoid overspending.")
]



// Expense Tracking and Analytics
struct ExpensesView: View {
    @State private var expenses: [Expense] = []
    @State private var newExpenseAmount: String = ""
    @State private var selectedCategory: String = ""
    let categories = ["Food", "Transportation", "Entertainment", "Housing", "Utilities"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0))
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    TextField("Enter expense amount", text: $newExpenseAmount)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                    HStack {
                        Button(action: addExpense) {
                            Text("Add Expense")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                        
                        Button(action: clearExpenses) {
                            Text("Clear Expenses")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                    .padding()
                    
                    ExpenseChartView(data: calculateExpenseData())
                    
                    List(expenses) { expense in
                        Text("\(expense.category): $\(expense.amount, specifier: "%.2f")")
                    }
                }
                .navigationTitle("Expenses")
            }
        }
    }
    
    func addExpense() {
        if let amount = Double(newExpenseAmount), !selectedCategory.isEmpty {
            let expense = Expense(amount: amount, category: selectedCategory)
            expenses.append(expense)
            newExpenseAmount = ""
            selectedCategory = ""
        }
    }
    
    func clearExpenses() {
        expenses.removeAll()  // Clear the list of expenses
    }
    
    func calculateExpenseData() -> [(String, Double)] {
        let total = expenses.reduce(0) { $0 + $1.amount }
        let categoryTotals = Dictionary(grouping: expenses, by: { $0.category })
            .mapValues { $0.reduce(0) { $0 + $1.amount } }
        
        return categoryTotals.map { (key: $0.key, percentage: $0.value / total) }
    }
}
// Expense Model
struct Expense: Identifiable {
    let id = UUID()
    var amount: Double
    var category: String
}
// Expense Chart View
struct ExpenseChartView: View {
    var data: [(String, Double)]
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0))
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Expense Breakdown")
                    .font(.headline)
                    .padding()
                
                ForEach(data, id: \.0) { category, percentage in
                    HStack {
                        Text(category)
                        Spacer()
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: CGFloat(percentage) * 300, height: 20) // Adjust the multiplier for visual representation
                            .cornerRadius(5)
                    }
                }
            }
            .padding()
        }
    }
}
#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

