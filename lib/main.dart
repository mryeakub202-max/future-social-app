import 'package:flutter/material.dart';

void main() => runApp(const FutureApp());

const navy = Color(0xFF0B1024);
const panel = Color(0xFF151D39);
const violet = Color(0xFF8B5CF6);
const cyan = Color(0xFF42D9FF);

class FutureApp extends StatefulWidget {
  const FutureApp({super.key});
  @override
  State<FutureApp> createState() => _FutureAppState();
}

class _FutureAppState extends State<FutureApp> {
  bool bangla = true;
  bool signedIn = false;
  String username = 'Yeakub';
  int tab = 0;
  final List<Map<String, String>> posts = [
    {'name': 'Future Creator', 'handle': '@futurecreator', 'text': 'Welcome to Future ✨ A new place to share your world.', 'likes': '128'},
    {'name': 'Nadia Rahman', 'handle': '@nadia', 'text': 'Small moments, big memories. 💜', 'likes': '64'},
  ];

  String tr(String en, String bn) => bangla ? bn : en;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Future',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: navy,
        colorScheme: ColorScheme.fromSeed(seedColor: violet, brightness: Brightness.dark),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(backgroundColor: navy, foregroundColor: Colors.white),
      ),
      home: signedIn ? _mainShell() : AuthScreen(
        bangla: bangla,
        onLanguage: () => setState(() => bangla = !bangla),
        onSuccess: (name) => setState(() { username = name; signedIn = true; }),
      ),
    );
  }

  Widget _mainShell() {
    final pages = [
      FeedScreen(bangla: bangla, posts: posts, onPost: (text) => setState(() => posts.insert(0, {'name': username, 'handle': '@$username', 'text': text, 'likes': '0'}))),
      ReelsScreen(bangla: bangla),
      MessagesScreen(bangla: bangla),
      ProfileScreen(bangla: bangla, username: username, onLogout: () => setState(() { signedIn = false; tab = 0; })),
    ];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        backgroundColor: panel,
        indicatorColor: violet.withOpacity(.28),
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: tr('Home', 'হোম')),
          NavigationDestination(icon: const Icon(Icons.play_circle_outline), selectedIcon: const Icon(Icons.play_circle), label: tr('Reels', 'রিলস')),
          NavigationDestination(icon: const Icon(Icons.chat_bubble_outline), selectedIcon: const Icon(Icons.chat_bubble), label: tr('Messages', 'মেসেজ')),
          NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: tr('Profile', 'প্রোফাইল')),
        ],
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  final bool bangla;
  final VoidCallback onLanguage;
  final ValueChanged<String> onSuccess;
  const AuthScreen({super.key, required this.bangla, required this.onLanguage, required this.onSuccess});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool signup = false;
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  String tr(String en, String bn) => widget.bangla ? bn : en;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF101A3D), navy, Color(0xFF251347)])),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Align(alignment: Alignment.topRight, child: TextButton.icon(onPressed: widget.onLanguage, icon: const Icon(Icons.language), label: Text(widget.bangla ? 'English' : 'বাংলা'))),
                  const SizedBox(height: 20),
                  Container(width: 92, height: 92, alignment: Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), gradient: const LinearGradient(colors: [violet, cyan]), boxShadow: [BoxShadow(color: violet.withOpacity(.35), blurRadius: 30)]), child: const Icon(Icons.auto_awesome_rounded, size: 48, color: Colors.white)),
                  const SizedBox(height: 22),
                  const Text('Future', textAlign: TextAlign.center, style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                  Text(tr('Your world. Your people.', 'তোমার দুনিয়া, তোমার মানুষ।'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 15)),
                  const SizedBox(height: 34),
                  Text(signup ? tr('Create your account', 'নতুন অ্যাকাউন্ট তৈরি করো') : tr('Welcome back', 'আবার স্বাগতম'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 18),
                  if (signup) _field(name, tr('Your name', 'তোমার নাম'), Icons.person_outline),
                  _field(email, tr('Email or phone', 'ইমেইল অথবা ফোন'), Icons.alternate_email),
                  _field(password, tr('Password', 'পাসওয়ার্ড'), Icons.lock_outline, secret: true),
                  const SizedBox(height: 12),
                  Container(decoration: BoxDecoration(gradient: const LinearGradient(colors: [violet, Color(0xFF536DFF)]), borderRadius: BorderRadius.circular(16)), child: FilledButton(onPressed: () {
                    if (email.text.trim().isEmpty || password.text.isEmpty || (signup && name.text.trim().isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('Please fill in all required fields.', 'সব প্রয়োজনীয় ঘর পূরণ করো।'))));
                      return;
                    }
                    widget.onSuccess(signup ? name.text.trim() : (name.text.trim().isEmpty ? email.text.split('@').first : name.text.trim()));
                  }, style: FilledButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 17)), child: Text(signup ? tr('Create account', 'অ্যাকাউন্ট তৈরি') : tr('Log in', 'লগইন'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                  ),
                  const SizedBox(height: 12),
                  TextButton(onPressed: () => setState(() => signup = !signup), child: Text(signup ? tr('Already have an account? Log in', 'অ্যাকাউন্ট আছে? লগইন করো') : tr('New to Future? Create an account', 'Future-এ নতুন? অ্যাকাউন্ট খোলো'))),
                  const SizedBox(height: 28),
                  const Text('A fresh space to connect ✦', textAlign: TextAlign.center, style: TextStyle(color: Colors.white38)),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon, {bool secret = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(controller: c, obscureText: secret, decoration: InputDecoration(prefixIcon: Icon(icon), labelText: label, filled: true, fillColor: Colors.white.withOpacity(.06), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
  );
}

class FeedScreen extends StatefulWidget {
  final bool bangla;
  final List<Map<String, String>> posts;
  final ValueChanged<String> onPost;
  const FeedScreen({super.key, required this.bangla, required this.posts, required this.onPost});
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String tr(String en, String bn) => widget.bangla ? bn : en;
  final composer = TextEditingController();
  @override
  Widget build(BuildContext context) => CustomScrollView(slivers: [
    SliverAppBar(pinned: true, title: const Text('Future', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: .5)), actions: [IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('Notifications will be added with backend setup.', 'ব্যাকএন্ড যুক্ত হলে নোটিফিকেশন চালু হবে।')))), icon: const Icon(Icons.notifications_none)), const SizedBox(width: 8)]),
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 14), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(22), border: Border.all(color: violet.withOpacity(.25))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const CircleAvatar(backgroundColor: violet, child: Icon(Icons.person, color: Colors.white)), const SizedBox(width: 12), Expanded(child: TextField(controller: composer, decoration: InputDecoration(hintText: tr('What is happening in your world?', 'তোমার মনে কী চলছে?'), border: InputBorder.none)))]),
      const Divider(color: Colors.white12),
      Row(children: [const Icon(Icons.image_outlined, color: cyan), const SizedBox(width: 5), Text(tr('Photo / video', 'ছবি / ভিডিও'), style: const TextStyle(color: Colors.white70)), const Spacer(), FilledButton.icon(onPressed: () { if (composer.text.trim().isNotEmpty) { widget.onPost(composer.text.trim()); composer.clear(); FocusScope.of(context).unfocus(); } else { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('Write something first.', 'আগে কিছু লিখো।')))); } }, icon: const Icon(Icons.send, size: 16), label: Text(tr('Post', 'পোস্ট'))) ])
    ])))),
    SliverToBoxAdapter(child: SizedBox(height: 100, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), children: const [
      _Story(name: 'Your story', color: violet, icon: Icons.add),
      _Story(name: 'Nadia', color: Color(0xFFEC4899), icon: Icons.face),
      _Story(name: 'Rafi', color: cyan, icon: Icons.bolt),
      _Story(name: 'Maya', color: Color(0xFF10B981), icon: Icons.spa),
      _Story(name: 'Arif', color: Color(0xFFF59E0B), icon: Icons.star),
    ]))),
    SliverList(delegate: SliverChildBuilderDelegate((context, i) => _PostCard(post: widget.posts[i], bangla: widget.bangla), childCount: widget.posts.length)),
    const SliverToBoxAdapter(child: SizedBox(height: 20)),
  ]);
}

