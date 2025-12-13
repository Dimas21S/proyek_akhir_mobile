import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ArtistChat extends StatefulWidget {
  const ArtistChat({super.key});

  @override
  State<ArtistChat> createState() => _ArtistChatState();
}

class _ArtistChatState extends State<ArtistChat> {
  int messageCount = 0;
  List<dynamic> latestMessages = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  Future<Map<String, dynamic>> getReceivedMessages() async {
    try {
      final url = Uri.parse("http://192.168.1.6:8000/api/chat");
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      print('Chat API Status: ${response.statusCode}');
      print('Chat API Response: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return {
          "messages": data['data']['latest_messages'] ?? [],
          "counts": data['data']['message_counts'] ?? 0,
        };
      } else {
        return {"messages": [], "counts": 0, "error": "Failed to load"};
      }
    } catch (e) {
      print('Error fetching messages: $e');
      return {"messages": [], "counts": 0, "error": e.toString()};
    }
  }

  Future<void> loadMessages() async {
    setState(() {
      isLoading = true;
    });

    var result = await getReceivedMessages();

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        latestMessages = result['messages'];
        messageCount = result['counts'];
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Widget _buildMessageCard(dynamic msg) {
    final senderName = msg['sender_name']?.toString() ?? 'Pengirim';
    final message = msg['message']?.toString() ?? '';
    final time = msg['created_at'] != null
        ? _formatTime(msg['created_at'])
        : '';
    final unread = msg['is_read'] == false;
    final initial = senderName.isNotEmpty ? senderName[0] : '?';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Color.fromRGBO(228, 207, 206, 1),
              child: Text(
                initial,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (unread)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                senderName,
                style: TextStyle(
                  fontWeight: unread ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (time.isNotEmpty)
              Text(
                time,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: unread ? Colors.black87 : Colors.grey[600],
                fontWeight: unread ? FontWeight.w500 : FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/artist-to-user',
            arguments: {
              "userId": msg['sender_id'],
              "sender_type": msg['sender_type'],
            },
          );
        },
      ),
    );
  }

  String _formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 7) {
        return '${dateTime.day}/${dateTime.month}';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}h';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}j';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m';
      } else {
        return 'Baru saja';
      }
    } catch (e) {
      return '';
    }
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[500], size: 20),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari pesan...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[500]),
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              style: TextStyle(fontSize: 14),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, size: 18, color: Colors.grey[500]),
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'Belum ada pesan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Pesan dari klien akan muncul di sini',
            style: TextStyle(color: Colors.grey[500], fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color.fromRGBO(228, 207, 206, 1)),
          SizedBox(height: 16),
          Text(
            'Memuat pesan...',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pesan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(228, 207, 206, 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.message,
                      size: 16,
                      color: Color.fromRGBO(228, 207, 206, 1),
                    ),
                    SizedBox(width: 6),
                    Text(
                      '$messageCount pesan',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color.fromRGBO(228, 207, 206, 1),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logofullnyah.png', height: 40),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/beranda-mua');
            },
            child: const Text('Profil', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/chat-mua');
            },
            child: const Text('Chat', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),

              // Header
              _buildHeader(),

              // Search Bar
              _buildSearchBar(),

              SizedBox(height: 20),

              // Messages List
              Expanded(
                child: isLoading
                    ? _buildLoadingState()
                    : latestMessages.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: loadMessages,
                        color: Color.fromRGBO(228, 207, 206, 1),
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: latestMessages.length,
                          itemBuilder: (context, index) {
                            final msg = latestMessages[index];
                            return _buildMessageCard(msg);
                          },
                        ),
                      ),
              ),

              SizedBox(height: 8),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new chat functionality
        },
        backgroundColor: Color.fromRGBO(228, 207, 206, 1),
        foregroundColor: Colors.black87,
        shape: CircleBorder(),
        child: Icon(Icons.add_comment, size: 24),
      ),
    );
  }
}
