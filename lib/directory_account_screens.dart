import 'package:flutter/material.dart';
import 'booking_screen.dart'; // Needed for navigation
import 'data_manager.dart';   // Needed for Transaction History data

// --- DIRECTORY SCREEN ---
class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  String _filter = "All";
  final List<ProfessionalModel> _allPros = DataManager.getProfessionals();

  @override
  Widget build(BuildContext context) {
    List<ProfessionalModel> displayedPros = _allPros;
    if (_filter == "Nurses") {
      displayedPros = _allPros.where((p) => p.role == "Nurse").toList();
    } else if (_filter == "Nannies") {
      displayedPros = _allPros.where((p) => p.role == "Nanny").toList();
    } else if (_filter == "4.5+") {
      displayedPros =
          _allPros.where((p) => double.parse(p.rating) >= 4.5).toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Verified Professionals")),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: ["All", "Nurses", "Nannies", "4.5+"].map((f) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: _filter == f,
                    onSelected: (b) => setState(() => _filter = f),
                    selectedColor: const Color(0xFF2E3192),
                    labelStyle: TextStyle(
                      color: _filter == f ? Colors.white : Colors.black,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: _filter == f
                            ? const Color(0xFF2E3192)
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedPros.length,
              itemBuilder: (context, index) {
                final pro = displayedPros[index];
                return _buildProCard(context, pro);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProCard(BuildContext context, ProfessionalModel pro) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showProProfile(context, pro),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Hero(
                  tag: pro.name,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(pro.imageUrl),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pro.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3192),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${pro.role} • ${pro.experience}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4DE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star,
                                size: 14, color: Color(0xFFFBBF24)),
                            const SizedBox(width: 4),
                            Text(
                              pro.rating,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB45309),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const BookingScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E3192),
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Book"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProProfile(BuildContext context, ProfessionalModel pro) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(pro.imageUrl),
            ),
            const SizedBox(height: 16),
            Text(
              pro.name,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2E3192)),
            ),
            Text(
              pro.role,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "About Professional",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Experienced ${pro.role} with over ${pro.experience} in child care and medical support. "
              "Certified, background checked, and highly rated by parents in your area.",
              style: const TextStyle(height: 1.5, color: Colors.black87),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BookingScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E3192),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Book Now",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// --- ACCOUNT SCREEN ---
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2E3192), Color(0xFF1A1E4D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=11'), // Dummy User
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mudassar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "mudassar@example.com",
                        style: TextStyle(color: Color(0xFFE8EAFF)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Body Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle("Payment Methods"),
                  const SizedBox(height: 15),
                  
                  // --- PAYMENT CARDS (AS REQUESTED) ---
                  const PaymentCard(
                    name: "JazzCash",
                    balance: "PKR 5,450 Available",
                    icon: Icons.account_balance_wallet_rounded,
                    hasLogo: true, // Shows Gold/Yellow icon background
                    isLinked: true,
                  ),
                  const SizedBox(height: 12),
                  const PaymentCard(
                    name: "EasyPaisa",
                    balance: "Link your account",
                    icon: Icons.account_balance_rounded,
                    hasLogo: false,
                    isLinked: false,
                  ),
                  const SizedBox(height: 12),
                  const PaymentCard(
                    name: "Meezan Bank",
                    balance: "**** **** **** 4242",
                    icon: Icons.credit_card_rounded,
                    hasLogo: false,
                    isLinked: true,
                  ),

                  const SizedBox(height: 30),
                  const SectionTitle("Settings & Support"),
                  const SizedBox(height: 15),

                  _buildSettingsTile(
                    context,
                    Icons.receipt_long_rounded,
                    "Transaction History",
                    const TransactionHistoryScreen(),
                    Colors.orange,
                  ),
                  _buildSettingsTile(
                    context,
                    Icons.privacy_tip_rounded,
                    "Privacy & Policy",
                    const PolicyScreen(),
                    Colors.purple,
                  ),
                  _buildSettingsTile(
                    context,
                    Icons.support_agent_rounded,
                    "Help & Govt Support",
                    const HelpSupportScreen(),
                    Colors.blue,
                  ),
                   _buildSettingsTile(
                    context,
                    Icons.settings_rounded,
                    "App Settings",
                    const SettingsScreen(),
                    Colors.grey,
                  ),

                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      "Your Baby App v1.0.0",
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title,
      Widget screen, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            size: 16, color: Colors.grey),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        },
      ),
    );
  }
}