class _Story extends StatelessWidget {
  final String name; final Color color; final IconData icon;
  const _Story({required this.name, required this.color, required this.icon});
  @override
  Widget build(BuildContext context) => SizedBox(width: 76, child: Column(children: [Container(padding: const EdgeInsets.all(3), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 2)), child: CircleAvatar(radius: 25, backgroundColor: color.withOpacity(.18), child: Icon(icon, color: color))), const SizedBox(height: 5), Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11))]));
}

class _PostCard extends StatefulWidget {
  final Map<String, String> post; final bool bangla;
  const _PostCard({required this.post, required this.bangla});
  @override
  State<_PostCard> createState() => _PostCardState();
}
class _PostCardState extends State<_PostCard> {
  bool liked = false;
  @override
  Widget build(BuildContext context) {
    final p = widget.post;
    return Container(margin: const EdgeInsets.fromLTRB(16, 7, 16, 9), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white.withOpacity(.05))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const CircleAvatar(backgroundColor: Color(0xFF393064), child: Icon(Icons.person, color: Colors.white)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p['name']!, style: const TextStyle(fontWeight: FontWeight.bold)), Text(p['handle']!, style: const TextStyle(color: Colors.white54, fontSize: 12))])), const Icon(Icons.more_horiz)]),
      const SizedBox(height: 14), Text(p['text']!, style: const TextStyle(fontSize: 15, height: 1.4)),
      const SizedBox(height: 16), Container(height: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), gradient: const LinearGradient(colors: [violet, cyan]))),
      const SizedBox(height: 10), Row(children: [
        TextButton.icon(onPressed: () => setState(() => liked = !liked), icon: Icon(liked ? Icons.favorite : Icons.favorite_border, color: liked ? Colors.pinkAccent : Colors.white70), label: Text('${int.parse(p['likes']!) + (liked ? 1 : 0)}')),
        TextButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.bangla ? 'কমেন্ট ফিচার ব্যাকএন্ডে যুক্ত হবে।' : 'Comments will be enabled with backend setup.'))), icon: const Icon(Icons.mode_comment_outlined), label: Text(widget.bangla ? 'কমেন্ট' : 'Comment')),
        const Spacer(), IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.bangla ? 'শেয়ার ফিচার পরে যুক্ত হবে।' : 'Sharing will be added later.'))), icon: const Icon(Icons.share_outlined))
      ])
    ]));
  }
}

