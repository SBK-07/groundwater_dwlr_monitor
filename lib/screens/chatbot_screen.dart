import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/mock_user.dart';
import '../screens/prediction_screen.dart';
import '../screens/analysis_report_screen.dart';
import '../screens/recharge_analysis_screen.dart';
import '../screens/water_level_trends_screen.dart';
import '../screens/dataset_page.dart';

class ChatbotScreen extends StatefulWidget {
  final MockUser user;

  const ChatbotScreen({super.key, required this.user});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  
  List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      "Hello! I'm your Groundwater ML Assistant 🤖\n\n"
      "I can help you navigate through our ML-powered groundwater monitoring features. "
      "Ask me about predictions, analysis reports, or any other feature!"
    );
    _showQuickOptions();
  }

  void _addBotMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _addUserMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showQuickOptions() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _addBotMessage(
        "Here are some things you can ask me:\n\n"
        "🔮 \"Show me water level predictions\"\n"
        "📊 \"Generate analysis report\"\n"
        "💧 \"Analyze recharge patterns\"\n"
        "📈 \"View water level trends\"\n"
        "📋 \"See historical data\"\n"
        "❓ \"How does the ML model work?\"\n"
        "🎯 \"What years can I analyze?\""
      );
    });
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    
    _textController.clear();
    _addUserMessage(text);
    
    setState(() {
      _isTyping = true;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      _processUserInput(text.toLowerCase());
    });
  }

  void _processUserInput(String input) {
    setState(() {
      _isTyping = false;
    });

    if (input.contains('predict') || input.contains('forecast') || input.contains('future')) {
      _handlePredictionQuery();
    } else if (input.contains('analysis') || input.contains('report') || input.contains('analyze')) {
      _handleAnalysisQuery();
    } else if (input.contains('recharge') || input.contains('rainfall')) {
      _handleRechargeQuery();
    } else if (input.contains('trend') || input.contains('pattern') || input.contains('historical')) {
      _handleTrendsQuery();
    } else if (input.contains('data') || input.contains('dataset')) {
      _handleDataQuery();
    } else if (input.contains('model') || input.contains('ml') || input.contains('machine learning')) {
      _handleMLQuery();
    } else if (input.contains('year') || input.contains('time') || input.contains('period')) {
      _handleYearQuery();
    } else if (input.contains('help') || input.contains('feature') || input.contains('navigate')) {
      _handleHelpQuery();
    } else {
      _handleGeneralQuery();
    }
  }

  void _handlePredictionQuery() {
    _addBotMessage(
      "🔮 Great! I can help you with water level predictions.\n\n"
      "Our ML model (ELM + XGBoost ensemble) can predict:\n"
      "• Future water levels for next 12 months\n"
      "• Different rainfall scenarios\n"
      "• Confidence intervals for predictions\n\n"
      "Would you like me to take you to the Prediction Screen?"
    );
    
    _showActionButtons([
      ActionButton(
        text: "📈 View Predictions",
        action: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PredictionScreen(user: widget.user),
          ),
        ),
      ),
      ActionButton(
        text: "❓ Learn More",
        action: () => _addBotMessage(
          "Our prediction model was trained on 2012-2019 data and can predict water levels for 2020 onwards. "
          "The model considers temperature, rainfall, pH, and dissolved oxygen levels to make accurate predictions."
        ),
      ),
    ]);
  }

  void _handleAnalysisQuery() {
    _addBotMessage(
      "📊 Perfect! Our ML Analysis Report provides:\n\n"
      "• Sustainability scoring (0-100%)\n"
      "• Risk assessment (Low/Moderate/High)\n"
      "• ML-generated recommendations\n"
      "• Seasonal pattern analysis\n"
      "• Export functionality\n\n"
      "This uses our trained model to analyze any year from 2020-2025!"
    );
    
    _showActionButtons([
      ActionButton(
        text: "📋 Generate Report",
        action: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnalysisReportScreen(user: widget.user),
          ),
        ),
      ),
    ]);
  }

  void _handleRechargeQuery() {
    _addBotMessage(
      "💧 Excellent choice! Recharge Analysis shows:\n\n"
      "• Monthly recharge patterns\n"
      "• Efficiency metrics (infiltration, runoff, evaporation)\n"
      "• Source breakdown (rainfall, irrigation, etc.)\n"
      "• Trends and insights\n\n"
      "Perfect for understanding groundwater replenishment!"
    );
    
    _showActionButtons([
      ActionButton(
        text: "💧 View Recharge Analysis",
        action: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RechargeAnalysisScreen(user: widget.user),
          ),
        ),
      ),
    ]);
  }

  void _handleTrendsQuery() {
    _addBotMessage(
      "📈 Water Level Trends Analysis provides:\n\n"
      "• Trend direction (Rising/Declining/Stable)\n"
      "• Seasonal patterns visualization\n"
      "• Risk assessment\n"
      "• Monthly comparison charts\n"
      "• ML-based future predictions\n\n"
      "Great for understanding long-term patterns!"
    );
    
    _showActionButtons([
      ActionButton(
        text: "📊 View Trends",
        action: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WaterLevelTrendsScreen(user: widget.user),
          ),
        ),
      ),
    ]);
  }

  void _handleDataQuery() {
    _addBotMessage(
      "📋 Our dataset information:\n\n"
      "• Training Data: 2012-2019 (Historical)\n"
      "• Prediction Range: 2020-2025+ (ML Generated)\n"
      "• Parameters: Temperature, Rainfall, pH, DO\n"
      "• Model: ELM + XGBoost Ensemble\n\n"
      "You can view the complete dataset and understand data patterns."
    );
    
    _showActionButtons([
      ActionButton(
        text: "📊 View Dataset",
        action: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DatasetPage(isAuthority: true),
          ),
        ),
      ),
    ]);
  }

  void _handleMLQuery() {
    _addBotMessage(
      "🧠 Our ML Model Details:\n\n"
      "🏗️ Architecture: ELM + XGBoost Ensemble\n"
      "📊 Accuracy: 94.2% (R² ≈ 0.99 on training data)\n"
      "🎯 Training: 2012-2019 groundwater data\n"
      "🔮 Capability: Predicts 2020+ with confidence intervals\n\n"
      "Additional Models:\n"
      "• Random Forest (ensemble member)\n"
      "• Gradient Boosting (ensemble member)\n"
      "• Meta-learner for optimal weighting\n\n"
      "The model learns seasonal patterns, climate trends, and groundwater dynamics!"
    );
    
    _showActionButtons([
      ActionButton(
        text: "🔬 Technical Details",
        action: () => _addBotMessage(
          "Technical Specifications:\n\n"
          "🔹 ELM: Extreme Learning Machine for rapid training\n"
          "🔹 XGBoost: Gradient boosting for high accuracy\n"
          "🔹 Ensemble: Combines multiple models\n"
          "🔹 Features: Temperature, Rainfall, pH, DO\n"
          "🔹 Output: Water level predictions with uncertainty\n"
          "🔹 Validation: Cross-validation on historical data\n\n"
          "The model automatically handles seasonal patterns and can extrapolate to future years!"
        ),
      ),
    ]);
  }

  void _handleYearQuery() {
    _addBotMessage(
      "📅 Year Selection Guide:\n\n"
      "🟢 2012-2019: Training Data (Historical)\n"
      "• High accuracy, actual recorded values\n"
      "• Used to train the ML model\n\n"
      "🟡 2020-2025: ML Predictions\n"
      "• Generated by trained model\n"
      "• Confidence decreases with time\n"
      "• Includes uncertainty bounds\n\n"
      "You can switch years in any analysis screen to compare different periods!"
    );
    
    _showActionButtons([
      ActionButton(
        text: "📊 Go to Dashboard",
        action: () => Navigator.pop(context),
      ),
    ]);
  }

  void _handleHelpQuery() {
    _addBotMessage(
      "🎯 App Features Guide:\n\n"
      "🏠 Dashboard: Overview with year selection\n"
      "🔮 Predictions: Future water level forecasts\n"
      "📊 Analysis: Comprehensive ML reports\n"
      "💧 Recharge: Groundwater replenishment analysis\n"
      "📈 Trends: Historical patterns and future outlook\n"
      "📋 Dataset: Raw data exploration\n\n"
      "Pro Tip: Change the year in dashboard to see different time periods!"
    );
    
    _showQuickNavigation();
  }

  void _handleGeneralQuery() {
    _addBotMessage(
      "I understand you're looking for information! Let me help you find what you need.\n\n"
      "Here are the main things I can help with:"
    );
    _showQuickNavigation();
  }

  void _showQuickNavigation() {
    _showActionButtons([
      ActionButton(
        text: "🔮 Predictions",
        action: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PredictionScreen(user: widget.user),
          ),
        ),
      ),
      ActionButton(
        text: "📊 Analysis Report",
        action: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnalysisReportScreen(user: widget.user),
          ),
        ),
      ),
      ActionButton(
        text: "💧 Recharge Analysis",
        action: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RechargeAnalysisScreen(user: widget.user),
          ),
        ),
      ),
      ActionButton(
        text: "📈 Water Trends",
        action: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WaterLevelTrendsScreen(user: widget.user),
          ),
        ),
      ),
    ]);
  }

  void _showActionButtons(List<ActionButton> buttons) {
    setState(() {
      _messages.add(ChatMessage(
        text: "",
        isUser: false,
        timestamp: DateTime.now(),
        actionButtons: buttons,
      ));
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'ML Assistant',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple[700]!, Colors.purple[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _messages.clear();
              });
              _addBotMessage(
                "Hello again! How can I help you navigate our ML features?"
              );
              _showQuickOptions();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              backgroundColor: Colors.purple[600],
              radius: 16,
              child: const Icon(Icons.psychology, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          if (message.isUser) const Spacer(),
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isUser ? Colors.purple[600] : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: message.text.isNotEmpty
                      ? Text(
                          message.text,
                          style: GoogleFonts.poppins(
                            color: message.isUser ? Colors.white : Colors.black87,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                
                if (message.actionButtons != null && message.actionButtons!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: message.actionButtons!.map((button) {
                      return ElevatedButton(
                        onPressed: button.action,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[100],
                          foregroundColor: Colors.purple[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          button.text,
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          if (!message.isUser) const Spacer(),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue[600],
              radius: 16,
              child: Text(
                widget.user.name.isNotEmpty ? widget.user.name[0].toUpperCase() : 'U',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.purple[600],
            radius: 16,
            child: const Icon(Icons.psychology, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600 + (index * 200)),
      curve: Curves.easeInOut,
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.purple[300],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Ask me about ML features...',
                hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.purple[600]!),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onSubmitted: _handleSubmitted,
              textInputAction: TextInputAction.send,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () => _handleSubmitted(_textController.text),
            backgroundColor: Colors.purple[600],
            mini: true,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<ActionButton>? actionButtons;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.actionButtons,
  });
}

class ActionButton {
  final String text;
  final VoidCallback action;

  ActionButton({
    required this.text,
    required this.action,
  });
}