// --- REUSABLE COMPONENTS (From your Request) ---

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF2E3192),
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  final String name, balance;
  final IconData icon;
  final bool hasLogo;
  final bool isLinked;

  const PaymentCard({
    super.key,
    required this.name,
    required this.balance,
    required this.icon,
    this.hasLogo = false,
    this.isLinked = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // Fixed for compatibility
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: hasLogo
                  ? const Color(0xFFFBBF24)
                  : const Color(0xFF2E3192).withOpacity(0.1), // Fixed
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 28,
              color: hasLogo ? Colors.white : const Color(0xFF2E3192),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF2E3192),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  balance,
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              backgroundColor: isLinked
                  ? const Color(0xFFDC2626)
                  : const Color(0xFF2E3192),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              isLinked ? "Unlink" : "Link",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// --- SUB SCREENS ---

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = DataManager.userBookings; // Getting real data
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: const Color(0xFF2E3192),
      ),
      backgroundColor: const Color(0xFFF5F7FF),
      body: bookings.isEmpty 
      ? const Center(child: Text("No transactions found", style: TextStyle(color: Colors.grey)))
      : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, i) {
          final b = bookings[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04), // Fixed
                  blurRadius: 12,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E3192).withOpacity(0.1),
                    shape: BoxShape.circle
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: Color(0xFF2E3192),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b['service'] ?? 'Service',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        b['price'] ?? 'PKR 0',
                        style: const TextStyle(color: Color(0xFF666666)),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      b['status'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      b['date'] ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Policy'),
        backgroundColor: const Color(0xFF2E3192),
      ),
      backgroundColor: const Color(0xFFF5F7FF),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Privacy',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E3192),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'This app collects basic booking information (Name, Address, Contact) to process childcare requests. We do not share personal data with third parties except where required by law. Please contact support for data deletion or access.',
                style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
              ),
              SizedBox(height: 20),
              Text(
                'Safety Measures',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E3192),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'All professionals listed in the Directory are verified via background checks. However, parents are advised to conduct their own interviews before hiring.',
                style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: const Color(0xFF2E3192),
      ),
      backgroundColor: const Color(0xFFF5F7FF),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Official Resources',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E3192),
              ),
            ),
            const SizedBox(height: 12),
            _buildSupportTile(Icons.phone_in_talk, "Child Protection Bureau (1121)", "Call Helpline"),
            _buildSupportTile(Icons.local_police, "Police Emergency (15)", "Call Police"),
            _buildSupportTile(Icons.medical_services, "Edhi Ambulance (115)", "Medical Emergency"),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportTile(IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2E3192), size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.call, color: Colors.green),
        onTap: () {},
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the last booking to show real data in settings
    final bookings = DataManager.userBookings;
    final last = bookings.isNotEmpty ? bookings.last : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF2E3192),
      ),
      backgroundColor: const Color(0xFFF5F7FF),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E3192),
              ),
            ),
            const SizedBox(height: 12),
            last == null
                ? Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: const Text(
                      'No bookings yet. Settings will populate once you make a booking.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04), // Fixed
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Last Service Booked:", style: TextStyle(color: Colors.grey)),
                            Text(
                              last['service'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Date:", style: TextStyle(color: Colors.grey)),
                            Text(last['date'] ?? ''),
                          ],
                        ),
                        const SizedBox(height: 6),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Current Status:", style: TextStyle(color: Colors.grey)),
                            Text(last['status'] ?? '', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 30),
             const Text(
              'General',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E3192),
              ),
            ),
            const SizedBox(height: 10),
            const Card(child: ListTile(title: Text("Notifications"), trailing: Switch(value: true, onChanged: null))),
            const Card(child: ListTile(title: Text("Dark Mode"), trailing: Switch(value: false, onChanged: null))),
          ],
        ),
      ),
    );
  }
}