import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ArtistToUser extends StatefulWidget {
  const ArtistToUser({super.key});

  @override
  State<ArtistToUser> createState() => _ArtistToUserState();
}

class _ArtistToUserState extends State<ArtistToUser> {
  final TextEditingController messageController = TextEditingController();
  int? muaId;
  bool loading = true;
  Map<String, dynamic> chatData = {};
  List messages = [];
  final ScrollController _scrollController =
      ScrollController(); // ← TAMBAHKAN INI

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // PASTIKAN WIDGET SUDAH TER-RENDER SEBELUM MENGAMBIL DATA
      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      if (routeArgs == null) {
        print("⚠️ Tidak ada arguments");
        setState(() => loading = false);
        return;
      }

      try {
        final data = routeArgs as Map<String, dynamic>;
        print("🔍 ARGUMENT DARI NAVIGATOR: $data");
        muaId = data['id'];
        loadMessages();
      } catch (e) {
        print("❌ Error parsing arguments: $e");
        setState(() => loading = false);
      }
    });
  }

  Future<void> loadMessages() async {
    if (muaId == null) return;

    try {
      chatData = await getMessage(muaId!);

      setState(() {
        messages = chatData['messages'] ?? [];
        loading = false;
      });

      // Scroll ke paling bawah setelah data dimuat
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      print("❌ Error loading messages: $e");
      setState(() => loading = false);
    }
  }

  // Di Flutter, perbaiki parsing data
  Future<Map<String, dynamic>> getMessage(int muaId, {int page = 1}) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    if (token == null) {
      print("❌ TOKEN NULL");
      return {"success": false, "error": "Token tidak ditemukan"};
    }

    final url = Uri.parse("http://192.168.1.6:8000/api/chat-mua/$muaId");

    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("📡 Status Code: ${response.statusCode}");
      print("📡 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        print("✅ Success: ${data['success']}");
        print("👤 User: ${data['user'] != null}");
        print("🎨 MUA: ${data['mua'] != null}");
        print("💬 Messages count: ${(data['messages'] ?? []).length}");

        // Debug first message
        if (data['messages'] != null && data['messages'].isNotEmpty) {
          print("📝 First message: ${data['messages'][0]}");
          print(
            "📝 First message sender_id: ${data['messages'][0]['sender_id']}",
          );
          print(
            "📝 First message sender_type: ${data['messages'][0]['sender_type']}",
          );
        }

        return {
          "success": data["success"] ?? false,
          "user": data["user"] ?? {},
          "mua": data["mua"] ?? {},
          "messages": data["messages"] ?? [],
          "meta": data["meta"] ?? {},
        };
      } else if (response.statusCode == 401) {
        print("🚨 Unauthorized - Token mungkin expired");
        return {
          "success": false,
          "error": "Unauthorized",
          "statusCode": response.statusCode,
        };
      } else {
        print("❌ API Error: ${response.statusCode}");
        return {
          "success": false,
          "error": "API Error ${response.statusCode}",
          "statusCode": response.statusCode,
        };
      }
    } catch (e) {
      print("❌ Network Error: $e");
      return {"success": false, "error": "Network error: $e"};
    }
  }

  Future<void> sendMessages(int muaId, String message) async {
    if (message.trim().isEmpty) return;

    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    if (token == null) {
      print("Token tidak ditemukan");
      return;
    }

    final url = Uri.parse("http://192.168.1.6:8000/api/chat-mua/$muaId");

    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"message": message}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        setState(() {
          messages.add(data["data"]);
        });

        // Scroll ke bawah setelah mengirim pesan
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      } else {
        final error = jsonDecode(response.body);
        print("Gagal: ${error['message']}");
      }
    } catch (e) {
      print("❌ Error sending message: $e");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Warna tema yang konsisten
    final primaryColor = Color.fromRGBO(228, 207, 206, 1);
    final accentColor = Color.fromRGBO(180, 160, 160, 1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(
                      'assets/images/user_sign_in.png',
                    ),
                    onBackgroundImageError: (exception, stackTrace) {
                      debugPrint("Image error: $exception");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 1,
        shadowColor: Colors.black12,
      ),

      body: SafeArea(
        child: Column(
          children: [
            // HEADER INFO - lebih ringkas dan informatif
            if (!loading && chatData['mua'].isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: NetworkImage(
                          chatData['mua']['profile_photo']?.toString() ?? '',
                        ),
                        onBackgroundImageError: (exception, stackTrace) {
                          // Handle error
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chatData['mua']['name'] ?? '-',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            chatData['mua']['category'] ?? '-',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Status indicator (opsional)
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ],
                ),
              ),

            // MESSAGES AREA dengan background yang lebih menarik
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  image: DecorationImage(
                    image: AssetImage('assets/images/chat_bg.png'),
                    fit: BoxFit.cover,
                    opacity: 0.05,
                  ),
                ),
                child: loading
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: primaryColor,
                              strokeWidth: 2,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Memuat percakapan...",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Mulai percakapan",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Kirim pesan pertama Anda",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
                        reverse: false,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isUser = msg['sender_type'] == 'user';
                          final messageText = msg['message']?.toString() ?? '';

                          return Container(
                            margin: EdgeInsets.only(
                              bottom: 8,
                              top: index == 0 ? 4 : 0,
                            ),
                            child: Row(
                              mainAxisAlignment: isUser
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!isUser) ...[
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage: NetworkImage(
                                      chatData['mua']['profile_photo'] ?? '',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                        0.75,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: isUser
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isUser
                                              ? primaryColor
                                              : Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(18),
                                            topRight: const Radius.circular(18),
                                            bottomLeft: isUser
                                                ? const Radius.circular(18)
                                                : const Radius.circular(4),
                                            bottomRight: !isUser
                                                ? const Radius.circular(18)
                                                : const Radius.circular(4),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          messageText,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: isUser
                                                ? Colors.black87
                                                : Colors.grey[800],
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        msg['created_at'] != null
                                            ? DateTime.parse(msg['created_at'])
                                                  .toLocal()
                                                  .toString()
                                                  .substring(11, 16)
                                            : '',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isUser) ...[
                                  const SizedBox(width: 8),
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: primaryColor.withOpacity(
                                      0.1,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: 16,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),

      // INPUT AREA dengan desain yang lebih modern
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Tombol tambahan (opsional)
                IconButton(
                  onPressed: () {
                    // Aksi untuk attach file/image
                  },
                  icon: Icon(
                    Icons.attach_file,
                    color: Colors.grey[600],
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),

                // Input field dengan desain yang lebih baik
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey[200]!, width: 1),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: messageController,
                            decoration: InputDecoration(
                              hintText: "Tulis pesan...",
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            style: const TextStyle(fontSize: 15),
                            minLines: 1,
                            maxLines: 4,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        if (messageController.text.isNotEmpty)
                          IconButton(
                            onPressed: () => messageController.clear(),
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey[500],
                              size: 18,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                          ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Tombol kirim dengan feedback visual yang lebih baik
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: messageController.text.trim().isNotEmpty
                        ? primaryColor
                        : Colors.grey[300],
                    boxShadow: [
                      if (messageController.text.trim().isNotEmpty)
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (muaId != null &&
                          messageController.text.trim().isNotEmpty) {
                        sendMessages(muaId!, messageController.text.trim());
                        messageController.clear();
                        FocusScope.of(context).unfocus();
                      }
                    },
                    icon: Icon(
                      Icons.send_rounded,
                      color: messageController.text.trim().isNotEmpty
                          ? Colors.white
                          : Colors.grey[500],
                      size: 22,
                    ),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
