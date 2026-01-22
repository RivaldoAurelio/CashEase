import 'package:flutter/material.dart';
// 🔹 Import Localization
import '../l10n/app_localizations.dart';

class Inbox extends StatefulWidget {
  const Inbox({super.key});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  String _selectedFilter = 'All Messages';
  
  // NOTE: In a real app, these strings should also be localized dynamically
  // but for filter logic, we often keep internal keys. 
  // Here we will just use l10n for UI display.
  final List<String> _filterOptions = [
    'All Messages',
    'Less than 10 days',
    'Less than 20 days',
    'Less than 30 days',
    'More than 30 days',
  ];

  final List<Message> _allMessages = [
    Message(
      sender: 'CashEase Team',
      subject: 'Welcome to CashEase!',
      content: 'Thank you for choosing CashEase for your financial needs.',
      time: 'Today',
      date: DateTime.now(),
      isRead: false,
    ),
    // ... (rest of dummy data kept same for brevity, ensure you have dummy data)
  ];

  late List<Message> _messages;

  @override
  void initState() {
    super.initState();
    _messages = _allMessages;
  }

  void _filterMessages(String filter) {
    setState(() {
      _selectedFilter = filter;
      if (filter == 'All Messages') {
        _messages = _allMessages;
      } else if (filter == 'Less than 10 days') {
        _messages = _allMessages.where((msg) => DateTime.now().difference(msg.date).inDays < 10).toList();
      } else if (filter == 'Less than 20 days') {
        _messages = _allMessages.where((msg) => DateTime.now().difference(msg.date).inDays < 20).toList();
      } else if (filter == 'Less than 30 days') {
        _messages = _allMessages.where((msg) => DateTime.now().difference(msg.date).inDays < 30).toList();
      } else if (filter == 'More than 30 days') {
        _messages = _allMessages.where((msg) => DateTime.now().difference(msg.date).inDays >= 30).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(l10n.inbox, style: const TextStyle(color: Colors.white)), // "Kotak Masuk"
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[100],
            child: Row(
              children: [
                Text(
                  '${l10n.filterBy}: ', // "Filter berdasarkan:"
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                        items: _filterOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value), // Filter options text (can be localized too)
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) _filterMessages(newValue);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState(l10n)
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageTile(_messages[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mail_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            l10n.noMessages, // "Tidak ada pesan"
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(Message message) {
    return Container(
      decoration: BoxDecoration(
        color: message.isRead ? Colors.white : Colors.blue[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Text(message.sender[0], style: const TextStyle(color: Colors.white)),
        ),
        title: Text(
          message.subject,
          style: TextStyle(fontWeight: message.isRead ? FontWeight.normal : FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(message.sender, style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(message.content, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message.time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 4),
            if (!message.isRead)
              Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle)),
          ],
        ),
        onTap: () async {
          setState(() {
            message.isRead = true;
          });
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MessageDetailPage(message: message)),
          );
        },
      ),
    );
  }
}

class Message {
  final String sender;
  final String subject;
  final String content;
  final String time;
  final DateTime date;
  bool isRead;

  Message({
    required this.sender,
    required this.subject,
    required this.content,
    required this.time,
    required this.date,
    required this.isRead,
  });
}

class MessageDetailPage extends StatelessWidget {
  final Message message;
  const MessageDetailPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(l10n.messageDetails, style: const TextStyle(color: Colors.white)), // "Detail Pesan"
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.deleteMessage), // "Hapus Pesan"
                  content: Text(l10n.deleteConfirmation),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.subject, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(backgroundColor: Colors.deepPurple, child: Text(message.sender[0], style: const TextStyle(color: Colors.white))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(message.sender, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('To: me', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    ],
                  ),
                ),
                Text(message.time, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 24),
            Text(message.content, style: const TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }
}