class ReelsScreen extends StatelessWidget {
  final bool bangla;
  const ReelsScreen({super.key, required this.bangla});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(bangla ? 'Future Reels' : 'Future Reels')), body: Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF2D1457), navy, Color(0xFF10344B)])), child: Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(width: 110, height: 110, decoration: BoxDecoration(shape: BoxShape.circle, color: violet.withOpacity(.2), boxShadow: [BoxShadow(color: violet.withOpacity(.3), blurRadius: 40)]), child: const Icon(Icons.play_arrow_rounded, size: 70, color: Colors.white)),
    const SizedBox(height: 24), Text(bangla ? 'তোমার পরের প্রিয় ভিডিও এখানেই' : 'Your next favorite video is here', textAlign: TextAlign.center, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12), Text(bangla ? 'ভিডিও প্লেয়ার ও আপলোড চালু করতে মিডিয়া স্টোরেজ এবং ব্যাকএন্ড যুক্ত করতে হবে।' : 'Connect media storage and a backend to enable video playback and uploads.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, height: 1.5)),
    const SizedBox(height: 22), const Chip(avatar: Icon(Icons.construction, size: 18), label: Text('Phase 2 feature'))
  ])))));
}

class MessagesScreen extends StatelessWidget {
  final bool bangla;
  const MessagesScreen({super.key, required this.bangla});
  @override
  Widget build(BuildContext context) {
    final people = [
      ('Nadia Rahman', 'Hey! Welcome to Future 💜', Color(0xFFEC4899)),
      ('Rafi Ahmed', 'Did you see the new reel?', cyan),
      ('Maya Islam', 'Sent you a photo', Color(0xFF10B981)),
    ];
    return Scaffold(appBar: AppBar(title: Text(bangla ? 'মেসেজ' : 'Messages')), body: ListView(padding: const EdgeInsets.all(12), children: [
      Padding(padding: const EdgeInsets.all(8), child: TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: bangla ? 'মেসেজ খুঁজুন' : 'Search messages', filled: true, fillColor: panel, border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none)))),
      for (final p in people) ListTile(contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8), leading: CircleAvatar(backgroundColor: p.$3.withOpacity(.2), child: Icon(Icons.person, color: p.$3)), title: Text(p.$1, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(p.$2, maxLines: 1, overflow: TextOverflow.ellipsis), trailing: const Icon(Icons.chevron_right), onTap: () => showDialog(context: context, builder: (_) => AlertDialog(title: Text(p.$1), content: Text(bangla ? 'রিয়েল-টাইম চ্যাট চালু করতে সার্ভার ও ডেটাবেস প্রয়োজন।' : 'A server and database are needed to enable real-time chat.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]))),
    ]));
  }
}

class ProfileScreen extends StatelessWidget {
  final bool bangla; final String username; final VoidCallback onLogout;
  const ProfileScreen({super.key, required this.bangla, required this.username, required this.onLogout});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(bangla ? 'প্রোফাইল' : 'Profile'), actions: [IconButton(onPressed: onLogout, tooltip: bangla ? 'লগআউট' : 'Log out', icon: const Icon(Icons.logout))]), body: ListView(padding: const EdgeInsets.all(20), children: [
    Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), gradient: const LinearGradient(colors: [Color(0xFF38236D), Color(0xFF172B4D)])), child: Column(children: [
      Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [violet, cyan])), child: const CircleAvatar(radius: 44, backgroundColor: navy, child: Icon(Icons.person, size: 48))),
      const SizedBox(height: 14), Text(username, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text('@${username.toLowerCase().replaceAll(' ', '')}', style: const TextStyle(color: Colors.white70)), const SizedBox(height: 16),
      Text(bangla ? 'Future-এ আমার নিজস্ব জায়গা ✨' : 'My own space on Future ✨', style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 18), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ _stat('12', bangla ? 'পোস্ট' : 'Posts'), _stat('248', bangla ? 'বন্ধু' : 'Friends'), _stat('1.2K', bangla ? 'ফলোয়ার' : 'Followers') ]),
      const SizedBox(height: 18), OutlinedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(bangla ? 'প্রোফাইল এডিট পরে যুক্ত হবে।' : 'Profile editing will be added later.'))), icon: const Icon(Icons.edit), label: Text(bangla ? 'প্রোফাইল এডিট' : 'Edit profile'))
    ])),
    const SizedBox(height: 20), Text(bangla ? 'তোমার অ্যাকাউন্ট' : 'Your account', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    const ListTile(leading: Icon(Icons.lock_outline), title: Text('Privacy & security'), trailing: Icon(Icons.chevron_right)),
    const ListTile(leading: Icon(Icons.settings_outlined), title: Text('Settings'), trailing: Icon(Icons.chevron_right)),
    const SizedBox(height: 14), Text(bangla ? 'এটি প্রাথমিক ডেমো। আসল অ্যাকাউন্ট ও ডেটা সংরক্ষণের জন্য ব্যাকএন্ড যুক্ত করতে হবে।' : 'This is an initial demo. Add a backend for real accounts and persistent data.', style: const TextStyle(color: Colors.white54, height: 1.5))
  ]));
  Widget _stat(String n, String label) => Column(children: [Text(n, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12))]);
}
